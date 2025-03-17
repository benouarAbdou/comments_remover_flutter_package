# Comments Remover

A Dart package to remove comments from Dart files in a Flutter project.

## Features
- Remove single-line comments (`//`)
- Remove multi-line comments (`/* */`)
- Process a specific file or all `.dart` files in a directory (default: `lib`)

## Usage
```dart
import 'package:comments_remover/comments_remover.dart';

void main() {
  // Remove all comments from lib directory
  CommentsRemover.removeComments(options: CommentOptions());

  // Remove only single-line comments
  CommentsRemover.removeComments(
    options: CommentOptions(removeMultiLine: false),
  );

  // Remove comments from a specific file
  CommentsRemover.removeComments(
    options: CommentOptions(specificFile: 'lib/main.dart'),
  );
}