import 'dart:convert';
import 'package:http/http.dart' as http;

class Repository {
  final String name;
  final String description;
  final int stars;
  final String language;
  final String avatarUrl;
  final bool isPinned;

  Repository({
    required this.name,
    required this.description,
    required this.stars,
    required this.language,
    required this.avatarUrl,
    required this.isPinned,
  });

  factory Repository.fromJson(Map<String, dynamic> json) {
    return Repository(
      name: json['name'] ?? 'Unknown',
      description: json['description'] ?? 'No description',
      stars: json['stargazers_count'] ?? 0,
      language: json['language'] ?? 'Unknown',
      avatarUrl: json['owner']['avatar_url'] ?? '',
      isPinned: json['pinned'] ?? false, // Assuming `pinned` is a property in the JSON
    );
  }
}

class GithubService {
  final http.Client client;

  GithubService({http.Client? client}) : client = client ?? http.Client();

  Future<List<Repository>> fetchPinnedRepositories(String username) async {
    final url = Uri.parse('https://api.github.com/users/$username/repos');
    final response = await client.get(url);

    if (response.statusCode == 200) {
      final List<dynamic> repos = json.decode(response.body);
      // Filter repositories based on a pinned criterion (e.g., pinned attribute)
      return repos
          .map((repo) => Repository.fromJson(repo))
          .where((repo) => repo.isPinned) // Assuming `isPinned` is a property
          .toList();
    } else {
      throw Exception('Failed to load repositories');
    }
  }
}
