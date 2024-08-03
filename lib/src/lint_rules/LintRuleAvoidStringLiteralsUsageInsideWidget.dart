import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/error/error.dart';
import 'package:analyzer/error/listener.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';

import '../lint_specifications/lint_specification.dart';

class LintRuleAvoidStringLiteralsUsageInsideWidget extends DartLintRule {
  const LintRuleAvoidStringLiteralsUsageInsideWidget() : super(code: _code);
  static const _code = LintCode(
    name: _name,
    problemMessage: 'Avoid Usage of String Literals.',
    correctionMessage: 'Avoid Hardcoding of Strings.',
    errorSeverity: ErrorSeverity.WARNING,
    uniqueName: _name,
  );

  static const _name = 'Avoid Usage of String Literals.';

  @override
  void run(
    CustomLintResolver resolver,
    ErrorReporter reporter,
    CustomLintContext context,
  ) {
    final specification = StringLiteralInsideWidgetSpecification();

    context.registry.addStringLiteral((node) {
      final w = node.thisOrAncestorMatching<AstNode>(
        specification.isSatisfiedBy,
      );

      if (w != null) {
        reporter.reportErrorForNode(code, node);
      }
    });
    context.registry.addStringInterpolation((node) {
      final w = node.thisOrAncestorMatching<AstNode>(
        specification.isSatisfiedBy,
      );

      if (w != null) {
        reporter.reportErrorForNode(code, node);
      }
    });
  }
}
