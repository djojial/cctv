class CCTV {
  final int id;
  final String name;
  final String url;
  final double latitude;
  final double longitude;
  final bool isActive;
  final String region;
  final String? address;

  CCTV({
    required this.id,
    required this.name,
    required this.url,
    required this.latitude,
    required this.longitude,
    required this.isActive,
    required this.region,
    this.address,
  });

  String get thumbnailUrl {
    if (url.isEmpty) return "";
    return "$url?ts=${DateTime.now().millisecondsSinceEpoch}";
  }

  bool get hasValidUrl =>
      url.isNotEmpty &&
      (url.startsWith("http://") || url.startsWith("https://"));

  factory CCTV.fromJson(Map<String, dynamic> json) {
    return CCTV(
      id: json['id'] is int
          ? json['id']
          : int.tryParse(json['id']?.toString() ?? '') ?? 0,
      name: json['name']?.toString() ?? 'Unknown',
      url: json['url']?.toString() ?? '',
      latitude: double.tryParse(json['latitude']?.toString() ?? '') ?? 0.0,
      longitude: double.tryParse(json['longitude']?.toString() ?? '') ?? 0.0,
      isActive: json['is_active'] == 1 || json['is_active'] == true,
      region: json['region']?.toString() ?? 'Unknown',
      address: json['address']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'url': url,
      'latitude': latitude,
      'longitude': longitude,
      'is_active': isActive,
      'region': region,
      'address': address,
    };
  }

  @override
  String toString() {
    return "CCTV(id: $id, name: $name, url: $url, lat: $latitude, lng: $longitude, active: $isActive, region: $region)";
  }
}
