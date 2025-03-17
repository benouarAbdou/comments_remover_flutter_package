import 'dart:io';
import 'package:args/args.dart';
import 'package:comments_remover/comments_remover.dart';

void main(List<String> arguments) {
  final parser = ArgParser()
    ..addOption('path',
        abbr: 'p',
        defaultsTo: 'lib',
        help: 'Directory or file path to process (default: lib)')
    ..addFlag('single-line',
        defaultsTo: true, help: 'Remove single-line comments (//)')
    ..addFlag('multi-line',
        defaultsTo: true, help: 'Remove multi-line comments (/* */)')
    ..addFlag('help',
        abbr: 'h', negatable: false, help: 'Show usage information');

  try {
    final results = parser.parse(arguments);

    if (results['help']) {
      print('Usage: comments_remover [options]');
      print(parser.usage);
      exit(0);
    }

    final path = results['path'] as String;
    final removeSingleLine = results['single-line'] as bool;
    final removeMultiLine = results['multi-line'] as bool;

    CommentsRemover.removeComments(
      path: path,
      options: CommentOptions(
        removeSingleLine: removeSingleLine,
        removeMultiLine: removeMultiLine,
      ),
    );
  } catch (e) {
    print('Error: $e');
    print('Usage: comments_remover [options]');
    print(parser.usage);
    exit(1);
  }
}
