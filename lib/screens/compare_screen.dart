import 'package:flutter/material.dart';
import '../services/github_service.dart';
import '../models/github_user.dart';
import '../models/github_repo.dart';
import '../widgets/language_pie_chart.dart';
import 'package:shimmer/shimmer.dart';

class CompareScreen extends StatefulWidget {
  const CompareScreen({super.key});

  @override
  State<CompareScreen> createState() => _CompareScreenState();
}

class _CompareScreenState extends State<CompareScreen> {
  final TextEditingController _a = TextEditingController();
  final TextEditingController _b = TextEditingController();
  bool _loading = false;
  GitHubUser? userA;
  GitHubUser? userB;
  List<GitHubRepo>? reposA;
  List<GitHubRepo>? reposB;

  Future<void> _compare() async {
    final a = _a.text.trim();
    final b = _b.text.trim();
    if (a.isEmpty || b.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Enter both usernames')));
      return;
    }
    setState(() => _loading = true);
    final svc = GitHubService();
    try {
      final results = await Future.wait([
        svc.fetchUser(a),
        svc.fetchRepos(a),
        svc.fetchUser(b),
        svc.fetchRepos(b),
      ]);
      setState(() {
        userA = results[0] as GitHubUser;
        reposA = results[1] as List<GitHubRepo>;
        userB = results[2] as GitHubUser;
        reposB = results[3] as List<GitHubRepo>;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
    } finally {
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Compare Users')),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            Row(children: [
              Expanded(child: TextField(controller: _a, decoration: const InputDecoration(labelText: 'User A'))),
              const SizedBox(width:8),
              Expanded(child: TextField(controller: _b, decoration: const InputDecoration(labelText: 'User B'))),
              const SizedBox(width:8),
              ElevatedButton(onPressed: _loading ? null : _compare, child: const Text('Compare')),
            ]),
            const SizedBox(height:12),
            if (_loading) Expanded(child: _buildShimmer()),
            if (!_loading && userA != null && userB != null)
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildProfileColumn(userA!, reposA!),
                          const SizedBox(width:12),
                          _buildProfileColumn(userB!, reposB!),
                        ],
                      ),
                      const SizedBox(height:16),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('Language breakdown A', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                                const SizedBox(height: 8),
                                if (reposA != null) LanguagePieChart(repos: reposA!),
                              ],
                            ),
                          ),
                          const SizedBox(width:12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('Language breakdown B', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                                const SizedBox(height: 8),
                                if (reposB != null) LanguagePieChart(repos: reposB!),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              )
          ],
        ),
      ),
    );
  }

  Widget _buildProfileColumn(GitHubUser u, List<GitHubRepo> repos) {
    final totalStars = repos.fold<int>(0, (p, e) => p + e.stargazersCount);
    return Expanded(
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(children: [CircleAvatar(radius:28, backgroundImage: u.avatarUrl!=null?NetworkImage(u.avatarUrl!):null), const SizedBox(width:8), Text(u.name ?? u.login, style: const TextStyle(fontSize:16,fontWeight:FontWeight.bold))]),
              const SizedBox(height:8),
              Text(u.bio ?? ''),
              const SizedBox(height:8),
              Wrap(spacing:8, children: [Chip(label: Text('Followers: ${u.followers}')), Chip(label: Text('Following: ${u.following}')), Chip(label: Text('Repos: ${u.publicRepos}')), Chip(label: Text('Stars: $totalStars'))]),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildShimmer() {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: Column(children: [
        Container(height:100,color:Colors.white),
        const SizedBox(height:12),
        Container(height:200,color:Colors.white),
      ]),
    );
  }
}
