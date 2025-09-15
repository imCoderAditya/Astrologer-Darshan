// // games_controller.dart

// ignore_for_file: deprecated_member_use

// games_view.dart
import 'dart:math';
import 'dart:math' as math show cos;

import 'package:astrology/app/core/config/theme/app_colors.dart';
import 'package:astrology/app/modules/games/controllers/games_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class GamesView extends GetView<GamesController> {
  const GamesView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<GamesController>(
      init: GamesController(),
      builder: (controller) {
        return Scaffold(
          body: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFF8B4513), // Saddle brown
                  Color(0xFFCD853F), // Peru
                  Color(0xFFDEB887), // Burlywood
                  Color(0xFFD2691E), // Chocolate
                ],
              ),
            ),
            child: SafeArea(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    _buildHeader(),
                    _buildGuruStats(),
                    _buildRashiWheel(),
                    _buildRashifalSection(),
                    _buildPalmReadingSection(),
                    _buildKundaliSection(),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '🕉️ वैदिक ज्योतिष',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    'Vedic Astrology',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.white70,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              ),
              AnimatedBuilder(
                animation: controller.omRotation,
                builder: (context, child) {
                  return Transform.rotate(
                    angle: controller.omRotation.value,
                    child: const Text('🕉️', style: TextStyle(fontSize: 35)),
                  );
                },
              ),
            ],
          ),
          const SizedBox(height: 10),
          const Text(
            'अपना भविष्य जानें • Know Your Destiny',
            style: TextStyle(
              fontSize: 16,
              color: Colors.white,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGuruStats() {
    return Obx(
      () => Container(
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFFFF9500), Color(0xFFFFB84D)],
          ),
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: Colors.white.withOpacity(0.3)),
          boxShadow: [
            BoxShadow(
              color: Colors.orange.withOpacity(0.3),
              blurRadius: 10,
              spreadRadius: 2,
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildStatItem('गुरु स्तर', '${controller.guruLevel.value}', '🙏'),
            _buildStatItem('तपस्या', '${controller.tapasya.value}', '🧘'),
            _buildStatItem('धन', '${controller.dhanCoins.value}', '🪙'),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(String label, String value, String icon) {
    return Column(
      children: [
        Text(icon, style: const TextStyle(fontSize: 20)),
        const SizedBox(height: 5),
        Text(
          value,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: Colors.white,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildRashiWheel() {
    return Container(
      margin: const EdgeInsets.all(20),
      child: Column(
        children: [
          const Text(
            '🌟 अपनी राशि चुनें 🌟',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 5),
          const Text(
            'Choose Your Rashi',
            style: TextStyle(fontSize: 14, color: Colors.white70),
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 580.h,
            child: GridView.builder(
              physics: NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                childAspectRatio: 0.8,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemCount: controller.indianRashis.length,
              itemBuilder: (context, index) {
                final rashi = controller.indianRashis[index];
                return _buildRashiCard(rashi);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRashiCard(Map<String, dynamic> rashi) {
    return Obx(() {
      final isUnlocked = controller.isRashiUnlocked(rashi['name']);
      final isSelected = controller.selectedRashi.value == rashi['name'];

      return GestureDetector(
        onTap: () => controller.selectRashi(rashi['name']),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors:
                  isSelected
                      ? [rashi['color'].withOpacity(0.9), rashi['color']]
                      : isUnlocked
                      ? [
                        Colors.deepOrange.withOpacity(0.2),
                        Colors.green.withOpacity(0.1),
                      ]
                      : [
                        Colors.black.withOpacity(0.2),
                        Colors.black.withOpacity(0.1),
                      ],
            ),
            borderRadius: BorderRadius.circular(15),
            border: Border.all(
              color:
                  isSelected
                      ? Colors.white
                      : isUnlocked
                      ? Colors.white.withOpacity(0.4)
                      : Colors.grey.withOpacity(0.4),
              width: isSelected ? 3 : 1,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Stack(
                children: [
                  Text(
                    rashi['symbol'],
                    style: TextStyle(
                      fontSize: 28,
                      color: isUnlocked ? Colors.white : Colors.white,
                    ),
                  ),
                  if (!isUnlocked)
                    Positioned(
                      right: -8,
                      top: -8,
                      child: Container(
                        padding: const EdgeInsets.all(3),
                        decoration: const BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.lock,
                          size: 12,
                          color: Colors.white,
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                rashi['name'],
                style: TextStyle(
                  fontSize: 11.sp,
                  color: isUnlocked ? Colors.white : Colors.white,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 3),
              Text(
                rashi['english'],
                style: TextStyle(
                  fontSize: 9.sp,
                  color: isUnlocked ? Colors.white : Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
              Text(
                rashi['element'],
                style: TextStyle(
                  fontSize: 8.sp,
                  color: isUnlocked ? Colors.white60 : Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    });
  }

  Widget _buildRashifalSection() {
    return Obx(
      () => Container(
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFFFF6B35), Color(0xFFFF8E53)],
          ),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.white.withOpacity(0.3)),
        ),
        child: Column(
          children: [
            const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '📜 आज का राशिफल 📜',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 5),
            const Text(
              'Today\'s Horoscope',
              style: TextStyle(fontSize: 12, color: Colors.white70),
            ),
            const SizedBox(height: 15),
            if (controller.selectedRashi.value.isEmpty)
              const Text(
                'राशि चुनें और अपना भविष्य जानें\nSelect a rashi to know your future',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.white,
                  fontStyle: FontStyle.italic,
                ),
                textAlign: TextAlign.center,
              )
            else if (controller.isReading.value)
              const Column(
                children: [
                  CircularProgressIndicator(color: Colors.white),
                  SizedBox(height: 10),
                  Text(
                    'ग्रह नक्षत्र देख रहे हैं...\nReading the stars...',
                    style: TextStyle(color: Colors.white),
                    textAlign: TextAlign.center,
                  ),
                ],
              )
            else
              Column(
                children: [
                  Text(
                    '${controller.selectedRashi.value} के लिए:',
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Text(
                      controller.currentRashifal.value,
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                        height: 1.5,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildPalmReadingSection() {
    return Obx(
      () => Container(
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Column(
          children: [
            const Text(
              '🤚 हस्त रेखा देखें 🤚',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 5),
            const Text(
              'Palm Reading',
              style: TextStyle(fontSize: 12, color: Colors.white70),
            ),
            const SizedBox(height: 15),
            GestureDetector(
              onTap: controller.doPalmReading,
              child: Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: const RadialGradient(
                    colors: [Color(0xFFFFB84D), Color(0xFFFF9500)],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.orange.withOpacity(0.5),
                      blurRadius: 15,
                      spreadRadius: 3,
                    ),
                  ],
                ),
                child: const Center(
                  child: Text('🤚', style: TextStyle(fontSize: 40)),
                ),
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'मूल्य: 50 सिक्के • Cost: 50 coins',
              style: TextStyle(fontSize: 14, color: Colors.white),
            ),
            const SizedBox(height: 15),
            if (controller.isReading.value)
              const Column(
                children: [
                  CircularProgressIndicator(color: Colors.orange),
                  SizedBox(height: 10),
                  Text(
                    'हथेली की रेखाएं पढ़ रहे हैं...\nReading palm lines...',
                    style: TextStyle(color: Colors.white),
                    textAlign: TextAlign.center,
                  ),
                ],
              )
            else if (controller.palmReadingResult.value.isNotEmpty)
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.4),
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(color: Colors.orange.withOpacity(0.3)),
                ),
                child: Text(
                  controller.palmReadingResult.value,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                    height: 1.5,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildKundaliSection() {
    return Obx(
      () => Container(
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Column(
          children: [
            const Text(
              '🎯 कुंडली देखें 🎯',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 5),
            const Text(
              'Birth Chart Reading',
              style: TextStyle(fontSize: 12, color: Colors.white70),
            ),
            const SizedBox(height: 15),
            GestureDetector(
              onTap: controller.readKundali,
              child: AnimatedBuilder(
                animation: controller.kundaliSpin,
                builder: (context, child) {
                  return Transform.rotate(
                    angle: controller.kundaliSpin.value,
                    child: Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: RadialGradient(
                          colors: [
                            AppColors.darkBackground,
                            AppColors.darkBackground,
                            AppColors.darkBackground,
                          ],
                        ),
                        border: Border.all(color: Colors.white, width: 3),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.yellow.withOpacity(0.6),
                            blurRadius: 20,
                            spreadRadius: 5,
                          ),
                        ],
                      ),
                      child: Stack(
                        children: [
                          // Outer ring with zodiac symbols
                          ...List.generate(12, (index) {
                            final angle = (index * 30) * (3.14159 / 180);
                            final rashi = controller.indianRashis[index];
                            return Positioned(
                              left: 60 + 40 * cos(angle) - 10,
                              top: 60 + 40 * sin(angle) - 10,
                              child: Text(
                                rashi['symbol'],
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            );
                          }),
                          // Center Om symbol
                          const Center(
                            child: Text('🕉️', style: TextStyle(fontSize: 30)),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'मूल्य: 100 सिक्के • Cost: 100 coins',
              style: TextStyle(fontSize: 14, color: Colors.white),
            ),
            const SizedBox(height: 15),
            if (controller.isReading.value)
              const Column(
                children: [
                  CircularProgressIndicator(color: Colors.amber),
                  SizedBox(height: 10),
                  Text(
                    'कुंडली का विश्लेषण हो रहा है...\nAnalyzing birth chart...',
                    style: TextStyle(color: Colors.white),
                    textAlign: TextAlign.center,
                  ),
                ],
              )
            else if (controller.kundaliReading.value.isNotEmpty)
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFFFFD700), Color(0xFFFFA500)],
                  ),
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(color: Colors.white.withOpacity(0.5)),
                ),
                child: Column(
                  children: [
                    const Text(
                      '🎯 कुंडली परिणाम 🎯',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      controller.kundaliReading.value,
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                        height: 1.5,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            const SizedBox(height: 20),
            _buildNakshatraSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildNakshatraSection() {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF4B0082), Color(0xFF800080)],
        ),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.white.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          const Text(
            '⭐ नक्षत्र मंडल ⭐',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 5),
          const Text(
            'Nakshatra Constellation',
            style: TextStyle(fontSize: 12, color: Colors.white70),
          ),
          const SizedBox(height: 15),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children:
                controller.nakshatras.map((nakshatra) {
                  return Obx(() {
                    final isUnlocked = controller.unlockedNakshatras.contains(
                      nakshatra['name'],
                    );
                    return Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color:
                            isUnlocked
                                ? Colors.white.withOpacity(0.2)
                                : Colors.grey.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color:
                              isUnlocked
                                  ? Colors.white.withOpacity(0.5)
                                  : Colors.grey.withOpacity(0.5),
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            nakshatra['symbol'],
                            style: const TextStyle(fontSize: 16),
                          ),
                          const SizedBox(width: 5),
                          Text(
                            nakshatra['name'],
                            style: TextStyle(
                              fontSize: 12,
                              color: isUnlocked ? Colors.white : Colors.grey,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          if (!isUnlocked)
                            const Padding(
                              padding: EdgeInsets.only(left: 5),
                              child: Icon(
                                Icons.lock,
                                size: 12,
                                color: Colors.grey,
                              ),
                            ),
                        ],
                      ),
                    );
                  });
                }).toList(),
          ),
          const SizedBox(height: 15),
          AnimatedBuilder(
            animation: controller.lampFlicker,
            builder: (context, child) {
              return Opacity(
                opacity: controller.lampFlicker.value,
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text('🪔', style: TextStyle(fontSize: 20)),
                    Text('🪔', style: TextStyle(fontSize: 20)),
                    Text('🪔', style: TextStyle(fontSize: 20)),
                    Text('🪔', style: TextStyle(fontSize: 20)),
                    Text('🪔', style: TextStyle(fontSize: 20)),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  // Helper function for cos calculation
  double cos(double angle) => math.cos(angle);
}

// // games_view.dart
// import 'package:astrology/app/modules/games/controllers/games_controller.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';

// class GamesView extends GetView<GamesController> {
//   const GamesView({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return GetBuilder<GamesController>(
//       init: GamesController(),
//       builder: (controller) {
//         return Scaffold(
//           body: Container(
//             decoration: const BoxDecoration(
//               gradient: LinearGradient(
//                 begin: Alignment.topCenter,
//                 end: Alignment.bottomCenter,
//                 colors: [
//                   Color(0xFF1a1a2e),
//                   Color(0xFF16213e),
//                   Color(0xFF0f3460),
//                 ],
//               ),
//             ),
//             child: SafeArea(
//               child: SingleChildScrollView(
//                 child: Column(
//                   children: [
//                     _buildHeader(),
//                     _buildPlayerStats(),
//                     _buildZodiacWheel(),
//                     _buildHoroscopeSection(),
//                     _buildCrystalBallSection(),
//                     const SizedBox(height: 20),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//         );
//       }
//     );
//   }

//   Widget _buildHeader() {
//     return Container(
//       padding: const EdgeInsets.all(20),
//       child: Column(
//         children: [
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               const Text(
//                 '🔮 Mystic Astrologer',
//                 style: TextStyle(
//                   fontSize: 24,
//                   fontWeight: FontWeight.bold,
//                   color: Colors.white,
//                 ),
//               ),
//               AnimatedBuilder(
//                 animation: controller.starRotation,
//                 builder: (context, child) {
//                   return Transform.rotate(
//                     angle: controller.starRotation.value,
//                     child: const Text(
//                       '⭐',
//                       style: TextStyle(fontSize: 30),
//                     ),
//                   );
//                 },
//               ),
//             ],
//           ),
//           const SizedBox(height: 10),
//           const Text(
//             'Discover your cosmic destiny',
//             style: TextStyle(
//               fontSize: 16,
//               color: Colors.white70,
//               fontStyle: FontStyle.italic,
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildPlayerStats() {
//     return Obx(() => Container(
//       margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
//       padding: const EdgeInsets.all(15),
//       decoration: BoxDecoration(
//         color: Colors.white.withOpacity(0.1),
//         borderRadius: BorderRadius.circular(15),
//         border: Border.all(color: Colors.white.withOpacity(0.2)),
//       ),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceAround,
//         children: [
//           _buildStatItem('Level', '${controller.playerLevel.value}', '🌟'),
//           _buildStatItem('XP', '${controller.experience.value}', '⚡'),
//           _buildStatItem('Coins', '${controller.coins.value}', '🪙'),
//         ],
//       ),
//     ));
//   }

//   Widget _buildStatItem(String label, String value, String icon) {
//     return Column(
//       children: [
//         Text(
//           icon,
//           style: const TextStyle(fontSize: 20),
//         ),
//         const SizedBox(height: 5),
//         Text(
//           value,
//           style: const TextStyle(
//             fontSize: 18,
//             fontWeight: FontWeight.bold,
//             color: Colors.white,
//           ),
//         ),
//         Text(
//           label,
//           style: TextStyle(
//             fontSize: 12,
//             color: Colors.white.withOpacity(0.7),
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _buildZodiacWheel() {
//     return Container(
//       margin: const EdgeInsets.all(20),
//       child: Column(
//         children: [
//           const Text(
//             'Choose Your Zodiac Sign',
//             style: TextStyle(
//               fontSize: 20,
//               fontWeight: FontWeight.bold,
//               color: Colors.white,
//             ),
//           ),
//           const SizedBox(height: 20),
//           SizedBox(
//             height: 300,
//             child: GridView.builder(
//               physics: const NeverScrollableScrollPhysics(),
//               gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//                 crossAxisCount: 4,
//                 childAspectRatio: 1,
//                 crossAxisSpacing: 10,
//                 mainAxisSpacing: 10,
//               ),
//               itemCount: controller.zodiacSigns.length,
//               itemBuilder: (context, index) {
//                 final zodiac = controller.zodiacSigns[index];
//                 return _buildZodiacCard(zodiac);
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildZodiacCard(Map<String, dynamic> zodiac) {
//     return Obx(() {
//       final isUnlocked = controller.isZodiacUnlocked(zodiac['name']);
//       final isSelected = controller.selectedZodiac.value == zodiac['name'];
      
//       return GestureDetector(
//         onTap: () => controller.selectZodiac(zodiac['name']),
//         child: AnimatedContainer(
//           duration: const Duration(milliseconds: 300),
//           decoration: BoxDecoration(
//             gradient: LinearGradient(
//               colors: isSelected
//                   ? [zodiac['color'].withOpacity(0.8), zodiac['color']]
//                   : isUnlocked
//                       ? [Colors.white.withOpacity(0.1), Colors.white.withOpacity(0.05)]
//                       : [Colors.grey.withOpacity(0.1), Colors.grey.withOpacity(0.05)],
//             ),
//             borderRadius: BorderRadius.circular(15),
//             border: Border.all(
//               color: isSelected
//                   ? Colors.white
//                   : isUnlocked
//                       ? Colors.white.withOpacity(0.3)
//                       : Colors.grey.withOpacity(0.3),
//               width: isSelected ? 2 : 1,
//             ),
//           ),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Stack(
//                 children: [
//                   Text(
//                     zodiac['icon'],
//                     style: TextStyle(
//                       fontSize: 24,
//                       color: isUnlocked ? Colors.white : Colors.grey,
//                     ),
//                   ),
//                   if (!isUnlocked)
//                     Positioned(
//                       right: -5,
//                       top: -5,
//                       child: Container(
//                         padding: const EdgeInsets.all(2),
//                         decoration: const BoxDecoration(
//                           color: Colors.red,
//                           shape: BoxShape.circle,
//                         ),
//                         child: const Icon(
//                           Icons.lock,
//                           size: 12,
//                           color: Colors.white,
//                         ),
//                       ),
//                     ),
//                 ],
//               ),
//               const SizedBox(height: 5),
//               Text(
//                 zodiac['name'],
//                 style: TextStyle(
//                   fontSize: 10,
//                   color: isUnlocked ? Colors.white : Colors.grey,
//                   fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
//                 ),
//               ),
//             ],
//           ),
//         ),
//       );
//     });
//   }

//   Widget _buildHoroscopeSection() {
//     return Obx(() => Container(
//       margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
//       padding: const EdgeInsets.all(20),
//       decoration: BoxDecoration(
//         gradient: LinearGradient(
//           colors: [
//             Colors.purple.withOpacity(0.3),
//             Colors.blue.withOpacity(0.3),
//           ],
//         ),
//         borderRadius: BorderRadius.circular(20),
//         border: Border.all(color: Colors.white.withOpacity(0.2)),
//       ),
//       child: Column(
//         children: [
//           const Row(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Text(
//                 '🌙 Today\'s Reading 🌙',
//                 style: TextStyle(
//                   fontSize: 18,
//                   fontWeight: FontWeight.bold,
//                   color: Colors.white,
//                 ),
//               ),
//             ],
//           ),
//           const SizedBox(height: 15),
//           if (controller.selectedZodiac.value.isEmpty)
//             Text(
//               'Select a zodiac sign to receive your personalized horoscope',
//               style: TextStyle(
//                 fontSize: 14,
//                 color: Colors.white.withOpacity(0.7),
//                 fontStyle: FontStyle.italic,
//               ),
//               textAlign: TextAlign.center,
//             )
//           else if (controller.isReading.value)
//             const Column(
//               children: [
//                 CircularProgressIndicator(color: Colors.white),
//                 SizedBox(height: 10),
//                 Text(
//                   'Reading the stars...',
//                   style: TextStyle(color: Colors.white70),
//                 ),
//               ],
//             )
//           else
//             Column(
//               children: [
//                 Text(
//                   'For ${controller.selectedZodiac.value}:',
//                   style: const TextStyle(
//                     fontSize: 16,
//                     color: Colors.white,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//                 const SizedBox(height: 10),
//                 Container(
//                   padding: const EdgeInsets.all(15),
//                   decoration: BoxDecoration(
//                     color: Colors.black.withOpacity(0.3),
//                     borderRadius: BorderRadius.circular(15),
//                   ),
//                   child: Text(
//                     controller.currentHoroscope.value,
//                     style: const TextStyle(
//                       fontSize: 16,
//                       color: Colors.white,
//                       height: 1.5,
//                     ),
//                     textAlign: TextAlign.center,
//                   ),
//                 ),
//               ],
//             ),
//         ],
//       ),
//     ));
//   }

//   Widget _buildCrystalBallSection() {
//     return Obx(() => Container(
//       margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
//       child: Column(
//         children: [
//           const Text(
//             '🔮 Crystal Ball Divination',
//             style: TextStyle(
//               fontSize: 18,
//               fontWeight: FontWeight.bold,
//               color: Colors.white,
//             ),
//           ),
//           const SizedBox(height: 15),
//           GestureDetector(
//             onTap: controller.useCrystalBall,
//             child: AnimatedBuilder(
//               animation: controller.crystalBallGlow,
//               builder: (context, child) {
//                 return Container(
//                   width: 120,
//                   height: 120,
//                   decoration: BoxDecoration(
//                     shape: BoxShape.circle,
//                     gradient: RadialGradient(
//                       colors: [
//                         Colors.cyan.withOpacity(controller.crystalBallGlow.value),
//                         Colors.blue.withOpacity(0.3),
//                         Colors.purple.withOpacity(0.1),
//                       ],
//                     ),
//                     boxShadow: [
//                       BoxShadow(
//                         color: Colors.cyan.withOpacity(controller.crystalBallGlow.value * 0.5),
//                         blurRadius: 20,
//                         spreadRadius: 5,
//                       ),
//                     ],
//                   ),
//                   child: const Center(
//                     child: Text(
//                       '🔮',
//                       style: TextStyle(fontSize: 50),
//                     ),
//                   ),
//                 );
//               },
//             ),
//           ),
//           const SizedBox(height: 10),
//           Text(
//             'Cost: 20 coins',
//             style: TextStyle(
//               fontSize: 14,
//               color: Colors.white.withOpacity(0.7),
//             ),
//           ),
//           const SizedBox(height: 15),
//           if (controller.isReading.value)
//             const Column(
//               children: [
//                 CircularProgressIndicator(color: Colors.cyan),
//                 SizedBox(height: 10),
//                 Text(
//                   'Gazing into the crystal depths...',
//                   style: TextStyle(color: Colors.white70),
//                 ),
//               ],
//             )
//           else if (controller.crystalBallMessage.value.isNotEmpty)
//             Container(
//               margin: const EdgeInsets.symmetric(horizontal: 20),
//               padding: const EdgeInsets.all(15),
//               decoration: BoxDecoration(
//                 color: Colors.black.withOpacity(0.4),
//                 borderRadius: BorderRadius.circular(15),
//                 border: Border.all(color: Colors.cyan.withOpacity(0.3)),
//               ),
//               child: Text(
//                 controller.crystalBallMessage.value,
//                 style: const TextStyle(
//                   fontSize: 16,
//                   color: Colors.white,
//                   height: 1.5,
//                   fontStyle: FontStyle.italic,
//                 ),
//                 textAlign: TextAlign.center,
//               ),
//             ),
//         ],
//       ),
//     ));
//   }
// }