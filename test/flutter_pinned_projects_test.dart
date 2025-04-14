import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_pinned_projects/github_service.dart';
import 'package:flutter_pinned_projects/flutter_pinned_projects.dart';
import 'flutter_pinned_projects_test.mocks.dart';

@GenerateMocks([GithubService])
void main() {
  group('PinnedProjectsWidget', () {
    late MockGithubService mockGithubService;

    setUp(() {
      mockGithubService = MockGithubService();
    });

    testWidgets('displays loading indicator while fetching data', (
      WidgetTester tester,
    ) async {
      when(
        mockGithubService.fetchPinnedRepositories(any),
      ).thenAnswer((_) async => []);

      await tester.pumpWidget(
        MaterialApp(
          home: PinnedProjectsWidget(
            username: 'developersailor',
            githubService: mockGithubService as GithubService?,
          ),
        ),
      );

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('displays error message when fetch fails', (
      WidgetTester tester,
    ) async {
      when(
        mockGithubService.fetchPinnedRepositories(any),
      ).thenAnswer((_) async => throw Exception('Failed to fetch'));

      await tester.pumpWidget(
        MaterialApp(
          home: PinnedProjectsWidget(
            username: 'developersailor',
            githubService: mockGithubService,
          ),
        ),
      );

      await tester.pumpAndSettle(); // Wait for FutureBuilder to rebuild

      expect(find.text('Error: Exception: Failed to fetch'), findsOneWidget);
    });

    testWidgets('displays no data message when no repositories are found', (
      WidgetTester tester,
    ) async {
      when(
        mockGithubService.fetchPinnedRepositories(any),
      ).thenAnswer((_) async => []);

      await tester.pumpWidget(
        MaterialApp(
          home: PinnedProjectsWidget(
            username: 'developersailor',
            githubService: mockGithubService,
          ),
        ),
      );

      await tester.pumpAndSettle(); // Wait for FutureBuilder to rebuild

      expect(find.text('No pinned repositories found.'), findsOneWidget);
    });

    testWidgets('displays a list of repositories when data is available', (
      WidgetTester tester,
    ) async {
      final mockRepos = [
        Repository(
          name: 'Repo 1',
          description: 'Description 1',
          stars: 100,
          language: 'Dart',
          avatarUrl: 'https://example.com/avatar1.png',
          isPinned: false,
        ),
        Repository(
          name: 'Repo 2',
          description: 'Description 2',
          stars: 200,
          language: 'Flutter',
          avatarUrl: 'https://example.com/avatar2.png',
          isPinned: false,
        ),
      ];

      when(
        mockGithubService.fetchPinnedRepositories(any),
      ).thenAnswer((_) async => Future.value(mockRepos));

      await tester.pumpWidget(
        MaterialApp(
          home: Material(
            child: PinnedProjectsWidget(
              username: 'developersailor',
              githubService: mockGithubService,
            ),
          ),
        ),
      );

      await tester.pumpAndSettle(); // Wait for FutureBuilder to rebuild

      expect(find.byType(ListTile), findsNWidgets(2));
      expect(find.text('Repo 1'), findsOneWidget);
      expect(find.text('Repo 2'), findsOneWidget);
      expect(find.text('Description 1'), findsOneWidget);
      expect(find.text('Description 2'), findsOneWidget);
    });

    testWidgets('displays a list of pinned repositories only', (
      WidgetTester tester,
    ) async {
      final mockRepos = [
        Repository(
          name: 'Pinned Repo 1',
          description: 'Pinned Description 1',
          stars: 150,
          language: 'Dart',
          avatarUrl: 'https://example.com/pinned_avatar1.png',
          isPinned: true,
        ),
        Repository(
          name: 'Non-Pinned Repo',
          description: 'Non-Pinned Description',
          stars: 50,
          language: 'JavaScript',
          avatarUrl: 'https://example.com/non_pinned_avatar.png',
          isPinned: false,
        ),
        Repository(
          name: 'Pinned Repo 2',
          description: 'Pinned Description 2',
          stars: 250,
          language: 'Flutter',
          avatarUrl: 'https://example.com/pinned_avatar2.png',
          isPinned: true,
        ),
      ];

      when(mockGithubService.fetchPinnedRepositories(any)).thenAnswer(
        (_) async =>
            Future.value(mockRepos.where((repo) => repo.isPinned).toList()),
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Material(
            child: PinnedProjectsWidget(
              username: 'developersailor',
              githubService: mockGithubService,
            ),
          ),
        ),
      );

      await tester.pumpAndSettle(); // Wait for FutureBuilder to rebuild

      expect(find.byType(ListTile), findsNWidgets(2));
      expect(find.text('Pinned Repo 1'), findsOneWidget);
      expect(find.text('Pinned Repo 2'), findsOneWidget);
      expect(find.text('Pinned Description 1'), findsOneWidget);
      expect(find.text('Pinned Description 2'), findsOneWidget);
      expect(find.text('Non-Pinned Repo'), findsNothing);
    });
  });
}
