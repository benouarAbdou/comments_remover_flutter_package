import 'package:args/args.dart';
import 'package:path/path.dart' as path;
import 'dart:io';

void main(List<String> arguments) {
  final parser = ArgParser()
    ..addOption('path',
        abbr: 'p',
        help: 'Path to the directory or file to process',
        defaultsTo: 'lib')
    ..addFlag('single-line',
        abbr: 's', help: 'Remove single-line comments only', defaultsTo: false)
    ..addFlag('multi-line',
        abbr: 'm', help: 'Remove multi-line comments only', defaultsTo: false);

  final results = parser.parse(arguments);

  final targetPath = results['path'] as String;
  final removeSingleLine = results['single-line'] as bool;
  final removeMultiLine = results['multi-line'] as bool;

  // If neither flag is set, remove both types of comments
  final shouldRemoveSingleLine =
      removeSingleLine || (!removeSingleLine && !removeMultiLine);
  final shouldRemoveMultiLine =
      removeMultiLine || (!removeSingleLine && !removeMultiLine);

  final target = FileSystemEntity.isFileSync(targetPath)
      ? File(targetPath)
      : Directory(targetPath);

  if (!target.existsSync()) {
    print('Error: Path not found: $targetPath');
    exit(1);
  }

  if (target is File) {
    processFile(target, shouldRemoveSingleLine, shouldRemoveMultiLine);
  } else {
    processDirectory(
        target as Directory, shouldRemoveSingleLine, shouldRemoveMultiLine);
  }
}

void processDirectory(
    Directory dir, bool shouldRemoveSingleLine, bool shouldRemoveMultiLine) {
  final entities = dir.listSync(recursive: true);

  for (var entity in entities) {
    if (entity is File && entity.path.endsWith('.dart')) {
      processFile(entity, shouldRemoveSingleLine, shouldRemoveMultiLine);
    }
  }
}

void processFile(
    File file, bool shouldRemoveSingleLine, bool shouldRemoveMultiLine) {
  final content = file.readAsStringSync();
  final lines = content.split('\n');
  final processedLines = <String>[];

  bool inMultiLineComment = false;

  for (var line in lines) {
    if (inMultiLineComment) {
      if (line.contains('*/')) {
        inMultiLineComment = false;
        line = line.substring(line.indexOf('*/') + 2);
      } else {
        continue;
      }
    }

    if (shouldRemoveMultiLine && line.contains('/*')) {
      inMultiLineComment = true;
      line = line.substring(0, line.indexOf('/*'));
    }

    // Remove single-line comments
    if (shouldRemoveSingleLine && line.contains('//')) {
      line = line.substring(0, line.indexOf('//'));
    }

    if (line.trim().isNotEmpty) {
      processedLines.add(line);
    }
  }

  file.writeAsStringSync(processedLines.join('\n'));
  print('Comments removed from ${file.path}');
}
