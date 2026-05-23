class GitHubUser {
  final String login;
  final String? name;
  final String? avatarUrl;
  final String? bio;
  final int followers;
  final int following;
  final int publicRepos;

  GitHubUser({
    required this.login,
    this.name,
    this.avatarUrl,
    this.bio,
    required this.followers,
    required this.following,
    required this.publicRepos,
  });

  factory GitHubUser.fromJson(Map<String, dynamic> json) {
    return GitHubUser(
      login: json['login'] as String,
      name: json['name'] as String?,
      avatarUrl: json['avatar_url'] as String?,
      bio: json['bio'] as String?,
      followers: (json['followers'] ?? 0) as int,
      following: (json['following'] ?? 0) as int,
      publicRepos: (json['public_repos'] ?? 0) as int,
    );
  }

  Map<String, dynamic> toJson() => {
        'login': login,
        'name': name,
        'avatar_url': avatarUrl,
        'bio': bio,
        'followers': followers,
        'following': following,
        'public_repos': publicRepos,
      };
}
