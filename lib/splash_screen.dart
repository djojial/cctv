import 'dart:async'; //timer
import 'package:flutter/material.dart'; //widget material
import 'pages/home_page.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _logoController;
  late Animation<double> _logoScale;

  late AnimationController _moveController;
  late Animation<Offset> _logoSlide;

  String _fullText = "CCTV KOTA BANDA ACEH";
  late List<bool> _letterVisible;

  bool _isLogoCentered = true; // tahap awal

  @override
  void initState() {
    super.initState();

    _letterVisible = List.generate(_fullText.length, (_) => false);

    // Tahap 1: Logo muncul dengan bounce
    _logoController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
    _logoScale = CurvedAnimation(
      parent: _logoController,
      curve: Curves.elasticOut,
    );

    // Tahap 2: Logo geser ke kiri
    _moveController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    _logoSlide = Tween<Offset>(begin: Offset.zero, end: const Offset(-0.12, 0))
        .animate(
          CurvedAnimation(parent: _moveController, curve: Curves.easeOutCubic),
        );

    // Jalankan animasi berurutan
    _logoController.forward().then((_) {
      Future.delayed(const Duration(milliseconds: 400), () {
        setState(() => _isLogoCentered = false); // pindah ke row
        _moveController.forward().then((_) {
          _startSmoothTypingEffect();
        });
      });
    });

    // Pindah ke home setelah selesai
    Timer(const Duration(seconds: 5), () {
      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          transitionDuration: const Duration(milliseconds: 600),
          pageBuilder: (_, __, ___) => const CustomHomePage(),
          transitionsBuilder: (_, animation, __, child) {
            final slideUp =
                Tween<Offset>(
                  begin: const Offset(0, 1),
                  end: Offset.zero,
                ).animate(
                  CurvedAnimation(
                    parent: animation,
                    curve: Curves.easeOutCubic,
                  ),
                );
            return SlideTransition(position: slideUp, child: child);
          },
        ),
      );
    });
  }

  // Efek mengetik + fade halus
  void _startSmoothTypingEffect() {
    int index = 0;
    Timer.periodic(const Duration(milliseconds: 80), (timer) {
      if (index < _fullText.length) {
        setState(() {
          _letterVisible[index] = true;
        });
        index++;
      } else {
        timer.cancel();
      }
    });
  }

  @override
  void dispose() {
    _logoController.dispose();
    _moveController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1F4E78),
      body: Center(
        child: _isLogoCentered
            ? ScaleTransition(
                scale: _logoScale,
                child: const Icon(
                  Icons.videocam_rounded,
                  color: Colors.white,
                  size: 80,
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SlideTransition(
                    position: _logoSlide,
                    child: const Icon(
                      Icons.videocam_rounded,
                      color: Colors.white,
                      size: 80,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: List.generate(_fullText.length, (i) {
                      return AnimatedOpacity(
                        opacity: _letterVisible[i] ? 1.0 : 0.0,
                        duration: const Duration(milliseconds: 200),
                        curve: Curves.easeInOut,
                        child: Text(
                          _fullText[i],
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.2,
                          ),
                        ),
                      );
                    }),
                  ),
                ],
              ),
      ),
    );
  }
}
