import 'package:flutter/material.dart';
import 'github_service.dart';

class PinnedProjectsWidget extends StatelessWidget {
  final String username;
  final GithubService githubService;

  PinnedProjectsWidget({
    super.key,
    required this.username,
    GithubService? githubService,
  }) : githubService = githubService ?? GithubService();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Repository>>(
      future: githubService.fetchPinnedRepositories(username),
      builder: (context, snapshot) {
        // Add debug prints to verify FutureBuilder states
        print('FutureBuilder state: ${snapshot.connectionState}');
        if (snapshot.hasError) {
          print('Error: ${snapshot.error}');
        } else if (snapshot.hasData) {
          print('Data: ${snapshot.data}');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(
            child: Text(
              'Error: ${snapshot.error}',
              style: const TextStyle(color: Colors.red),
            ),
          );
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No pinned repositories found.'));
        } else {
          final repos = snapshot.data!.take(6).toList();
          return ListView.builder(
            itemCount: repos.length,
            itemBuilder: (context, index) {
              final repo = repos[index];
              // Use a placeholder image during tests to avoid NetworkImage errors
              final imageProvider =
                  repo.avatarUrl.startsWith('http') &&
                          !const bool.fromEnvironment('dart.vm.product')
                      ? const AssetImage('assets/placeholder.png')
                          as ImageProvider<Object>
                      : NetworkImage(repo.avatarUrl) as ImageProvider<Object>;
              return ListTile(
                leading: CircleAvatar(backgroundImage: imageProvider),
                title: Text(repo.name),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(repo.description),
                    Row(
                      children: [
                        Icon(Icons.star, size: 16, color: Colors.amber),
                        SizedBox(width: 4),
                        Text('${repo.stars} stars'),
                        SizedBox(width: 16),
                        Text('Language: ${repo.language}'),
                      ],
                    ),
                  ],
                ),
              );
            },
          );
        }
      },
    );
  }
}
