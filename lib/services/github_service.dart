import 'dart:convert';

import 'package:http/http.dart' as http;
import '../models/github_user.dart';
import '../models/github_repo.dart';

class UserNotFoundException implements Exception {
  final String message;
  UserNotFoundException([this.message = 'User not found']);
  @override
  String toString() => 'UserNotFoundException: $message';
}

class GitHubService {
  static const String _base = 'https://api.github.com/users';

  final http.Client _client;

  GitHubService([http.Client? client]) : _client = client ?? http.Client();

  Future<GitHubUser> fetchUser(String username) async {
    final uri = Uri.parse('$_base/$username');
    final res = await _client.get(uri);
    if (res.statusCode == 200) {
      final jsonBody = json.decode(res.body) as Map<String, dynamic>;
      return GitHubUser.fromJson(jsonBody);
    }
    if (res.statusCode == 404) {
      throw UserNotFoundException('GitHub user "$username" not found');
    }
    throw Exception('Failed to fetch user: ${res.statusCode}');
  }

  Future<List<GitHubRepo>> fetchRepos(String username) async {
    final uri = Uri.parse('$_base/$username/repos?per_page=100&sort=updated');
    final res = await _client.get(uri);
    if (res.statusCode == 200) {
      final jsonBody = json.decode(res.body) as List<dynamic>;
      return jsonBody
          .map((e) => GitHubRepo.fromJson(e as Map<String, dynamic>))
          .toList();
    }
    if (res.statusCode == 404) {
      throw UserNotFoundException('GitHub user "$username" not found');
    }
    throw Exception('Failed to fetch repos: ${res.statusCode}');
  }
}
