library comments_remover;

import 'dart:io';
import 'package:path/path.dart' as p;

class CommentOptions {
  final bool removeSingleLine;
  final bool removeMultiLine;

  CommentOptions({
    this.removeSingleLine = true,
    this.removeMultiLine = true,
  });
}

class CommentsRemover {
  static void removeComments({
    required String path,
    required CommentOptions options,
  }) {
    final entity = FileSystemEntity.typeSync(path);

    if (entity == FileSystemEntityType.notFound) {
      print('Error: "$path" does not exist.');
      return;
    }

    if (entity == FileSystemEntityType.file) {
      final file = File(path);
      if (file.path.endsWith('.dart')) {
        _processFile(file, options);
      } else {
        print('Error: "$path" is not a Dart file.');
      }
      return;
    }

    final dir = Directory(path);
    final entities = dir.listSync(recursive: true);
    for (var entity in entities) {
      if (entity is File && entity.path.endsWith('.dart')) {
        _processFile(entity, options);
      }
    }
    print('Comments removed successfully.');
  }

  static void _processFile(File file, CommentOptions options) {
    try {
      String content = file.readAsStringSync();
      String updatedContent = content;

      if (options.removeMultiLine) {
        updatedContent = updatedContent.replaceAll(
          RegExp(r'/\*.*?\*/', dotAll: true),
          '',
        );
      }

      if (options.removeSingleLine) {
        updatedContent = updatedContent.split('\n').map((line) {
          final trimmedLine = line.trim();
          if (trimmedLine.startsWith('//')) {
            return '';
          }
          final index = line.indexOf('//');
          if (index > -1 && !line.contains('://')) {
            return line.substring(0, index);
          }
          return line;
        }).join('\n');
      }

      file.writeAsStringSync(updatedContent);
      print('Processed: ${p.basename(file.path)}');
    } catch (e) {
      print('Error processing ${p.basename(file.path)}: $e');
    }
  }
}
