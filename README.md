# Comments Remover

A command-line tool to remove comments from Dart files in a Flutter project. Simplify your codebase by stripping out single-line (`//`) and multi-line (`/* */`) comments, either from a specific file or an entire directory.

## Why Use Comments Remover?

Comments are essential during development for documentation and debugging, but there are scenarios where removing them is beneficial:
- **Minification**: Reduce file size for production builds or analysis
- **Code Review**: Focus on the logic without comment distractions
- **Learning**: Clean up example projects (e.g., the default Flutter counter app) to study core functionality
- **Obfuscation**: Remove sensitive or unnecessary annotations before sharing code

## Installation

1. Clone this repository or download the source code
2. Run `dart pub get` to install dependencies
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

- `--path` or `-p`: Specify the target path (file or directory)
  ```bash
  dart run comments_remover --path lib/main.dart
  dart run comments_remover --path lib/
  ```

- `--single-line` or `-s`: Remove only single-line comments (//)
  ```bash
  dart run comments_remover --single-line
  ```

- `--multi-line` or `-m`: Remove only multi-line comments (/* */)
  ```bash
  dart run comments_remover --multi-line
  ```

### Examples

1. Remove all comments from a specific file:
   ```bash
   dart run comments_remover --path lib/main.dart
   ```

2. Remove only single-line comments from all files in lib:
   ```bash
   dart run comments_remover --single-line
   ```

3. Remove only multi-line comments from a specific directory:
   ```bash
   dart run comments_remover --path lib/src --multi-line
   ```

4. Remove all comments from all Dart files in the current directory:
   ```bash
   dart run comments_remover --path .
   ```

## Testing

Run the test suite:
```bash
dart test
```

The test suite includes:
- Single-line comment removal
- Multi-line comment removal
- Combined comment removal
- Directory processing
- Edge cases and special scenarios

## Example Output

Before:
```dart
// This is a single-line comment
void main() {
  /* This is a multi-line
     comment */
  print("Hello"); // Inline comment
}
```

After (with all comments removed):
```dart
void main() {
  print("Hello");
}
```

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## License

This project is licensed under the MIT License - see the LICENSE file for details.