library comments_remover;

import 'dart:io';
import 'package:path/path.dart' as p;

/// Options for comment removal.
class CommentOptions {
  final bool removeSingleLine; // Remove // comments
  final bool removeMultiLine; // Remove /* */ comments
  final String? specificFile; // Path to a specific file (optional)

  CommentOptions({
    this.removeSingleLine = true,
    this.removeMultiLine = true,
    this.specificFile,
  });
}

/// Removes comments from Dart files in the specified directory or file.
class CommentsRemover {
  /// Removes comments based on the provided options.
  static void removeComments({
    String directoryPath = 'lib',
    required CommentOptions options,
  }) {
    final dir = Directory(directoryPath);

    if (!dir.existsSync()) {
      print('Directory "$directoryPath" does not exist.');
      return;
    }

    // If a specific file is provided, process only that file
    if (options.specificFile != null) {
      final file = File(options.specificFile!);
      if (file.existsSync() && file.path.endsWith('.dart')) {
        _processFile(file, options);
      } else {
        print(
            'File "${options.specificFile}" does not exist or is not a Dart file.');
      }
      return;
    }

    // Otherwise, process all Dart files in the directory
    final entities = dir.listSync(recursive: true);
    for (var entity in entities) {
      if (entity is File && entity.path.endsWith('.dart')) {
        _processFile(entity, options);
      }
    }
    print('Comments removed successfully.');
  }

  /// Processes a single file and removes comments based on options.
  static void _processFile(File file, CommentOptions options) {
    try {
      String content = file.readAsStringSync();
      String updatedContent = content;

      // Remove multi-line comments (/* */)
      if (options.removeMultiLine) {
        updatedContent = updatedContent.replaceAll(
          RegExp(r'/\*.*?\*/', dotAll: true),
          '',
        );
      }

      // Remove single-line comments (//)
      if (options.removeSingleLine) {
        updatedContent = updatedContent.split('\n').map((line) {
          final trimmedLine = line.trim();
          if (trimmedLine.startsWith('//')) {
            return '';
          }
          final index = line.indexOf('//');
          if (index > -1 && !line.contains('://')) {
            // Avoid removing URLs
            return line.substring(0, index);
          }
          return line;
        }).join('\n');
      }

      // Write the updated content back to the file
      file.writeAsStringSync(updatedContent);
      print('Processed: ${p.basename(file.path)}');
    } catch (e) {
      print('Error processing ${p.basename(file.path)}: $e');
    }
  }
}
