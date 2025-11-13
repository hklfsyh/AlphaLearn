import '../../../../../core/core.dart';
import '../presentation/pages/alfabeth/alfabeth_menu_page.dart';
import '../presentation/pages/alfabeth/alfabeth_page.dart';
import '../presentation/pages/home/home_page.dart';
import '../presentation/pages/puzzle/puzzle_menu_page.dart';
import '../presentation/pages/puzzle/puzzle_page.dart';
import '../presentation/pages/splash/first_page.dart';
import '../presentation/pages/splash/splash_page.dart';
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
  ),
  GetPage(
    name: AppConstants.puzzleRoute,
    page: () => const PuzzlePage(),
  ),
  GetPage(
    name: AppConstants.alfabethMenuRoute,
    page: () => const AlfabethMenuPage(),
  ),
  GetPage(
    name: AppConstants.alfabethRoute,
    page: () => const AlfabethPage(),
  ),
];
