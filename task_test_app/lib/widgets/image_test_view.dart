import 'package:flutter/material.dart';
import 'package:task_test_app/l10n/app_localizations.dart';
import 'package:task_test_app/services/session_manager.dart';

import 'package:task_test_app/utils/app_sizes.dart';
import 'package:task_test_app/widgets/cached_image_widget.dart';

class _MenuButton {
  final IconData icon;
  final String label;
  final Color color;
  final Color iconColor;
  final Color textColor;
  final FontWeight? fontWeight;
  final VoidCallback onPressed;

  _MenuButton({
    required this.icon,
    required this.label,
    required this.color,
    required this.iconColor,
    required this.textColor,
    this.fontWeight,
    required this.onPressed,
  });
}

class ImageTestView extends StatefulWidget {
  final List<String> images;
  final String groupName;
  final String testName;
  final bool isPreTest;

  const ImageTestView({
    super.key,
    required this.images,
    required this.groupName,
    required this.testName,
    required this.isPreTest,
  });

  @override
  State<ImageTestView> createState() => _ImageTestViewState();
}

class _ImageTestViewState extends State<ImageTestView>
    with SingleTickerProviderStateMixin {
  int index = 0;
  bool showMenu = false;
  late List<String> filteredImages;

  late final AnimationController _menuController;
  late final Animation<Offset> _slideAnimation;

  void next() {
    setState(() => index = (index + 1) % filteredImages.length);
  }

  void prev() {
    setState(
      () => index = (index - 1 + filteredImages.length) % filteredImages.length,
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

  void closeMenuIfOpen() {
    if (showMenu) {
      setState(() {
        showMenu = false;
        _menuController.forward();
      });
    }
  }

  void skipImage() {
    final imagePath = filteredImages[index];
    SessionManager().skipImage(widget.groupName, widget.testName, imagePath);

    setState(() {
      filteredImages.removeAt(index);
      if (filteredImages.isEmpty) {
        showDialogNoImages();
        return;
      }
      if (index >= filteredImages.length) {
        index = 0;
      }
    });
    closeMenuIfOpen();
  }

  void quitTest() {
    if (SessionManager().hasActiveSession && !widget.isPreTest) {
      SessionManager().addCompletedTest(widget.groupName, widget.testName);
    }
    Navigator.pop(context);
  }

  void showDialogNoImages() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(AppLocalizations.of(context)!.testComplete),
        content: Text(AppLocalizations.of(context)!.noMoreImages),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(AppLocalizations.of(context)!.ok),
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    if (SessionManager().hasActiveSession) {
      filteredImages = widget.images
          .where(
            (image) => !SessionManager().isImageSkipped(
              widget.groupName,
              widget.testName,
              image,
            ),
          )
          .toList();
    } else {
      filteredImages = widget.images;
    }
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

    if (filteredImages.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: Text(AppLocalizations.of(context)!.testComplete)),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.check_circle_outline,
                size: AppSizes.iconSize(context),
                color: Colors.green,
              ),
              const SizedBox(height: 24),
              Text(
                AppLocalizations.of(context)!.noMoreImages,
                style: TextStyle(fontSize: AppSizes.fontSize(context)),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              ElevatedButton.icon(
                icon: const Icon(Icons.arrow_back),
                label: Text(
                  AppLocalizations.of(context)!.goBack,
                  style: TextStyle(fontSize: AppSizes.fontSize(context)),
                ),
                onPressed: () => Navigator.pop(context),
              ),
              ElevatedButton.icon(
                icon: const Icon(Icons.restore),
                label: Text(
                  AppLocalizations.of(context)!.restore,
                  style: TextStyle(fontSize: AppSizes.fontSize(context)),
                ),
                onPressed: () {
                  SessionManager().restoreSkippedImages(
                    widget.groupName,
                    widget.testName,
                  );
                  setState(() {
                    filteredImages = List.from(widget.images);
                  });
                },
              ),
            ],
          ),
        ),
      );
    }

    final image = filteredImages[index];

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
              child: CachedImageWidget(imageUrl: image, fit: BoxFit.contain)
            ),
          ),

          if (widget.isPreTest)
            Positioned(
              bottom: 20,
              left: 0,
              right: 0,
              child: Center(
                child: ElevatedButton.icon(
                  icon: Icon(Icons.skip_next, color: Colors.orange),
                  label: Text(
                    AppLocalizations.of(context)!.skipImage,
                    style: TextStyle(
                      color: Colors.orange,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueGrey,
                  ),
                  onPressed: skipImage,
                ),
              ),
            ),

          if (showMenu)
            FadeTransition(
              opacity: _menuController,
              child: Stack(
                children: [
                  _buildOverlayZones(context),
                  _buildProgressBar(context),
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

  Widget _buildProgressBar(BuildContext context) {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: LinearProgressIndicator(
        value: (index + 1) / filteredImages.length,
        backgroundColor: Colors.black26,
        valueColor: AlwaysStoppedAnimation<Color>(Colors.lightBlueAccent),
        minHeight: 4,
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
          _zoneOverlay(
            0,
            0,
            thirdWidth,
            halfHeight,
            "⟶ ${AppLocalizations.of(context)!.next}",
            context,
          ),
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
          _zoneOverlay(thirdWidth, 0, thirdWidth, size.height, "", context),
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
    final buttonPadding = AppSizes.isSmall(context) ? 28.0 : 40.0;
    final buttonWidth =
        MediaQuery.of(context).size.width * 0.2; // largeur fixe proportionnelle

    final List<_MenuButton> buttons = [
      _MenuButton(
        icon: Icons.stop_circle,
        label: AppLocalizations.of(context)!.endTest,
        color: Colors.redAccent,
        iconColor: Colors.white,
        textColor: Colors.white,
        onPressed: quitTest,
      ),
      _MenuButton(
        icon: Icons.close,
        label: AppLocalizations.of(context)!.closeMenu,
        color: Colors.blueGrey,
        iconColor: Colors.white,
        textColor: Colors.white,
        onPressed: toggleMenu,
      ),
      if (SessionManager().hasActiveSession)
        _MenuButton(
          icon: Icons.skip_next,
          label: AppLocalizations.of(context)!.skipImage,
          color: Colors.blueGrey,
          iconColor: Colors.orange,
          textColor: Colors.orange,
          fontWeight: FontWeight.bold,
          onPressed: skipImage,
        ),
      if (SessionManager().hasActiveSession)
        _MenuButton(
          icon: Icons.restore,
          label: AppLocalizations.of(context)!.restore,
          color: Colors.green,
          iconColor: Colors.white,
          textColor: Colors.white,
          onPressed: () {
            SessionManager().restoreSkippedImages(
              widget.groupName,
              widget.testName,
            );
            setState(() {
              filteredImages = List.from(widget.images);
            });
            toggleMenu();
          },
        ),
    ];

    return Center(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: buttons.map((btn) {
            return Container(
              width: buttonWidth,
              margin: const EdgeInsets.symmetric(vertical: 12),
              child: ElevatedButton.icon(
                icon: Icon(
                  btn.icon,
                  size: AppSizes.iconSize(context),
                  color: btn.iconColor,
                ),
                label: Text(
                  btn.label,
                  style: TextStyle(
                    fontSize: AppSizes.fontSize(context),
                    color: btn.textColor,
                    fontWeight: btn.fontWeight,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: btn.color,
                  padding: EdgeInsets.symmetric(vertical: buttonPadding),
                ),
                onPressed: btn.onPressed,
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
