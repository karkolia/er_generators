// ignore_for_file: lines_longer_than_80_chars
import 'package:build/build.dart';
import 'package:source_gen/source_gen.dart';

import 'src/wrap_methods_generator.dart';

Builder WrapMethods(BuilderOptions options) => SharedPartBuilder([WrapMethodsGenerator()], 'wrap_methods_generator');
