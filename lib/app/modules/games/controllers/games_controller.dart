// import 'package:get/get.dart';
// import 'package:flutter/material.dart';



// games_controller.dart

import 'package:get/get.dart';
import 'package:flutter/material.dart';

class GamesController extends GetxController with GetTickerProviderStateMixin {
  // Observable variables
  var selectedRashi = ''.obs;
  var selectedNakshatra = ''.obs;
  var currentRashifal = ''.obs;
  var palmReadingResult = ''.obs;
  var kundaliReading = ''.obs;
  var isReading = false.obs;
  var guruLevel = 1.obs;
  var tapasya = 0.obs; // spiritual practice points
  var dhanCoins = 500.obs; // Indian currency theme
  var unlockedRashis = <String>[].obs;
  var unlockedNakshatras = <String>[].obs;
  
  // Animation controllers
  late AnimationController omSymbolController;
  late AnimationController divaLampController;
  late AnimationController kundaliWheelController;
  late Animation<double> omRotation;
  late Animation<double> lampFlicker;
  late Animation<double> kundaliSpin;
  
  // Indian Rashis (Zodiac Signs)
  final List<Map<String, dynamic>> indianRashis = [
    {'name': 'मेष (Mesh)', 'english': 'Aries', 'symbol': '♈', 'element': 'अग्नि', 'color': Colors.red, 'deity': 'मंगल'},
    {'name': 'वृष (Vrishabh)', 'english': 'Taurus', 'symbol': '♉', 'element': 'पृथ्वी', 'color': Colors.green, 'deity': 'शुक्र'},
    {'name': 'मिथुन (Mithun)', 'english': 'Gemini', 'symbol': '♊', 'element': 'वायु', 'color': Colors.yellow, 'deity': 'बुध'},
    {'name': 'कर्क (Kark)', 'english': 'Cancer', 'symbol': '♋', 'element': 'जल', 'color': Colors.blue, 'deity': 'चंद्र'},
    {'name': 'सिंह (Singh)', 'english': 'Leo', 'symbol': '♌', 'element': 'अग्नि', 'color': Colors.orange, 'deity': 'सूर्य'},
    {'name': 'कन्या (Kanya)', 'english': 'Virgo', 'symbol': '♍', 'element': 'पृथ्वी', 'color': Colors.brown, 'deity': 'बुध'},
    {'name': 'तुला (Tula)', 'english': 'Libra', 'symbol': '♎', 'element': 'वायु', 'color': Colors.pink, 'deity': 'शुक्र'},
    {'name': 'वृश्चिक (Vrishchik)', 'english': 'Scorpio', 'symbol': '♏', 'element': 'जल', 'color': Colors.deepPurple, 'deity': 'मंगल'},
    {'name': 'धनु (Dhanu)', 'english': 'Sagittarius', 'symbol': '♐', 'element': 'अग्नि', 'color': Colors.indigo, 'deity': 'बृहस्पति'},
    {'name': 'मकर (Makar)', 'english': 'Capricorn', 'symbol': '♑', 'element': 'पृथ्वी', 'color': Colors.grey, 'deity': 'शनि'},
    {'name': 'कुंभ (Kumbh)', 'english': 'Aquarius', 'symbol': '♒', 'element': 'वायु', 'color': Colors.cyan, 'deity': 'शनि'},
    {'name': 'मीन (Meen)', 'english': 'Pisces', 'symbol': '♓', 'element': 'जल', 'color': Colors.teal, 'deity': 'बृहस्पति'},
  ];
  
  // Nakshatras (Lunar Mansions)
  final List<Map<String, dynamic>> nakshatras = [
    {'name': 'अश्विनी', 'deity': 'अश्विनी कुमार', 'symbol': '🐎'},
    {'name': 'भरणी', 'deity': 'यम', 'symbol': '🌟'},
    {'name': 'कृत्तिका', 'deity': 'अग्नि', 'symbol': '🔥'},
    {'name': 'रोहिणी', 'deity': 'ब्रह्मा', 'symbol': '🌹'},
    {'name': 'मृगशिरा', 'deity': 'चंद्र', 'symbol': '🦌'},
    {'name': 'आर्द्रा', 'deity': 'रुद्र', 'symbol': '💎'},
  ];
  
