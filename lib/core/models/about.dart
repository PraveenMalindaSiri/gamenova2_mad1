class WelcomeData {
  final String title;
  final String subtitle;
  final String description;
  final List<String> details;
  final String platforms;
  final String closing;
  final String tagline;
  final List<String> partners;
  final List<String> features;

  WelcomeData({
    required this.title,
    required this.subtitle,
    required this.description,
    required this.details,
    required this.platforms,
    required this.closing,
    required this.tagline,
    required this.partners,
    required this.features,
  });

  factory WelcomeData.fromJson(Map<String, dynamic> json) {
    return WelcomeData(
      title: json['title'],
      subtitle: json['subtitle'],
      description: json['description'],
      details: List<String>.from(json['details']),
      platforms: json['platforms'],
      closing: json['closing'],
      tagline: json['tagline'],
      partners: List<String>.from(json['partners']),
      features: List<String>.from(json['features']),
    );
  }
}
