import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';
import '../services/github_service.dart';
import '../models/github_user.dart';
import '../models/github_repo.dart';
import 'dashboard_screen.dart';

class SearchScreen extends StatefulWidget {
  final VoidCallback onToggleTheme;
  final ThemeMode? themeMode;
  const SearchScreen({super.key, required this.onToggleTheme, this.themeMode});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _controller = TextEditingController();
  bool _loading = false;
  List<String> _history = [];

  @override
  void initState() {
    super.initState();
    _loadHistory();
  }

  Future<void> _loadHistory() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _history = prefs.getStringList('recent_searches') ?? [];
    });
  }

  Future<void> _addToHistory(String username) async {
    final prefs = await SharedPreferences.getInstance();
    _history.remove(username);
    _history.insert(0, username);
    if (_history.length > 10) _history = _history.sublist(0, 10);
    await prefs.setStringList('recent_searches', _history);
    setState(() {});
  }

  Future<void> _search() async {
    final username = _controller.text.trim();
    if (username.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a GitHub username')),
      );
      return;
    }
    FocusScope.of(context).unfocus();
    setState(() => _loading = true);
    try {
      final svc = GitHubService();
      final GitHubUser user = await svc.fetchUser(username);
      final List<GitHubRepo> repos = await svc.fetchRepos(username);
      await _addToHistory(username);
      if (!mounted) return;
      Navigator.of(context).push(MaterialPageRoute(
        builder: (_) => DashboardScreen(user: user, repos: repos),
      ));
    } on UserNotFoundException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.message)));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('DevSpace'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Row(children: [
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
                        filled: true,
                        fillColor: Theme.of(context).colorScheme.surfaceVariant,
                        hintText: 'Search GitHub username (e.g. torvalds)',
                        prefixIcon: const Icon(Icons.search),
                      ),
                      onSubmitted: (_) => _search(),
                    ),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: _loading ? null : _search,
                    style: ElevatedButton.styleFrom(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
                    child: _loading ? const SizedBox(width:20,height:20,child:CircularProgressIndicator(strokeWidth:2,color:Colors.white)) : const Text('Go'),
                  )
                ]),
              ),
            ),
            const SizedBox(height: 12),
            Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              color: Theme.of(context).colorScheme.secondaryContainer,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () => Navigator.of(context).pushNamed('/compare'),
                        icon: const Icon(Icons.compare_arrows),
                        label: const Text('Compare Mode'),
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size.fromHeight(52),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: widget.onToggleTheme,
                        icon: Icon(widget.themeMode == ThemeMode.dark ? Icons.dark_mode : Icons.light_mode),
                        label: Text(widget.themeMode == ThemeMode.dark ? 'Dark Mode ON' : 'Dark Mode OFF'),
                        style: OutlinedButton.styleFrom(
                          minimumSize: const Size.fromHeight(52),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
            if (_history.isNotEmpty)
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    const Text('Recent searches', style: TextStyle(fontWeight: FontWeight.w600)),
                    const SizedBox(height: 8),
                    Wrap(spacing: 8, children: _history.map((h) => ActionChip(label: Text(h), onPressed: () { _controller.text = h; _search(); })).toList()),
                  ]),
                ),
              ),
            const SizedBox(height: 12),
            if (_loading)
              Expanded(child: _buildShimmer()),
          ],
        ),
      ),
    );
  }

  Widget _buildShimmer() {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: ListView(
        children: [
          Row(
            children: [
              Container(width:72,height:72,color:Colors.white),
              const SizedBox(width:12),
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Container(height:14,color:Colors.white), const SizedBox(height:8), Container(height:12,color:Colors.white)])),
            ],
          ),
          const SizedBox(height:16),
          Container(height:180,color:Colors.white),
          const SizedBox(height:16),
          ...List.generate(4, (_) => Padding(padding: const EdgeInsets.symmetric(vertical:8.0), child: Row(children: [Expanded(child: Container(height:14,color:Colors.white)), const SizedBox(width:8), Container(width:60,height:14,color:Colors.white)]))),
        ],
      ),
    );
  }
}
