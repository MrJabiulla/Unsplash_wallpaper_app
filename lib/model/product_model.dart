
class PhotoDetails {
  String? altDescription;
  String? description;
  String? fullUrl;
  String? thumUrl;
  String? username;
  String? updated_at;
  String? location;
  int? likes;
  int? width;
  int? height;

  PhotoDetails({
    required this.altDescription,
    required this.description,
    required this.fullUrl,
    required this.likes,
    required this.thumUrl,
    required this.updated_at,
    required this.location,
    required this.username,
    required this.height,
    required this.width
  });

  factory PhotoDetails.fromJson(Map<String, dynamic> json) {
    return PhotoDetails(
      altDescription: json['alt_description'] ,
      description: json['description'],
      fullUrl: json['urls']['regular'],
      likes: json['likes'],
      thumUrl: json['urls']['thumb'],
      username: json['user']['name'],
      updated_at: json['user']['updated_at'],
      location: json['user']['location'],
      width: json['width'],
      height: json['height'],
    );
  }
}
