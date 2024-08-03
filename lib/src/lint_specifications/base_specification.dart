part of 'lint_specification.dart';

abstract class LintSpecification {
  bool isSatisfiedBy(AstNode element);

  LintSpecification and(LintSpecification other) =>
      AndSpecification(this, other);

  LintSpecification or(LintSpecification other) => OrSpecification(this, other);

  LintSpecification not() => NotSpecification(this);
}

class AndSpecification extends LintSpecification {
  AndSpecification(this._first, this._second);

  final LintSpecification _first;
  final LintSpecification _second;

  @override
  bool isSatisfiedBy(AstNode element) =>
      _first.isSatisfiedBy(element) && _second.isSatisfiedBy(element);

  @override
  String toString() => '($_first AND $_second)';
}

class OrSpecification extends LintSpecification {
  OrSpecification(this._first, this._second);

  final LintSpecification _first;
  final LintSpecification _second;

  @override
  bool isSatisfiedBy(AstNode element) =>
      _first.isSatisfiedBy(element) || _second.isSatisfiedBy(element);

  @override
  String toString() => '($_first OR $_second)';
}

class NotSpecification extends LintSpecification {
  NotSpecification(this._specification);

  final LintSpecification _specification;

  @override
  bool isSatisfiedBy(AstNode element) => !_specification.isSatisfiedBy(element);

  @override
  String toString() => '(NOT $_specification)';
}

class AnySpecification extends LintSpecification {
  AnySpecification(this._specifications);

  final List<LintSpecification> _specifications;

  LintSpecification get combined => _specifications.reduce((a, b) => a.or(b));

  @override
  bool isSatisfiedBy(AstNode element) => combined.isSatisfiedBy(element);

  @override
  String toString() => '$combined';
}

class AllSpecification extends LintSpecification {
  AllSpecification(this._specifications);

  final List<LintSpecification> _specifications;

  LintSpecification get combined => _specifications.reduce((a, b) => a.and(b));

  @override
  bool isSatisfiedBy(AstNode element) => combined.isSatisfiedBy(element);

  @override
  String toString() => '$combined';
}
