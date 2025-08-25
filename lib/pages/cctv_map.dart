import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

import '../models/cctv_model.dart';
import 'cctv_page.dart';

class CCTVMap extends StatelessWidget {
  final List<CCTV> cctvs;

  const CCTVMap({super.key, required this.cctvs});

  @override
  Widget build(BuildContext context) {
    if (cctvs.isEmpty) {
      return const Center(child: Text("Tidak ada data CCTV"));
    }

    return FlutterMap(
      options: MapOptions(
        center: LatLng(cctvs[0].latitude, cctvs[0].longitude),
        zoom: 13,
      ),
      children: [
        TileLayer(
          urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
          userAgentPackageName: 'com.example.cctv_kota',
        ),
        MarkerLayer(
          markers: cctvs.map((cctv) {
            return Marker(
              width: 80,
              height: 80,
              point: LatLng(cctv.latitude, cctv.longitude),
              builder: (ctx) => GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => CCTVPage(cctv: cctv)),
                  );
                },
                child: const Icon(
                  Icons.location_on,
                  color: Colors.red,
                  size: 40,
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