  // Vedic Predictions
  final List<String> vedicPredictions = [
    "ग्रह आपके पक्ष में हैं। आज धन लाभ के योग हैं।",
    "गुरु ग्रह का आशीर्वाद आप पर है। ज्ञान की प्राप्ति होगी।",
    "चंद्रमा की कृपा से मन में शांति और प्रेम मिलेगा।",
    "सूर्य देव का तेज आपके जीवन में उजाला लाएगा।",
    "शनि महाराज की दया से कड़ी मेहनत का फल मिलेगा।",
    "शुक्र ग्रह के प्रभाव से कलाओं में सफलता मिलेगी।",
    "मंगल का बल आपमें साहस और शक्ति भरेगा।",
    "बुध ग्रह की कृपा से व्यापार में लाभ होगा।",
    "राहु-केतु के प्रभाव से अचानक परिवर्तन आएगा।"
  ];
  
  // Palm Reading Results
  final List<String> palmReadings = [
    "आपकी हृदय रेखा प्रेम और खुशी का संकेत देती है।",
    "जीवन रेखा लंबी आयु और अच्छे स्वास्थ्य को दर्शाती है।",
    "भाग्य रेखा सफलता और समृद्धि का संकेत है।",
    "बुध पर्वत विकसित है - व्यापार में सफलता मिलेगी।",
    "सूर्य पर्वत प्रबल है - यश और कीर्ति मिलेगी।",
    "चंद्र पर्वत से कलात्मक प्रतिभा का पता चलता है।",
  ];
  
  // Kundali Messages
  final List<String> kundaliMessages = [
    "आपकी कुंडली में राजयोग के संयोग हैं।",
    "लग्न बली है - व्यक्तित्व में आकर्षण है।",
    "धन भाव में शुभ ग्रह - संपत्ति की प्राप्ति।",
    "कर्म भाव मजबूत - कार्यक्षेत्र में उन्नति।",
    "पंचम भाव में शुभता - संतान सुख प्राप्त होगा।",
    "सप्तम भाव शुभ - विवाह में खुशी मिलेगी।",
  ];

  @override
  void onInit() {
    super.onInit();
    initializeAnimations();
    initializeUnlockedItems();
  }
  
  void initializeAnimations() {
    omSymbolController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat();
    
    divaLampController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    )..repeat(reverse: true);
    
    kundaliWheelController = AnimationController(
      duration: const Duration(seconds: 5),
      vsync: this,
    );
    
    omRotation = Tween<double>(
      begin: 0,
      end: 2 * 3.14159,
    ).animate(CurvedAnimation(
      parent: omSymbolController,
      curve: Curves.linear,
    ));
    
