import 'package:alphalearn/presentation/pages/puzzle/puzzle_binding.dart';

import '../../../../../core/core.dart';
import '../presentation/pages/home/home_page.dart';
import '../presentation/pages/puzzle/puzzle_menu_page.dart';
import '../presentation/pages/puzzle/puzzle_level_page.dart';
import '../presentation/pages/puzzle/puzzle_game_page.dart';
import '../presentation/pages/splash/first_page.dart';
import '../presentation/pages/splash/splash_page.dart';
import '../presentation/pages/alfabeth/alfabet_page.dart';
import '../presentation/pages/alfabeth/alfabet_menu_page.dart';
import '../presentation/pages/alfabeth/alfabet_level_page.dart';
import '../presentation/pages/alfabeth/alfabet_binding.dart';
// import '../presentation/pages/dev/database_debug_page.dart'; // Development only
import 'package:get/get.dart';

final appPages = [
  GetPage(
    name: AppConstants.splashRoute,
    page: () => const SplashPage(),
  ),
  GetPage(
    name: AppConstants.firstRoute,
    page: () => const FirstPage(),
  ),
  GetPage(
    name: AppConstants.homeRoute,
    page: () => const HomePage(),
  ),
  GetPage(
    name: AppConstants.puzzleMenuRoute,
    page: () => const PuzzleMenuPage(),
    binding: PuzzleBinding(),
  ),
  GetPage(
    name: AppConstants.puzzleLevelRoute,
    page: () => const PuzzleLevelPage(),
    binding: PuzzleBinding(),
  ),
  GetPage(
    name: AppConstants.puzzleRoute,
    page: () => const PuzzleGamePage(),
    binding: PuzzleBinding(),
  ),
  GetPage(
    name: AppConstants.alfabethMenuRoute,
    page: () => const AlfabetMenuPage(),
    binding: AlfabetBinding(),
  ),
  GetPage(
    name: AppConstants.alfabethLevelRoute,
    page: () => const AlfabetLevelPage(),
    binding: AlfabetBinding(),
  ),
  GetPage(
    name: AppConstants.alfabethRoute,
    page: () => const AlphabetGamePage(),
  ),
  // Development only - hapus sebelum production
  // GetPage(
  //   name: AppConstants.databaseDebugRoute,
  //   page: () => const DatabaseDebugPage(),
  // ),
];
