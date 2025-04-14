import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'github_service.dart';
import 'card_style.dart';

/// A widget that displays a user's pinned GitHub repositories
class PinnedProjectsWidget extends StatelessWidget {
  /// GitHub username to fetch pinned repositories for
  final String username;

  /// Optional GitHub service instance for dependency injection
  final GithubService githubService;

  /// Optional GitHub personal access token for authenticated requests
  final String? accessToken;

  /// Optional number of repositories to display (defaults to 6)
  final int maxRepos;

  /// Optional custom loading widget
  final Widget? loadingWidget;

  /// Optional custom error widget builder
  final Widget Function(String error)? errorWidgetBuilder;

  /// Optional custom empty state widget
  final Widget? emptyWidget;

  /// Optional card style
  final CardStyle cardStyle;

  /// Creates a widget to display pinned GitHub repositories
  PinnedProjectsWidget({
    super.key,
    required this.username,
    GithubService? githubService,
    this.accessToken,
    this.maxRepos = 6,
    this.loadingWidget,
    this.errorWidgetBuilder,
    this.emptyWidget,
    this.cardStyle = CardStyle.modern,
  }) : githubService = githubService ?? GithubService(accessToken: accessToken);

  /// Opens the URL in the browser
  Future<void> _launchUrl(String url) async {
    final uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      throw Exception('Could not launch $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Repository>>(
      future: githubService.fetchPinnedRepositories(username),
      builder: (context, snapshot) {
        // Debug mode only prints
        assert(() {
          print('FutureBuilder state: ${snapshot.connectionState}');
          if (snapshot.hasError) {
            print('Error: ${snapshot.error}');
          } else if (snapshot.hasData) {
            print('Data length: ${snapshot.data?.length}');
          }
          return true;
        }());

        if (snapshot.connectionState == ConnectionState.waiting) {
          return loadingWidget ??
              const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return errorWidgetBuilder?.call(snapshot.error.toString()) ??
              Center(
                child: Text(
                  'Error: ${snapshot.error}',
                  style: const TextStyle(color: Colors.red),
                ),
              );
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return emptyWidget ??
              const Center(child: Text('No pinned repositories found.'));
        } else {
          final repos = snapshot.data!.take(maxRepos).toList();

          // Choose card style based on the selected option
          if (cardStyle == CardStyle.minimal) {
            return _buildMinimalList(repos, context);
          } else if (cardStyle == CardStyle.grid) {
            return _buildGridView(repos, context);
          } else {
            return _buildModernList(repos, context);
          }
        }
      },
    );
  }

  Widget _buildModernList(List<Repository> repos, BuildContext context) {
    return ListView.builder(
      itemCount: repos.length,
      itemBuilder: (context, index) {
        final repo = repos[index];
        return Card(
          margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          child: InkWell(
            onTap: () => _launchUrl(repo.url),
            borderRadius: BorderRadius.circular(8),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    repo.name,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    repo.description,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      const Icon(Icons.star, size: 16, color: Colors.amber),
                      const SizedBox(width: 4),
                      Text('${repo.stars}'),
                      const SizedBox(width: 16),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.blue.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          repo.language,
                          style: TextStyle(
                            color: Colors.blue.shade700,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildMinimalList(List<Repository> repos, BuildContext context) {
    return ListView.builder(
      itemCount: repos.length,
      itemBuilder: (context, index) {
        final repo = repos[index];
        return ListTile(
          title: Text(repo.name),
          subtitle: Text(repo.description),
          trailing: Text('${repo.stars} stars'),
          onTap: () => _launchUrl(repo.url),
        );
      },
    );
  }

  Widget _buildGridView(List<Repository> repos, BuildContext context) {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 1.5,
      ),
      itemCount: repos.length,
      itemBuilder: (context, index) {
        final repo = repos[index];
        return Card(
          margin: const EdgeInsets.all(8),
          child: InkWell(
            onTap: () => _launchUrl(repo.url),
            borderRadius: BorderRadius.circular(8),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(repo.name,
                      style: Theme.of(context).textTheme.titleLarge),
                  const SizedBox(height: 8),
                  Text(repo.description,
                      style: Theme.of(context).textTheme.bodyMedium),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      const Icon(Icons.star, size: 16, color: Colors.amber),
                      const SizedBox(width: 4),
                      Text('${repo.stars}'),
                      const SizedBox(width: 16),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.blue.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(repo.language,
                            style: TextStyle(color: Colors.blue.shade700)),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
