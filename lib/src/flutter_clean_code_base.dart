import 'package:custom_lint_builder/custom_lint_builder.dart';
import 'package:analyzer/dart/analysis/results.dart';

import 'lint_rules/LintRuleAvoidStringLiteralsUsageInsideWidget.dart';

PluginBase createPlugin() => _FlutterCleanCode();

class _FlutterCleanCode extends PluginBase {
  _FlutterCleanCode();

  LintRule? createLint(ResolvedUnitResult resolvedUnitResult) {
    return null;
  }

  @override
  List<LintRule> getLintRules(CustomLintConfigs configs) {
    final enabled = configs.enableAllLintRules ?? true;
    if (!enabled) {
      return [];
    }

    return [
      const LintRuleAvoidStringLiteralsUsageInsideWidget(),
    ];
  }
}
