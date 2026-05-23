class GitHubRepo {
  final int id;
  final String name;
  final String? language;
  final int stargazersCount;
  final int forksCount;
  final String? htmlUrl;

  GitHubRepo({
    required this.id,
    required this.name,
    this.language,
    required this.stargazersCount,
    required this.forksCount,
    this.htmlUrl,
  });

  factory GitHubRepo.fromJson(Map<String, dynamic> json) {
    return GitHubRepo(
      id: (json['id'] ?? 0) as int,
      name: (json['name'] ?? '') as String,
      language: json['language'] as String?,
      stargazersCount: (json['stargazers_count'] ?? 0) as int,
      forksCount: (json['forks_count'] ?? 0) as int,
      htmlUrl: json['html_url'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'language': language,
        'stargazers_count': stargazersCount,
        'forks_count': forksCount,
        'html_url': htmlUrl,
      };
}