    lampFlicker = Tween<double>(
      begin: 0.7,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: divaLampController,
      curve: Curves.easeInOut,
    ));
    
    kundaliSpin = Tween<double>(
      begin: 0,
      end: 2 * 3.14159,
    ).animate(CurvedAnimation(
      parent: kundaliWheelController,
      curve: Curves.easeOut,
    ));
  }
  
  void initializeUnlockedItems() {
    unlockedRashis.value = ['मेष (Mesh)', 'वृष (Vrishabh)', 'मिथुन (Mithun)'];
    unlockedNakshatras.value = ['अश्विनी', 'भरणी'];
  }
  
  void selectRashi(String rashiName) {
    if (!isRashiUnlocked(rashiName)) {
      Get.snackbar(
        'बंद है! 🔒',
        'गुरु स्तर ${getRequiredGuruLevel(rashiName)} पर पहुंचें',
        backgroundColor: const Color(0xFFFF6B35).withOpacity(0.8),
        colorText: Colors.white,
        icon: const Icon(Icons.lock, color: Colors.white),
      );
      return;
    }
    
    selectedRashi.value = rashiName;
    generateRashifal();
    gainTapasya(15);
  }
  
  void generateRashifal() {
    if (selectedRashi.value.isEmpty) return;
    
    isReading.value = true;
    currentRashifal.value = '';
    
    Future.delayed(const Duration(seconds: 2), () {
      final random = DateTime.now().millisecondsSinceEpoch % vedicPredictions.length;
      currentRashifal.value = vedicPredictions[random];
      isReading.value = false;
      gainDhanCoins(10);
    });
  }
  
  void doPalmReading() {
    if (dhanCoins.value < 50) {
      Get.snackbar(
        'धन की कमी 💰',
        'हस्त रेखा देखने के लिए 50 सिक्के चाहिए',
        backgroundColor: Colors.red.withOpacity(0.8),
        colorText: Colors.white,
        icon: const Icon(Icons.error, color: Colors.white),
      );
      return;
    }
    
    dhanCoins.value -= 50;
    isReading.value = true;
    
    Future.delayed(const Duration(seconds: 3), () {
      final random = DateTime.now().millisecondsSinceEpoch % palmReadings.length;
      palmReadingResult.value = palmReadings[random];
      isReading.value = false;
      gainTapasya(30);
    });
  }
  
  void readKundali() {
    if (dhanCoins.value < 100) {
      Get.snackbar(
        'अपर्याप्त धन 🪙',
        'कुंडली देखने के लिए 100 सिक्के चाहिए',
        backgroundColor: Colors.red.withOpacity(0.8),
        colorText: Colors.white,
        icon: const Icon(Icons.error, color: Colors.white),
      );
      return;
    }
    
    dhanCoins.value -= 100;
    isReading.value = true;
    kundaliWheelController.forward();
    
    Future.delayed(const Duration(seconds: 4), () {
      final random = DateTime.now().millisecondsSinceEpoch % kundaliMessages.length;
      kundaliReading.value = kundaliMessages[random];
      isReading.value = false;
      kundaliWheelController.reverse();
      gainTapasya(50);
    });
  }
  
  void gainTapasya(int points) {
    tapasya.value += points;
    
    // Guru level up logic
    int newLevel = (tapasya.value / 200).floor() + 1;
    if (newLevel > guruLevel.value) {
      guruLevel.value = newLevel;
      unlockNewItems();
      Get.snackbar(
        'गुरु स्तर बढ़ा! 🙏',
        'आप गुरु स्तर $newLevel पर पहुंच गए!',
        backgroundColor: const Color(0xFFFF9500).withOpacity(0.9),
        colorText: Colors.white,
        icon: const Text('🕉️', style: TextStyle(fontSize: 20)),
        duration: const Duration(seconds: 3),
      );
    }
  }
  
  void gainDhanCoins(int amount) {
    dhanCoins.value += amount;
  }
  
  void unlockNewItems() {
    // Unlock new rashis
    for (var rashi in indianRashis) {
      if (!unlockedRashis.contains(rashi['name']) && 
          guruLevel.value >= getRequiredGuruLevel(rashi['name'])) {
        unlockedRashis.add(rashi['name']);
        Get.snackbar(
          'नई राशि खुली! ✨',
          '${rashi['name']} अब उपलब्ध है!',
          backgroundColor: rashi['color'].withOpacity(0.8),
          colorText: Colors.white,
          icon: Text(rashi['symbol'], style: const TextStyle(fontSize: 20)),
          duration: const Duration(seconds: 3),
        );
      }
    }
    
    // Unlock new nakshatras
    for (var nakshatra in nakshatras) {
      if (!unlockedNakshatras.contains(nakshatra['name']) && 
          guruLevel.value >= 3) {
        unlockedNakshatras.add(nakshatra['name']);
      }
    }
  }
  
  bool isRashiUnlocked(String rashiName) {
    return unlockedRashis.contains(rashiName);
  }
  
  int getRequiredGuruLevel(String rashiName) {
    int index = indianRashis.indexWhere((r) => r['name'] == rashiName);
    return (index ~/ 3) + 1;
  }
  
  @override
  void onClose() {
    omSymbolController.dispose();
    divaLampController.dispose();
    kundaliWheelController.dispose();
    super.onClose();
  }
}

