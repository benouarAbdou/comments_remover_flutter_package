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

  for (int i = 0; i < code.length; i++) {
    
    if (inSingleLineComment) {
      if (code[i] == '\n') {
        inSingleLineComment = false;
        buffer.write('\n');
      }
      continue;
    }

    
    if (inMultiLineComment) {
      if (i < code.length - 1 && code[i] == '*' && code[i + 1] == '/') {
        inMultiLineComment = false;
        i++; 
      }
      continue;
    }

    
    if (inString) {
      buffer.write(code[i]);
      
      if (code[i] == stringDelimiter && (i == 0 || code[i - 1] != '\\')) {
        inString = false;
        stringDelimiter = null;
      }
      continue;
    }

    // Check if a string literal starts.
    if (code[i] == '"' || code[i] == '\'') {
      inString = true;
      stringDelimiter = code[i];
      buffer.write(code[i]);
      continue;
    }

    // Check for the start of a single-line comment.
    if (removeSingleLine &&
        i < code.length - 1 &&
        code[i] == '/' &&
        code[i + 1] == '/') {
      inSingleLineComment = true;
      i++; // Skip second '/'
      continue;
    }

    // Check for the start of a multi-line comment.
    if (removeMultiLine &&
        i < code.length - 1 &&
        code[i] == '/' &&
        code[i + 1] == '*') {
      inMultiLineComment = true;
      i++; // Skip '*'
      continue;
    }

    // Otherwise, just copy the character.
    buffer.write(code[i]);
  }

  return buffer.toString();
}
