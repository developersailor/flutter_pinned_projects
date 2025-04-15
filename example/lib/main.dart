import 'package:flutter/material.dart';
import 'package:flutter_pinned_projects/card_style.dart';
import 'package:flutter_pinned_projects/flutter_pinned_projects.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Pinned Projects Example',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Flutter Pinned Projects Example')),
      body: PinnedProjectsWidget(
        username: "octocat",
        accessToken: "YOUR_GITHUB_TOKEN",
        maxRepos: 6,
        loadingWidget: const Center(child: CircularProgressIndicator()),
        errorWidgetBuilder: (error) => Center(child: Text('Error: $error')),
        emptyWidget: const Center(child: Text('No pinned repositories found.')),
        cardStyle: CardStyle.modern,
      ),
    );
  }
}