// class GamesController extends GetxController with GetTickerProviderStateMixin {
//   // Observable variables
//   var selectedZodiac = ''.obs;
//   var currentHoroscope = ''.obs;
//   var crystalBallMessage = ''.obs;
//   var isReading = false.obs;
//   var playerLevel = 1.obs;
//   var experience = 0.obs;
//   var coins = 100.obs;
//   var unlockedZodiacs = <String>[].obs;
  
//   // Animation controllers
//   late AnimationController starAnimationController;
//   late AnimationController crystalBallController;
//   late Animation<double> starRotation;
//   late Animation<double> crystalBallGlow;
  
//   // Zodiac data
//   final List<Map<String, dynamic>> zodiacSigns = [
//     {'name': 'Aries', 'icon': '♈', 'element': 'Fire', 'color': Colors.red, 'unlocked': true},
//     {'name': 'Taurus', 'icon': '♉', 'element': 'Earth', 'color': Colors.green, 'unlocked': true},
//     {'name': 'Gemini', 'icon': '♊', 'element': 'Air', 'color': Colors.yellow, 'unlocked': true},
//     {'name': 'Cancer', 'icon': '♋', 'element': 'Water', 'color': Colors.blue, 'unlocked': false},
//     {'name': 'Leo', 'icon': '♌', 'element': 'Fire', 'color': Colors.orange, 'unlocked': false},
//     {'name': 'Virgo', 'icon': '♍', 'element': 'Earth', 'color': Colors.brown, 'unlocked': false},
//     {'name': 'Libra', 'icon': '♎', 'element': 'Air', 'color': Colors.pink, 'unlocked': false},
//     {'name': 'Scorpio', 'icon': '♏', 'element': 'Water', 'color': Colors.deepPurple, 'unlocked': false},
//     {'name': 'Sagittarius', 'icon': '♐', 'element': 'Fire', 'color': Colors.indigo, 'unlocked': false},
//     {'name': 'Capricorn', 'icon': '♑', 'element': 'Earth', 'color': Colors.grey, 'unlocked': false},
//     {'name': 'Aquarius', 'icon': '♒', 'element': 'Air', 'color': Colors.cyan, 'unlocked': false},
//     {'name': 'Pisces', 'icon': '♓', 'element': 'Water', 'color': Colors.teal, 'unlocked': false},
//   ];
  
//   // Horoscope predictions
//   final List<String> horoscopePredictions = [
//     "The stars align in your favor today. Great fortune awaits!",
//     "A mysterious encounter will change your perspective.",
//     "Your intuition will guide you to hidden treasures.",
//     "The cosmos whispers secrets of ancient wisdom to you.",
//     "A celestial blessing will illuminate your path forward.",
//     "The universe conspires to bring you unexpected joy.",
//     "Your spiritual energy is particularly strong today.",
//     "The moon's phases reveal hidden opportunities.",
//     "A karmic cycle is completing, bringing new beginnings.",
//     "The celestial bodies dance to bring you prosperity."
//   ];
  
//   // Crystal ball messages
//   final List<String> crystalMessages = [
//     "I see... a journey of self-discovery ahead...",
//     "The mists reveal... great love approaching...",
//     "Through the crystal depths... I see success...",
//     "The ethereal visions show... hidden talents awakening...",
//     "In the swirling energies... adventure calls...",
//     "The crystal speaks of... wisdom gained through experience...",
//     "I perceive... a guardian spirit watching over you...",
//     "The mystical energies reveal... a time of transformation..."
//   ];

//   @override
//   void onInit() {
//     super.onInit();
//     initializeAnimations();
//     initializeUnlockedZodiacs();
//   }
  
//   void initializeAnimations() {
//     starAnimationController = AnimationController(
//       duration: const Duration(seconds: 4),
//       vsync: this,
//     )..repeat();
    
//     crystalBallController = AnimationController(
//       duration: const Duration(seconds: 2),
//       vsync: this,
//     );
    
//     starRotation = Tween<double>(
//       begin: 0,
//       end: 2 * 3.14159,
//     ).animate(CurvedAnimation(
//       parent: starAnimationController,
//       curve: Curves.linear,
//     ));
    
