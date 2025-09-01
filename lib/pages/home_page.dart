import 'dart:ui';
import 'package:flutter/material.dart';

import '../models/cctv_model.dart';
import '../bookmark/bookmark_page.dart';
import '../sidebar/tentang_kami.dart';
import '../sidebar/kontak_kami.dart';
import '../cctv_api.dart';
import 'cctv_page.dart';
import '../cctv_placeholders.dart';
import 'cctv_map.dart';
import '../widgets/search_filter.dart';

class CustomHomePage extends StatefulWidget {
  const CustomHomePage({super.key});
  @override
  State<CustomHomePage> createState() => _CustomHomePageState();
}

class _CustomHomePageState extends State<CustomHomePage>
    with SingleTickerProviderStateMixin {
  final PageController _pageController = PageController(viewportFraction: 0.75);
  double _currentPage = 0.0;
  int _selectedIndex = 0;
  late Future<List<CCTV>> futureCctvs;

  late AnimationController _sidebarController;
  late Animation<Offset> _sidebarOffset;
  bool _isSidebarOpen = false;

  String _searchQuery = '';
  String _selectedRegion = 'Semua';

  List<String> _regions = [];

  @override
  void initState() {
    super.initState();

    _pageController.addListener(() {
      setState(() {
        _currentPage = _pageController.page ?? 0;
      });
    });

    futureCctvs = CCTVApi.fetchCCTVs();

    _sidebarController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _sidebarOffset =
        Tween<Offset>(begin: const Offset(-1.0, 0.0), end: Offset.zero).animate(
          CurvedAnimation(parent: _sidebarController, curve: Curves.easeInOut),
        );

    CCTVApi.fetchRegions().then((list) {
      if (mounted) {
        setState(() {
          _regions = list;
        });
      }
    });
  }

  void _toggleSidebar() {
    setState(() {
      if (_isSidebarOpen) {
        _sidebarController.reverse();
      } else {
        _sidebarController.forward();
      }
      _isSidebarOpen = !_isSidebarOpen;
    });
  }

  Widget _buildVideoCard(CCTV cctv, int index, double screenWidth) {
    final double scale =
        1 - (0.2 * (_currentPage - index).abs()).clamp(0.0, 1.0);
    final bool isCurrent = index == _currentPage.round();

    return Transform.scale(
      scale: scale,
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => CCTVPage(cctv: cctv)),
          );
        },
        child: Container(
          width: screenWidth * 0.7,
          margin: const EdgeInsets.symmetric(horizontal: 6),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Colors.grey.shade300,
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Stack(
              fit: StackFit.expand,
              children: [
                cctv.thumbnailUrl.isNotEmpty
                    ? Image.network(
                        cctv.thumbnailUrl,
                        fit: BoxFit.cover,
                        errorBuilder: (context, _, __) => SizedBox.expand(
                          child: Image.asset(
                            getCctvPlaceholder(cctv.name),
                            fit: BoxFit.cover,
                          ),
                        ),
                      )
                    : SizedBox.expand(
                        child: Image.asset(
                          getCctvPlaceholder(cctv.name),
                          fit: BoxFit.cover,
                        ),
                      ),
                if (!isCurrent)
                  BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                    child: Container(color: Colors.black26),
                  ),
                Positioned(
                  left: 12,
                  bottom: 30,
                  child: Text(
                    cctv.name,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      shadows: [
                        Shadow(
                          color: Colors.black,
                          blurRadius: 4,
                          offset: Offset(1, 1),
                        ),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  left: 12,
                  bottom: 12,
                  child: Text(
                    cctv.isActive ? 'Online' : 'Offline',
                    style: TextStyle(
                      color: cctv.isActive
                          ? Colors.greenAccent
                          : Colors.redAccent,
                      fontWeight: FontWeight.w500,
                      shadows: const [
                        Shadow(
                          color: Colors.black,
                          blurRadius: 4,
                          offset: Offset(1, 1),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(IconData icon, int index) {
    final isSelected = _selectedIndex == index;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _selectedIndex = index),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.white, size: 30),
            const SizedBox(height: 5),
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 30,
              height: 4,
              decoration: BoxDecoration(
                color: isSelected ? Colors.white : Colors.transparent,
                borderRadius: BorderRadius.circular(5),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHomeContent(
    double screenWidth,
    double screenHeight,
    double customAppBarHeight,
    List<CCTV> cctvs,
  ) {
    return Column(
      children: [
        SizedBox(height: customAppBarHeight + 100),
        SizedBox(
          height: screenHeight * 0.35,
          child: PageView.builder(
            controller: _pageController,
            itemCount: cctvs.length,
            itemBuilder: (context, index) =>
                _buildVideoCard(cctvs[index], index, screenWidth),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final screenWidth = size.width;
    final screenHeight = size.height;
    final statusBarHeight = MediaQuery.of(context).padding.top;

    final double customAppBarHeight = kToolbarHeight + statusBarHeight + 30;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          FutureBuilder<List<CCTV>>(
            future: futureCctvs,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text("Error: ${snapshot.error}"));
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Center(child: Text("Tidak ada data CCTV"));
              }

              final displayedCctvs = snapshot.data!
                  .where(
                    (cctv) =>
                        cctv.name.toLowerCase().contains(_searchQuery) &&
                        (_selectedRegion == 'Semua' ||
                            cctv.region == _selectedRegion),
                  )
                  .toList();

              return AnimatedSwitcher(
                duration: const Duration(milliseconds: 500),
                child: _selectedIndex == 0
                    ? _buildHomeContent(
                        screenWidth,
                        screenHeight,
                        customAppBarHeight,
                        displayedCctvs,
                      )
                    : CCTVMap(cctvs: displayedCctvs),
              );
            },
          ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              height: customAppBarHeight,
              decoration: const BoxDecoration(
                color: Color(0xFF1F4E78),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
              ),
              padding: EdgeInsets.only(
                top: statusBarHeight,
                left: screenWidth * 0.05,
                right: screenWidth * 0.05,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: const Icon(Icons.menu, color: Colors.white, size: 30),
                    onPressed: _toggleSidebar,
                  ),
                  Spacer(),
                  Image.asset(
                    'assets/logo_apk.png',
                    height: 50,
                    fit: BoxFit.contain,
                  ),
                  Spacer(),
                  IconButton(
                    icon: const Icon(
                      Icons.bookmark,
                      color: Colors.white,
                      size: 30,
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const BookmarkPage(),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            top: customAppBarHeight + 20,
            left: screenWidth * 0.05,
            right: screenWidth * 0.05,
            child: SearchFilter(
              regions: _regions,
              selectedRegion: _selectedRegion,
              onRegionSelected: (region) {
                setState(() {
                  _selectedRegion = region;
                });
              },
              onSearchChanged: (value) {
                setState(() {
                  _searchQuery = value.toLowerCase();
                });
              },
            ),
          ),
          Positioned(
            bottom: 60,
            left: screenWidth * 0.05,
            right: screenWidth * 0.05,
            child: Container(
              height: 70,
              decoration: BoxDecoration(
                color: const Color(0xFF1F4E78),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                children: [
                  _buildNavItem(Icons.home, 0),
                  _buildNavItem(Icons.location_on, 1),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
              decoration: const BoxDecoration(
                color: Color(0xFFF2F2F2),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(12),
                  topRight: Radius.circular(12),
                ),
              ),
              child: Center(
                child: Text(
                  "Copyright © 2025 Diskominfotik Banda Aceh | developed by Muhammad Djoji Alamni from Universitas Abulyatama",
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 10, color: Colors.black87),
                ),
              ),
            ),
          ),
          SlideTransition(
            position: _sidebarOffset,
            child: SafeArea(
              child: Container(
                width: screenWidth * 0.75,
                height: double.infinity,
                color: const Color(0xFF1F4E78),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    IconButton(
                      icon: const Icon(
                        Icons.arrow_back,
                        color: Colors.white,
                        size: 28,
                      ),
                      onPressed: _toggleSidebar,
                    ),
                    ListTile(
                      title: const Text(
                        'Tentang Kami',
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
                      onTap: () {
                        _toggleSidebar();
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const TentangKamiPage(),
                          ),
                        );
                      },
                    ),
                    ListTile(
                      title: const Text(
                        'Kontak Kami',
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
                      onTap: () {
                        _toggleSidebar();
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const KontakKamiPage(),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
