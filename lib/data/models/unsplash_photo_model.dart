class UnsplashPhoto {
  final String id;
  final String? title; // From alt_description
  final String fullImageUrl;
  final String downloadUrl;

  UnsplashPhoto({
    required this.id,
    required this.fullImageUrl,
    required this.downloadUrl,
    this.title,
  });

  factory UnsplashPhoto.fromJson(Map<String, dynamic> json) {
    return UnsplashPhoto(
      id: json['id'],
      title: json['alt_description'], // or json['description'] if preferred
      fullImageUrl: json['urls']['full'],
      downloadUrl: json['links']['download'],
    );
  }
}






