import 'dart:io';
import 'package:test/test.dart';
import 'package:path/path.dart' as path;

import '../bin/comments_remover.dart';

void main() {
  group('Comment Removal Tests', () {
    late File tempFile;

    setUp(() {
      final tempDir = Directory.systemTemp.createTempSync();
      tempFile = File(path.join(tempDir.path, 'test_temp.dart'));
    });

    tearDown(() {
      if (tempFile.existsSync()) {
        tempFile.deleteSync();
      }
    });

    test('Remove single-line comments', () {
      tempFile.writeAsStringSync(
          'void main() { // Test comment\n  print("Hello");\n}');
      final content = removeComments(tempFile.readAsStringSync(), true, false);
      expect(content, equals('void main() { \n  print("Hello");\n}'));
    });

    test('Remove multi-line comments', () {
      tempFile.writeAsStringSync(
          'void main() {/* Multi-line\ncomment */ print("Hello");}');
      final content = removeComments(tempFile.readAsStringSync(), false, true);
      expect(content, equals('void main() { print("Hello");}'));
    });

    test('Preserve strings containing // and /* */', () {
      tempFile.writeAsStringSync(
          'void main() { print("// Not a comment"); print("/* Also not a comment */"); }');
      final content = removeComments(tempFile.readAsStringSync(), true, true);
      expect(
          content,
          equals(
              'void main() { print("// Not a comment"); print("/* Also not a comment */"); }'));
    });

    test('Remove both single-line and multi-line comments', () {
      tempFile.writeAsStringSync('''
        void main() {
          // Single-line comment
          print("Hello");
          /* Multi-line
          comment */
          print("World");
        }
      ''');
      final content = removeComments(tempFile.readAsStringSync(), true, true);
      expect(content, equals('''
        void main() {
          
          print("Hello");
          
          print("World");
        }
      '''));
    });
  });
}
