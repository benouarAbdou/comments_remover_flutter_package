import 'package:comments_remover/comments_remover.dart';

void main() {
  // Example 1: Remove all comments from the lib directory
  CommentsRemover.removeComments(
    directoryPath: 'lib',
    options: CommentOptions(),
  );

  // Example 2: Remove only single-line comments
  CommentsRemover.removeComments(
    directoryPath: 'lib',
    options: CommentOptions(removeMultiLine: false),
  );

  // Example 3: Remove comments from a specific file
  CommentsRemover.removeComments(
    options: CommentOptions(specificFile: 'lib/main.dart'),
  );
}