//     crystalBallGlow = Tween<double>(
//       begin: 0.3,
//       end: 1.0,
//     ).animate(CurvedAnimation(
//       parent: crystalBallController,
//       curve: Curves.easeInOut,
//     ));
//   }
  
//   void initializeUnlockedZodiacs() {
//     unlockedZodiacs.value = ['Aries', 'Taurus', 'Gemini'];
//   }
  
//   void selectZodiac(String zodiacName) {
//     if (!isZodiacUnlocked(zodiacName)) {
//       Get.snackbar(
//         'Locked!',
//         'Reach level ${getRequiredLevel(zodiacName)} to unlock $zodiacName',
//         backgroundColor: Colors.deepPurple.withOpacity(0.8),
//         colorText: Colors.white,
//         icon: const Icon(Icons.lock, color: Colors.white),
//       );
//       return;
//     }
    
//     selectedZodiac.value = zodiacName;
//     generateHoroscope();
//     gainExperience(10);
//   }
  
//   void generateHoroscope() {
//     if (selectedZodiac.value.isEmpty) return;
    
//     isReading.value = true;
//     currentHoroscope.value = '';
    
//     Future.delayed(const Duration(seconds: 1), () {
//       final random = DateTime.now().millisecondsSinceEpoch % horoscopePredictions.length;
//       currentHoroscope.value = horoscopePredictions[random];
//       isReading.value = false;
//       gainCoins(5);
//     });
//   }
  
//   void useCrystalBall() {
//     if (coins.value < 20) {
//       Get.snackbar(
//         'Insufficient Coins',
//         'You need 20 coins to use the Crystal Ball',
//         backgroundColor: Colors.red.withOpacity(0.8),
//         colorText: Colors.white,
//         icon: const Icon(Icons.error, color: Colors.white),
//       );
//       return;
//     }
    
//     coins.value -= 20;
//     isReading.value = true;
//     crystalBallController.forward();
    
//     Future.delayed(const Duration(seconds: 2), () {
//       final random = DateTime.now().millisecondsSinceEpoch % crystalMessages.length;
//       crystalBallMessage.value = crystalMessages[random];
//       isReading.value = false;
//       crystalBallController.reverse();
//       gainExperience(25);
//     });
//   }
  
//   void gainExperience(int exp) {
//     experience.value += exp;
    
//     // Level up logic
//     int newLevel = (experience.value / 100).floor() + 1;
//     if (newLevel > playerLevel.value) {
//       playerLevel.value = newLevel;
//       unlockNewZodiac();
//       Get.snackbar(
//         'Level Up! 🌟',
//         'You reached level $newLevel!',
//         backgroundColor: Colors.amber.withOpacity(0.9),
//         colorText: Colors.white,
//         icon: const Icon(Icons.star, color: Colors.white),
//         duration: const Duration(seconds: 3),
//       );
//     }
//   }
  
//   void gainCoins(int amount) {
//     coins.value += amount;
//   }
  
//   void unlockNewZodiac() {
//     for (var zodiac in zodiacSigns) {
//       if (!unlockedZodiacs.contains(zodiac['name']) && 
//           playerLevel.value >= getRequiredLevel(zodiac['name'])) {
//         unlockedZodiacs.add(zodiac['name']);
//         Get.snackbar(
//           'New Zodiac Unlocked! ✨',
//           '${zodiac['name']} is now available!',
//           backgroundColor: zodiac['color'].withOpacity(0.8),
//           colorText: Colors.white,
//           icon: Text(zodiac['icon'], style: const TextStyle(fontSize: 20)),
//           duration: const Duration(seconds: 3),
//         );
//       }
//     }
//   }
  
//   bool isZodiacUnlocked(String zodiacName) {
//     return unlockedZodiacs.contains(zodiacName);
//   }
  
//   int getRequiredLevel(String zodiacName) {
//     int index = zodiacSigns.indexWhere((z) => z['name'] == zodiacName);
//     return (index ~/ 3) + 1; // Every 3 zodiacs require next level
//   }
  
//   @override
//   void onClose() {
//     starAnimationController.dispose();
//     crystalBallController.dispose();
//     super.onClose();
//   }
// }
