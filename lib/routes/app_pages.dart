import 'package:alphalearn/core/core.dart';
import 'package:alphalearn/presentation/pages/about/about_page.dart';
import 'package:alphalearn/presentation/pages/alfabeth/alfabeth_menu_page.dart';
import 'package:alphalearn/presentation/pages/alfabeth/alfabeth_page.dart';
import 'package:alphalearn/presentation/pages/home/home_page.dart';
import 'package:alphalearn/presentation/pages/progress/progress_page.dart';
import 'package:alphalearn/presentation/pages/puzzle/puzzle_menu_page.dart';
import 'package:alphalearn/presentation/pages/puzzle/puzzle_page.dart';
import 'package:alphalearn/presentation/pages/splash/first_page.dart';
import 'package:alphalearn/presentation/pages/splash/splash_page.dart';
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
    name: AppConstants.aboutRoute,
    page: () => const AboutPage(),
  ),
  GetPage(
    name: AppConstants.progressRoute,
    page: () => const ProgressPage(),
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
