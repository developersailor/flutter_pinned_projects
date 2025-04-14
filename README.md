# Flutter Pinned Projects

Flutter Pinned Projects is a Flutter package designed to help you pin projects to the top of the list in a GitHub repository. This package simplifies the process of managing pinned repositories programmatically.

## Features

- Pin projects to the top of a GitHub repository list.
- Easy-to-use API for seamless integration.
- Built with Flutter and Dart.

## Installation

Add the following to your `pubspec.yaml` file:

```yaml
dependencies:
  flutter_pinned_projects: ^0.0.1
```

Then, run:

```bash
flutter pub get
```

## Usage

Import the package:

```dart
import 'package:flutter_pinned_projects/flutter_pinned_projects.dart';
```

Use the `PinnedProjectsWidget` to display pinned projects:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_pinned_projects/flutter_pinned_projects.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('Pinned Projects')),
        body: const PinnedProjectsWidget(username:"username"),
      ),
    );
  }
}
```

## License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.

## Contributing

Contributions are welcome! Please feel free to submit a pull request or open an issue.

## Author

Developed by Mehmet Fiskindal.