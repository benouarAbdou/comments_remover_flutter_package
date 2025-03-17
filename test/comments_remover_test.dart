import 'dart:io';
import 'package:comments_remover/comments_remover.dart';
import 'package:test/test.dart';

void main() {
  test('Remove single-line comments', () {
    final tempFile = File('test_temp.dart');
    tempFile.writeAsStringSync(
        'void main() { // Test comment\n  print("Hello");\n}');
    CommentsRemover.removeComments(
      options: CommentOptions(
          specificFile: 'test_temp.dart', removeMultiLine: false),
    );
    final content = tempFile.readAsStringSync();
    expect(content, equals('void main() { \n  print("Hello");\n}'));
    tempFile.deleteSync();
  });

  test('Remove multi-line comments', () {
    final tempFile = File('test_temp.dart');
    tempFile.writeAsStringSync(
        'void main() {/* Multi-line\ncomment */ print("Hello");}');
    CommentsRemover.removeComments(
      options: CommentOptions(
          specificFile: 'test_temp.dart', removeSingleLine: false),
    );
    final content = tempFile.readAsStringSync();
    expect(content, equals('void main() { print("Hello");}'));
    tempFile.deleteSync();
  });
}
