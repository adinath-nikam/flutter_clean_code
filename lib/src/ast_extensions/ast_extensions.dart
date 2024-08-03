import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/type.dart';

extension AstParser on AstNode {
  bool get isWidgetClass {
    return this is Expression &&
        ((this as Expression).staticType?.isWidget ?? false);
  }

  bool get isWidgetConstructor {
    return this is ConstructorDeclaration &&
        ((this as ConstructorDeclaration)
                .declaredElement
                ?.returnType
                .allSupertypes
                .any((element) => element.isWidget) ??
            false);
  }

  bool get isWithinWidget {
    return this is VariableDeclaration &&
            ((this as VariableDeclaration)
                    .declaredElement
                    ?.enclosingElement
                    ?.isWidgetClass ??
                false) ||
        _isWithinWidgetRecursively;
  }

  bool get _isWithinWidgetRecursively {
    return this is VariableDeclaration &&
        ((this as VariableDeclaration)
                .declaredElement
                ?.enclosingElement
                ?._recursiveEnclosingElementIsWidget ??
            false);
  }
}

extension _DartTypeParser on DartType {
  bool get isWidget => element?.isWidgetClass ?? false;
}

extension ElementParser on Element {
  bool get _recursiveEnclosingElementIsWidget {
    if (enclosingElement == null) {
      return false;
    }
    if (enclosingElement!.isWidgetClass) {
      return true;
    }
    return enclosingElement!._recursiveEnclosingElementIsWidget;
  }

  bool get _hasBuildMethod =>
      // is interface (every class has an interface)
      this is InterfaceOrAugmentationElement &&
      // has a build method
      (this as InterfaceOrAugmentationElement).methods.any(
            (element) => element._isBuildMethod,
          );

  bool get _isBuildMethod =>
      // is method (or any other function)
      this is FunctionTypedElement &&
      // is named build
      (name == 'build' &&
          // returns Widget
          (this as FunctionTypedElement)
                  .returnType
                  .getDisplayString(withNullability: false) ==
              'Widget');

  bool get _hasCreateStateMethod =>
      // is interface (every class has an interface)
      this is InterfaceOrAugmentationElement &&
      // has a build method
      (this as InterfaceOrAugmentationElement).methods.any(
            (element) => element._isCreateStateMethod,
          );

  bool get _isCreateStateMethod =>
      this is FunctionTypedElement &&
      name == 'createState' &&
      ((this as FunctionTypedElement)
              .returnType
              .element
              ?.children
              .any((element) => element._isBuildMethod) ??
          false);

  bool get isWidgetClass => _hasBuildMethod || _hasCreateStateMethod;
}
