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
      expect(content, equals('void main() {\n print("Hello");}'));
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

    test('Keep blank lines', () {
      tempFile.writeAsStringSync('''
        void main() {
          
          print("Hello");
          // Comment to remove
          
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

    test('Remove inline comments only', () {
      tempFile.writeAsStringSync('print("Hello"); // Inline comment');
      final content = removeComments(tempFile.readAsStringSync(), true, false);
      expect(content, equals('print("Hello"); '));
    });

    test('Remove multi-line comments spanning multiple lines', () {
      tempFile.writeAsStringSync('''
        /*
        This is a multi-line comment
        that spans multiple lines
        */
        print("Hello");
      ''');
      final content = removeComments(tempFile.readAsStringSync(), false, true);
      expect(content, equals('''
        
        print("Hello");
      '''));
    });

    test('Ignore escaped quotes in strings', () {
      tempFile.writeAsStringSync('print("This is a \"string\" with quotes");');
      final content = removeComments(tempFile.readAsStringSync(), true, true);
      expect(content, equals('print("This is a \"string\" with quotes");'));
    });

    test('Remove comment in function body', () {
      tempFile.writeAsStringSync('''
        void test() {\n// Remove this comment\nint x = 5;\n}\n''');
      final content = removeComments(tempFile.readAsStringSync(), true, true);
      expect(content, equals('''
        void test() {\nint x = 5;\n}\n'''));
    });

    test('Remove multiple single-line comments', () {
      tempFile.writeAsStringSync(
          '''\n// First comment\nvoid main() {\nprint("Hello"); // Inline comment\n// Another comment\nprint("World");\n}\n''');
      final content = removeComments(tempFile.readAsStringSync(), true, false);
      expect(
          content,
          equals(
              '''\nvoid main() {\nprint("Hello"); \nprint("World");\n}\n'''));
    });
  });
}
