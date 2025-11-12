import 'package:flutter/material.dart';

class AppSizes {
  // Spacing
  static const double xs = 4.0;
  static const double sm = 8.0;
  static const double md = 16.0;
  static const double lg = 24.0;
  static const double xl = 32.0;
  static const double xxl = 40.0;

  // Padding
  static const double paddingXs = 4.0;
  static const double paddingSm = 8.0;
  static const double paddingMd = 16.0;
  static const double paddingLg = 24.0;
  static const double paddingXl = 32.0;

  // Margin
  static const double marginXs = 4.0;
  static const double marginSm = 8.0;
  static const double marginMd = 16.0;
  static const double marginLg = 24.0;
  static const double marginXl = 32.0;

  // Border Radius
  static const double radiusXs = 4.0;
  static const double radiusSm = 8.0;
  static const double radiusMd = 12.0;
  static const double radiusLg = 16.0;
  static const double radiusXl = 20.0;
  static const double radiusCircle = 50.0;

  // Icon Sizes
  static const double iconXs = 16.0;
  static const double iconSm = 20.0;
  static const double iconMd = 24.0;
  static const double iconLg = 32.0;
  static const double iconXl = 40.0;
  static const double iconXxl = 48.0;

  // Button Sizes
  static const double buttonHeightSm = 32.0;
  static const double buttonHeightMd = 44.0;
  static const double buttonHeightLg = 52.0;
  static const double buttonWidthSm = 80.0;
  static const double buttonWidthMd = 120.0;
  static const double buttonWidthLg = 160.0;

  // Input Field Sizes
  static const double inputHeightSm = 40.0;
  static const double inputHeightMd = 48.0;
  static const double inputHeightLg = 56.0;

  // Avatar Sizes
  static const double avatarSm = 32.0;
  static const double avatarMd = 48.0;
  static const double avatarLg = 64.0;
  static const double avatarXl = 80.0;

  // App Bar
  static const double appBarHeight = 56.0;
  static const double appBarElevation = 0.0;

  // Bottom Navigation
  static const double bottomNavHeight = 60.0;
  static const double bottomNavElevation = 8.0;

  // Card
  static const double cardElevation = 2.0;
  static const double cardBorderRadius = 12.0;

  // Divider
  static const double dividerThickness = 1.0;

  // Loading Indicator
  static const double loadingIndicatorSize = 24.0;

  // Breakpoints for Responsive Design
  static const double mobileBreakpoint = 600.0;
  static const double tabletBreakpoint = 900.0;
  static const double desktopBreakpoint = 1200.0;

  // Container Constraints
  static const double maxContentWidth = 1200.0;
  static const double minContentWidth = 320.0;

  // List Item
  static const double listItemHeight = 60.0;
  static const double listItemPadding = 16.0;

  // Snackbar
  static const double snackbarElevation = 6.0;
  static const double snackbarBorderRadius = 8.0;

  // Dialog
  static const double dialogBorderRadius = 16.0;
  static const double dialogElevation = 8.0;

  // Bottom Sheet
  static const double bottomSheetBorderRadius = 16.0;
  static const double bottomSheetElevation = 8.0;

  // Common EdgeInsets
  static const EdgeInsets paddingAll = EdgeInsets.all(paddingMd);
  static const EdgeInsets paddingHorizontal = EdgeInsets.symmetric(
    horizontal: paddingMd,
  );
  static const EdgeInsets paddingVertical = EdgeInsets.symmetric(
    vertical: paddingMd,
  );
  static const EdgeInsets paddingAllSm = EdgeInsets.all(paddingSm);
  static const EdgeInsets paddingAllLg = EdgeInsets.all(paddingLg);

  static const EdgeInsets marginAll = EdgeInsets.all(marginMd);
  static const EdgeInsets marginHorizontal = EdgeInsets.symmetric(
    horizontal: marginMd,
  );
  static const EdgeInsets marginVertical = EdgeInsets.symmetric(
    vertical: marginMd,
  );
  static const EdgeInsets marginAllSm = EdgeInsets.all(marginSm);
  static const EdgeInsets marginAllLg = EdgeInsets.all(marginLg);

  // Common BorderRadius
  static const BorderRadius borderRadiusSm = BorderRadius.all(
    Radius.circular(radiusSm),
  );
  static const BorderRadius borderRadiusMd = BorderRadius.all(
    Radius.circular(radiusMd),
  );
  static const BorderRadius borderRadiusLg = BorderRadius.all(
    Radius.circular(radiusLg),
  );
  static const BorderRadius borderRadiusXl = BorderRadius.all(
    Radius.circular(radiusXl),
  );

  // Common Shadows
  static const List<BoxShadow> shadowSm = [
    BoxShadow(color: Colors.black12, blurRadius: 2.0, offset: Offset(0, 1)),
  ];

  static const List<BoxShadow> shadowMd = [
    BoxShadow(color: Colors.black12, blurRadius: 4.0, offset: Offset(0, 2)),
  ];

  static const List<BoxShadow> shadowLg = [
    BoxShadow(color: Colors.black12, blurRadius: 8.0, offset: Offset(0, 4)),
  ];
}
