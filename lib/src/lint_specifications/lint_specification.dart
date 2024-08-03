import 'package:analyzer/dart/ast/ast.dart';
import 'package:flutter_clean_code/src/ast_extensions/ast_extensions.dart';

part 'base_specification.dart';

class ImportSpecification extends LintSpecification {
  ImportSpecification();

  @override
  bool isSatisfiedBy(AstNode element) => element is Directive;
}

class ConstructorSpecification extends LintSpecification {
  ConstructorSpecification();

  @override
  bool isSatisfiedBy(AstNode element) => element.isWidgetConstructor;
}

class ClassSpecification extends LintSpecification {
  ClassSpecification();

  @override
  bool isSatisfiedBy(AstNode element) => element.isWidgetClass;
}

class InsideWidgetSpecification extends LintSpecification {
  InsideWidgetSpecification();

  @override
  bool isSatisfiedBy(AstNode element) => element.isWithinWidget;
}

class AssertionSpecification extends LintSpecification {
  AssertionSpecification();

  @override
  bool isSatisfiedBy(AstNode element) =>
      element is Assertion ||
      element.childEntities.any((e) => e is AstNode && isSatisfiedBy(e));
}

class StringLiteralInsideWidgetSpecification extends LintSpecification {
  StringLiteralInsideWidgetSpecification();

  final _isNotImport = ImportSpecification().not();
  final _isConstructor = ConstructorSpecification();
  final _isClass = ClassSpecification();
  final _isNotAssertion = AssertionSpecification().not();
  final _isCompilationUnit = InsideWidgetSpecification();
  late final _specification = _isNotAssertion.and(_isNotImport).and(
        AnySpecification(
          [
            _isConstructor,
            _isClass,
            _isCompilationUnit,
          ],
        ),
      );

  @override
  bool isSatisfiedBy(AstNode element) {
    return _specification.isSatisfiedBy(element);
  }

  @override
  String toString() => '$_specification';
}
