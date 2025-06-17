import 'package:flutter/material.dart';
import 'package:task_test_app/l10n/app_localizations.dart';

import 'package:task_test_app/utils/app_sizes.dart';

class ImageTestView extends StatefulWidget {
  final List<String> images;

  const ImageTestView({super.key, required this.images});

  @override
  State<ImageTestView> createState() => _ImageTestViewState();
}

class _ImageTestViewState extends State<ImageTestView>
    with SingleTickerProviderStateMixin {
  int index = 0;
  bool showMenu = false;
  late final AnimationController _menuController;
  late final Animation<Offset> _slideAnimation;

  void next() {
    setState(() => index = (index + 1) % widget.images.length);
  }

  void prev() {
    setState(
      () => index = (index - 1 + widget.images.length) % widget.images.length,
    );
  }

  void toggleMenu() {
    setState(() {
      showMenu = !showMenu;
      if (showMenu) {
        _menuController.forward();
      } else {
        _menuController.reverse();
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _menuController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, -0.1),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _menuController, curve: Curves.easeOut));
  }

  @override
  void dispose() {
    _menuController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final image = widget.images[index];

    return GestureDetector(
      onTapUp: (details) {
        if (showMenu) return;

        final dx = details.localPosition.dx;
        final dy = details.localPosition.dy;

        final thirdWidth = size.width / 3;
        final isLeft = dx < thirdWidth;
        final isRight = dx > thirdWidth * 2;
        final isCenter = !isLeft && !isRight;

        final isTop = dy < size.height / 2;

        if (isCenter) {
          toggleMenu();
        } else if (isTop) {
          next();
        } else {
          prev();
        }
      },
      onDoubleTap: toggleMenu,
      onLongPress: toggleMenu,
      child: Stack(
        children: [
          Center(
            child: SizedBox.expand(
              key: ValueKey<String>(image),
              child: Image.asset(image, fit: BoxFit.contain),
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: LinearProgressIndicator(
              value: (index + 1) / widget.images.length,
              backgroundColor: Colors.black26,
              valueColor: AlwaysStoppedAnimation<Color>(Colors.lightBlueAccent),
              minHeight: 4,
            ),
          ),

          if (showMenu)
            FadeTransition(
              opacity: _menuController,
              child: Stack(
                children: [
                  _buildOverlayZones(context),
                  SlideTransition(
                    position: _slideAnimation,
                    child: _buildMenuButtons(context),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildOverlayZones(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final thirdWidth = size.width / 3;
    final halfHeight = size.height / 2;

    return IgnorePointer(
      child: Stack(
        children: [
          _zoneOverlay(0, 0, thirdWidth, halfHeight, "⟶ ${AppLocalizations.of(context)!.next}", context),
          _zoneOverlay(
            0,
            halfHeight,
            thirdWidth,
            halfHeight,
            "⟵ ${AppLocalizations.of(context)!.previous}",
            context,
          ),
          _zoneOverlay(
            thirdWidth * 2,
            0,
            thirdWidth,
            halfHeight,
            "⟶ ${AppLocalizations.of(context)!.next}",
            context,
          ),
          _zoneOverlay(
            thirdWidth * 2,
            halfHeight,
            thirdWidth,
            halfHeight,
            "⟵ ${AppLocalizations.of(context)!.previous}",
            context,
          ),
          _zoneOverlay(
            thirdWidth,
            0,
            thirdWidth,
            size.height,
            "☰ ${AppLocalizations.of(context)!.showMenu}",
            context,
          ),
        ],
      ),
    );
  }

  Widget _zoneOverlay(
    double left,
    double top,
    double width,
    double height,
    String label,
    BuildContext context,
  ) {
    return Positioned(
      left: left,
      top: top,
      width: width,
      height: height,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.black87,
          border: Border.all(color: Colors.white60, width: 1),
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              color: Colors.white,
              fontSize: AppSizes.fontSize(context),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMenuButtons(BuildContext context) {
    final size = MediaQuery.of(context).size;

    final horizontalMargin = size.width * 0.4;

    final buttonPadding = AppSizes.isSmall(context) ? 28.0 : 40.0;

    return Stack(
      children: [
        // Bouton Terminer
        Positioned(
          top: size.height * 0.15,
          left: horizontalMargin,
          right: horizontalMargin,
          child: ElevatedButton.icon(
            icon: Icon(Icons.stop_circle, size: AppSizes.iconSize(context)),
            label: Text(
              AppLocalizations.of(context)!.endTest,
              style: TextStyle(fontSize: AppSizes.fontSize(context)),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.redAccent,
              padding: EdgeInsets.symmetric(vertical: buttonPadding),
            ),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        // Bouton Fermer menu
        Positioned(
          bottom: size.height * 0.15,
          left: horizontalMargin,
          right: horizontalMargin,
          child: ElevatedButton.icon(
            icon: Icon(Icons.close, size: AppSizes.iconSize(context)),
            label: Text(
              AppLocalizations.of(context)!.closeMenu,
              style: TextStyle(fontSize: AppSizes.fontSize(context)),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blueGrey,
              padding: EdgeInsets.symmetric(vertical: buttonPadding),
            ),
            onPressed: toggleMenu,
          ),
        ),
      ],
    );
  }
}
