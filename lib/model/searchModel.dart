class UnsplashPhoto {
  String createdAt;
  String updatedAt;
  String? promotedAt;
  String? description;
  String altDescription;
  List<String> breadcrumbs;
  UnsplashUrls urls;
  int likes;
  bool likedByUser;
  List<dynamic> currentUserCollections;
  Map<String, dynamic> topicSubmissions;

  UnsplashPhoto({

    required this.createdAt,
    required this.updatedAt,
    this.promotedAt,
    this.description,
    required this.altDescription,
    required this.breadcrumbs,
    required this.urls,
    required this.likes,
    required this.likedByUser,
    required this.currentUserCollections,
    required this.topicSubmissions,
  });

  factory UnsplashPhoto.fromJson(Map<String, dynamic> json) {
    return UnsplashPhoto(
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      promotedAt: json['promoted_at'],
      description: json['description'],
      altDescription: json['alt_description'],
      breadcrumbs: List<String>.from(json['breadcrumbs']),
      urls: UnsplashUrls.fromJson(json['urls']),
      likes: json['likes'],
      likedByUser: json['liked_by_user'],
      currentUserCollections: List<dynamic>.from(json['current_user_collections']),
      topicSubmissions: Map<String, dynamic>.from(json['topic_submissions']),
    );
  }
}

class UnsplashUrls {
  String raw;
  String full;
  String regular;
  String small;
  String thumb;
  String smallS3;

  UnsplashUrls({
    required this.raw,
    required this.full,
    required this.regular,
    required this.small,
    required this.thumb,
    required this.smallS3,
  });

  factory UnsplashUrls.fromJson(Map<String, dynamic> json) {
    return UnsplashUrls(
      raw: json['raw'],
      full: json['full'],
      regular: json['regular'],
      small: json['small'],
      thumb: json['thumb'],
      smallS3: json['small_s3'],
    );
  }
}
