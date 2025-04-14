import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'dart:convert';
import '../lib/github_service.dart';
import 'github_service_test.mocks.dart';

@GenerateMocks([http.Client])
void main() {
  group('GithubService', () {
    late MockClient mockClient;
    late GithubService githubService;

    setUp(() {
      mockClient = MockClient();
      githubService = GithubService(client: mockClient);
    });

    test(
      'fetchPinnedRepositories returns a list of repositories on success',
      () async {
        final username = 'developersailor';
        final mockResponse = jsonEncode([
          {
            'name': 'Test Repo',
            'description': 'A test repository',
            'stargazers_count': 42,
            'language': 'Dart',
            'owner': {'avatar_url': 'https://example.com/avatar.png'},
            'pinned': true,
          },
        ]);

        when(
          mockClient.get(
            Uri.parse('https://api.github.com/users/$username/repos'),
          ),
        ).thenAnswer((_) async => http.Response(mockResponse, 200));

        final repositories = await githubService.fetchPinnedRepositories(
          username,
        );

        expect(repositories, isA<List<Repository>>());
        expect(repositories.length, 1);
        expect(repositories[0].name, 'Test Repo');
        expect(repositories[0].stars, 42);
      },
    );

    test('fetchPinnedRepositories throws an exception on failure', () async {
      final username = 'developersailor';

      when(
        mockClient.get(
          Uri.parse('https://api.github.com/users/$username/repos'),
        ),
      ).thenAnswer((_) async => http.Response('Not Found', 404));

      expect(
        () async => await githubService.fetchPinnedRepositories(username),
        throwsException,
      );
    });
  });
}
