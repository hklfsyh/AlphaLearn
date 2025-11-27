import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AppBarCustom extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final bool showBackButton;
  final List<Widget>? actions;
  final double height;
  final double logoSize;

  const AppBarCustom({
    super.key,
    this.title,
    this.showBackButton = false,
    this.actions,
    this.height = 80,
    this.logoSize = 50,
  });

  @override
  Size get preferredSize => Size.fromHeight(height);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: preferredSize.height + MediaQuery.of(context).padding.top,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(28),
          bottomRight: Radius.circular(28),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.12),
            blurRadius: 20,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              if (showBackButton) _buildBackButton() else _buildLargeLogo(),

              const SizedBox(width: 16),

              // Title
              Expanded(
                child: title != null
                    ? Text(
                        title!,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                          fontFamily: 'Fredoka',
                        ),
                      )
                    : const SizedBox.shrink(),
              ),
              Material(
                elevation: 6,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                clipBehavior: Clip.antiAlias,
                child: SizedBox(
                  width: logoSize,
                  height: logoSize,
                  child: Image.asset(
                    'assets/images/flag_indo_img.png',
                    width: logoSize,
                    height: logoSize,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        width: logoSize,
                        height: logoSize,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              Colors.blue.shade400,
                              Colors.blue.shade700,
                            ],
                          ),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Icon(
                          Icons.school,
                          size: logoSize * 0.5,
                          color: Colors.white,
                        ),
                      );
                    },
                  ),
                ),
              ),
              // Actions
              if (actions != null) ...actions!,
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLargeLogo() {
    return SizedBox(
      width: logoSize,
      height: logoSize,
      child: Image.asset(
        'assets/images/logo_app.png',
        width: logoSize,
        height: logoSize,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return Container(
            width: logoSize,
            height: logoSize,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.blue.shade400,
                  Colors.blue.shade700,
                ],
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Icon(
              Icons.school,
              size: logoSize * 0.5,
              color: Colors.white,
            ),
          );
        },
      ),
    );
  }

  Widget _buildBackButton() {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => Get.back(),
        borderRadius: BorderRadius.circular(16),
        child: Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: Colors.grey.shade300,
              width: 1,
            ),
          ),
          child: const Icon(
            Icons.arrow_back_ios_new,
            size: 22,
            color: Colors.black87,
          ),
        ),
      ),
    );
  }
}
