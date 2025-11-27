import 'package:alphalearn/core/core.dart';
import 'package:alphalearn/presentation/pages/home/about/about_tab.dart';
import 'package:alphalearn/presentation/pages/home/menu/menu_tab.dart';
import 'package:alphalearn/presentation/pages/home/progress/progress_tab.dart';
import 'package:alphalearn/presentation/widget/app_bar_custom.dart';
import 'package:alphalearn/presentation/widget/circle_tab.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_floating_bottom_bar/flutter_floating_bottom_bar.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  late final TabController tabController;
  int currentPage = 0;

  final Color unselectedColor = Colors.white70;

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 3, vsync: this, initialIndex: 1);
    currentPage = tabController.index;
    tabController.addListener(() {
      if (!tabController.indexIsChanging) {
        setState(() => currentPage = tabController.index);
      }
    });
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    return BottomBar(
      fit: StackFit.expand,
      borderRadius: BorderRadius.circular(500),
      duration: const Duration(seconds: 1),
      curve: Curves.decelerate,
      showIcon: true,
      width: screenWidth * 0.7,
      barColor: AppColors.greenDark,
      start: 2,
      end: 0,
      offset: 5,
      barAlignment: Alignment.bottomCenter,
      reverse: false,
      barDecoration: BoxDecoration(
        borderRadius: BorderRadius.circular(500),
      ),
      iconDecoration: BoxDecoration(
        borderRadius: BorderRadius.circular(500),
      ),
      hideOnScroll: true,
      scrollOpposite: false,
      onBottomBarHidden: () {},
      onBottomBarShown: () {},
      body: (context, controller) => Scaffold(
        backgroundColor: AppColors.white,
        appBar: AppBarCustom(
          height: 70,
        ),
        body: Stack(
          children: [
            Positioned.fill(
              child: Image.asset(
                'assets/images/background_main_page.png',
                fit: BoxFit.cover,
              ),
            ),
            TabBarView(
              controller: tabController,
              dragStartBehavior: DragStartBehavior.down,
              physics: const BouncingScrollPhysics(),
              children: const [
                AboutTab(),
                MenuTab(),
                ProgressTab(),
              ],
            ),
          ],
        ),
      ),
      child: TabBar(
        splashFactory: NoSplash.splashFactory,
        controller: tabController,
        indicatorColor: Colors.transparent,
        indicatorSize: TabBarIndicatorSize.tab,
        indicatorPadding: const EdgeInsets.symmetric(vertical: 4.0),
        tabs: const [
          CircleTab(
            color: AppColors.brownLight,
            icon: 'icon_about',
            label: "About",
          ),
          CircleTab(
            color: AppColors.greenLight,
            icon: 'icon_home',
            label: "Home",
          ),
          CircleTab(
            color: AppColors.redLight,
            icon: 'icon_progress',
            label: "Progress",
          ),
        ],
      ),
    );
  }
}
