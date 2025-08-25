class CCTV {
  final int id;
  final String name;
  final String url;
  final double latitude;
  final double longitude;
  final bool isActive;
  final String region; // kecamatan/region
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

  /// ✅ Thumbnail real-time snapshot (cache buster pakai timestamp)
  String get thumbnailUrl {
    if (url.isEmpty) return "";
    return "$url?ts=${DateTime.now().millisecondsSinceEpoch}";
  }

  /// ✅ Apakah URL CCTV valid (bisa dipakai untuk Image/Video widget)
  bool get hasValidUrl =>
      url.isNotEmpty &&
      (url.startsWith("http://") || url.startsWith("https://"));

  /// ✅ Konversi dari JSON → CCTV object
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

  /// ✅ Konversi ke JSON → Map
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

  /// ✅ Untuk debugging / log
  @override
  String toString() {
    return "CCTV(id: $id, name: $name, url: $url, lat: $latitude, lng: $longitude, active: $isActive, region: $region)";
  }
}
