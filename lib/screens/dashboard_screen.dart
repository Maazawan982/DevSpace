import 'package:flutter/material.dart';
import '../models/github_user.dart';
import '../models/github_repo.dart';
import '../widgets/language_pie_chart.dart';

class DashboardScreen extends StatelessWidget {
  final GitHubUser user;
  final List<GitHubRepo> repos;

  const DashboardScreen({super.key, required this.user, required this.repos});

  @override
  Widget build(BuildContext context) {
    final top = [...repos]..sort((a, b) => b.stargazersCount.compareTo(a.stargazersCount));
    final top10 = top.take(10).toList();

    return Scaffold(
      appBar: AppBar(title: Text(user.login)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 40,
                      backgroundImage: user.avatarUrl != null ? NetworkImage(user.avatarUrl!) : null,
                      child: user.avatarUrl == null ? const Icon(Icons.person) : null,
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(user.name ?? user.login, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                          const SizedBox(height: 6),
                          if (user.bio != null) Text(user.bio!),
                          const SizedBox(height: 12),
                          Wrap(spacing: 8, children: [
                            Chip(label: Text('Followers: ${user.followers}')),
                            Chip(label: Text('Following: ${user.following}')),
                            Chip(label: Text('Repos: ${user.publicRepos}')),
                          ])
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
            const SizedBox(height: 18),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  const Text('Language Distribution', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 12),
                  LanguagePieChart(repos: repos),
                ]),
              ),
            ),
            const SizedBox(height: 18),
            const Text('Top Repositories', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            ListView.separated(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: top10.length,
              separatorBuilder: (_, __) => const Divider(),
              itemBuilder: (context, i) {
                final r = top10[i];
                return ListTile(
                  leading: const Icon(Icons.book),
                  title: Text(r.name, style: const TextStyle(fontWeight: FontWeight.w600)),
                  subtitle: Text(r.language ?? 'Unknown'),
                  trailing: Row(mainAxisSize: MainAxisSize.min, children: [
                    Container(padding: const EdgeInsets.symmetric(horizontal:8,vertical:4), decoration: BoxDecoration(color: Colors.yellow.shade700,borderRadius: BorderRadius.circular(12)), child: Row(children: [const Icon(Icons.star,size:14), const SizedBox(width:4), Text('${r.stargazersCount}')]) ),
                    const SizedBox(width:8),
                    Container(padding: const EdgeInsets.symmetric(horizontal:8,vertical:4), decoration: BoxDecoration(color: Colors.grey.shade300,borderRadius: BorderRadius.circular(12)), child: Row(children: [const Icon(Icons.call_split,size:14), const SizedBox(width:4), Text('${r.forksCount}')]) ),
                  ]),
                );
              },
            )
          ],
        ),
      ),
    );
  }
}
