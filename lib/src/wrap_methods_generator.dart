// ignore_for_file: lines_longer_than_80_chars
import 'package:analyzer/dart/element/element.dart';
import 'package:annotations/annotations.dart';
import 'package:build/src/builder/build_step.dart';
import 'package:source_gen/source_gen.dart';

import 'model_visitor.dart';

class WrapMethodsGenerator extends GeneratorForAnnotation<WrapMethodsAnnotation> {
  @override
  String generateForAnnotatedElement(Element element, ConstantReader annotation, BuildStep buildStep) {
    final visitor = ModelVisitor();
    element.visitChildren(visitor);

    final classBuffer = StringBuffer();

    // start the extension
    classBuffer.writeln('extension ${visitor.className}Companion on ${visitor.className} {');

    // assign variables to Map
    for (final functionName in visitor.functions.keys) {
      final returnType = visitor.functions[functionName];
      if (functionName.startsWith('_')) {
        final publicFunctionName = functionName.replaceFirst('_', '');

        classBuffer.writeln('$returnType $publicFunctionName(${visitor.parameters[functionName]}) async {');
        classBuffer.writeln('return wrap(() async {');
        classBuffer.writeln('return await $functionName(${visitor.parameters[functionName]});');
        classBuffer.writeln('});');
        classBuffer.writeln('}');
      }
    }

    // end the extension
    classBuffer.writeln('}');

    return classBuffer.toString();
  }
}
