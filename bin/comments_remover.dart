import 'dart:io';
import 'package:args/args.dart';

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
    Directory dir, bool removeSingleLine, bool removeMultiLine) {
  final entities = dir.listSync(recursive: true);
  for (var entity in entities) {
    if (entity is File && entity.path.endsWith('.dart')) {
      processFile(entity, removeSingleLine, removeMultiLine);
    }
  }
}

void processFile(File file, bool removeSingleLine, bool removeMultiLine) {
  final content = file.readAsStringSync();
  final newContent = removeComments(content, removeSingleLine, removeMultiLine);
  file.writeAsStringSync(newContent);
  print('Comments removed from ${file.path}');
}

String removeComments(
    String code, bool removeSingleLine, bool removeMultiLine) {
  final buffer = StringBuffer();
  bool inString = false;
  String? stringDelimiter;
  bool inSingleLineComment = false;
  bool inMultiLineComment = false;

  List<String> lines = code.split('\n');
  List<String> resultLines = [];

  for (var line in lines) {
    String trimmedLine = line.trim();

    // Skip full-line comments
    if (removeSingleLine && trimmedLine.startsWith('//')) {
      continue;
    }
    if (removeMultiLine &&
        trimmedLine.startsWith('/*') &&
        trimmedLine.endsWith('*/')) {
      continue;
    }

    StringBuffer newLine = StringBuffer();
    for (int i = 0; i < line.length; i++) {
      if (inSingleLineComment) {
        break;
      }
      if (inMultiLineComment) {
        if (i < line.length - 1 && line[i] == '*' && line[i + 1] == '/') {
          inMultiLineComment = false;
          i++;
        }
        continue;
      }
      if (inString) {
        newLine.write(line[i]);
        if (line[i] == stringDelimiter && (i == 0 || line[i - 1] != '\\')) {
          inString = false;
          stringDelimiter = null;
        }
        continue;
      }
      if (line[i] == '"' || line[i] == "'") {
        inString = true;
        stringDelimiter = line[i];
        newLine.write(line[i]);
        continue;
      }
      if (removeSingleLine &&
          i < line.length - 1 &&
          line[i] == '/' &&
          line[i + 1] == '/') {
        break;
      }
      if (removeMultiLine &&
          i < line.length - 1 &&
          line[i] == '/' &&
          line[i + 1] == '*') {
        inMultiLineComment = true;
        i++;
        continue;
      }
      newLine.write(line[i]);
    }
    if (newLine.isNotEmpty || trimmedLine.isEmpty) {
      resultLines.add(newLine.toString());
    }
  }

  return resultLines.join('\n');
}
