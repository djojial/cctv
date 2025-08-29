import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/cctv_model.dart';

class CCTVApi {
  static const String apiUrl = "https://cctv.bandaacehkota.go.id/api/cameras";

  static Future<List<CCTV>> fetchCCTVs() async {
    final response = await http.get(Uri.parse(apiUrl));
    if (response.statusCode == 200) {
      final body = json.decode(response.body);
      final List<dynamic> data = body['data'];
      return data.map((item) => CCTV.fromJson(item)).toList();
    } else {
      throw Exception("CCTV sedang Maintenance");
    }
  }

  static Future<List<String>> fetchRegions() async {
    final cctvs = await fetchCCTVs();

    final regions = cctvs
        .map((e) => e.region.trim())
        .where((r) => r.isNotEmpty && r.toLowerCase() != "semua")
        .toSet()
        .toList();

    regions.sort();

    return ["Semua", ...regions];
  }
}
