# Comments Remover

A powerful command-line tool for removing comments from Dart files in your Flutter projects. Whether you need a cleaner codebase for production, code reviews, or learning purposes, **Comments Remover** helps you strip out single-line (`//`) and multi-line (`/* */`) comments effortlessly.

## Why Use Comments Remover?

Comments are invaluable during development for documentation and debugging, but there are cases where removing them is useful:

- **Minification**: Reduce file size for production builds, improving performance and readability.
- **Code Review**: Focus on logic and structure without distractions from comments.
- **Learning**: Clean up example projects (e.g., Flutter templates) to study core functionality without extra explanations.
- **Obfuscation**: Remove sensitive or unnecessary annotations before sharing code or submitting assignments.

## Installation

### Prerequisites
Ensure you have Dart installed. You can check by running:
```bash
dart --version
```
If Dart is not installed, follow the [official installation guide](https://dart.dev/get-dart).

### Installing the Package

1. Clone this repository or download the source code:
   ```bash
   git clone https://github.com/benouarAbdou/comments_remover_flutter_package
   cd comments_remover_flutter_package
   ```
2. Install dependencies:
   ```bash
   dart pub get
   ```
3. Activate the package locally:
   ```bash
   dart pub global activate --source path .
   ```

## Usage

### Basic Usage

Remove all comments from all Dart files in the `lib` directory:
```bash
dart run comments_remover
```

### Command Options

| Option | Description |
|--------|-------------|
| `--path` | Specify a target file or directory to process. Defaults to `lib/`. |
| `--single-line` | Remove only single-line comments (`//`). |
| `--multi-line`  | Remove only multi-line comments (`/* */`). |

#### Example Commands

1. Remove all comments from a specific file:
   ```bash
   dart run comments_remover --path lib/main.dart
   ```

2. Remove only single-line comments from all Dart files in `lib`:
   ```bash
   dart run comments_remover --single-line
   ```

3. Remove only multi-line comments from a specific directory:
   ```bash
   dart run comments_remover --path lib/src --multi-line
   ```


## Example Output

### Input File (Before):
```dart
// This is a single-line comment
void main() {
  /* This is a multi-line
     comment */
  print("Hello"); // Inline comment
}
```

### Output File (After):
```dart
void main() {
  print("Hello");
}
```

## Contributing

We welcome contributions! Here’s how you can help:

1. Fork the repository.
2. Create a new branch for your feature or fix.
3. Commit your changes with clear commit messages.
4. Push to your fork and submit a Pull Request.

Feel free to open issues for bug reports, feature requests, or suggestions.

## License

This project is licensed under the MIT License. See the `LICENSE` file for more details.
