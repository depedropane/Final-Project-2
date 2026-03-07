import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../config/app_config.dart';
import 'login_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key}); // Gunakan super.key

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<OnboardingData> _pages = [
    OnboardingData(
      title: 'SahabatSehat',
      description: 'Perawat Pribadi Dalam\nGenggaman Tangan Anda',
      detail: 'SahabatSehat Hadir Membantu Anda\nMengatur Jadwal Obat Dengan Pengingat\nYang Tepat Dan Mudah Digunakan.',
    ),
    OnboardingData(
      title: 'SahabatSehat',
      description: 'Perawat Pribadi Dalam\nGenggaman Tangan Anda',
      detail: 'SahabatSehat Hadir Membantu Anda\nMengatur Jadwal Obat Dengan Pengingat\nYang Tepat Dan Mudah Digunakan.',
    ),
    OnboardingData(
      title: 'SahabatSehat',
      description: 'Perawat Pribadi Dalam\nGenggaman Tangan Anda',
      detail: 'Mulai Hidup Lebih Teratur Dan Sehat\nBersama SahabatSehat Hari Ini.',
    ),
  ];

  Future<void> _completeOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(AppConfig.hasSeenOnboardingKey, true);
    
    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // 1. Ubah background ke biru muda pucat agar logo bulat lebih terlihat
      backgroundColor: const Color(0xFFF0F9F9), 
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() {
                    _currentPage = index;
                  });
                },
                itemCount: _pages.length,
                itemBuilder: (context, index) {
                  return _buildPage(_pages[index]);
                },
              ),
            ),
            
            // 2. Dots Indicator
            SmoothPageIndicator(
              controller: _pageController,
              count: _pages.length,
              effect: const ScrollingDotsEffect( // Gunakan ScrollingDotsEffect agar mirip gambar
                activeDotColor: Color(0xFF1F2937), // Warna dot aktif gelap
                dotColor: Color(0xFFD1D5DB),
                dotHeight: 8,
                dotWidth: 8,
              ),
            ),
            
            // 3. Button
            Padding(
              padding: const EdgeInsets.fromLTRB(40, 32, 40, 48),
              child: SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    if (_currentPage == _pages.length - 1) {
                      _completeOnboarding();
                    } else {
                      _pageController.nextPage(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    // Gunakan warna hijau cerah sesuai gambar
                    backgroundColor: const Color(0xFF53E88B), 
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    elevation: 0,
                  ),
                  child: Text(
                    _currentPage == _pages.length - 1 ? 'Mulai Daftar →' : 'Selanjutnya',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPage(OnboardingData data) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // 4. Logo Bulat dengan Gradient
          Container(
            width: 180,
            height: 180,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [
                  const Color(0xFF53E88B).withValues(alpha: 0.7),
                  const Color(0xFF15BE77),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: const Center(
              // Gunakan icon medical sesuai logo yang kamu punya
              child: Icon(
                Icons.health_and_safety, 
                size: 100,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(height: 48),
          
          // 5. Title & Description sesuai gambar
          Text(
            data.title,
            style: const TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Color(0xFF000000),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            data.description,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Color(0xFF000000),
            ),
          ),
          const SizedBox(height: 60),
          
          // 6. Detail Text tanpa container putih agar lebih bersih
          Text(
            data.detail,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 14,
              color: Color(0xFF000000),
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}

// Model data tetap sama
class OnboardingData {
  final String title;
  final String description;
  final String detail;

  OnboardingData({
    required this.title,
    required this.description,
    required this.detail,
  });
}