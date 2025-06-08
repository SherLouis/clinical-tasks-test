import 'package:flutter/material.dart';

class ImageTestView extends StatefulWidget {
  final List<String> images;

  const ImageTestView({super.key, required this.images});

  @override
  State<ImageTestView> createState() => _ImageTestViewState();
}

class _ImageTestViewState extends State<ImageTestView> {
  int index = 0;
  bool showMenu = false;

  void next() {
    if (index < widget.images.length - 1) setState(() => index++);
  }

  void prev() {
    if (index > 0) setState(() => index--);
  }

  @override
  Widget build(BuildContext context) {
    final image = widget.images[index];

    return GestureDetector(
      onTapUp: (details) {
        final size = MediaQuery.of(context).size;
        final dx = details.localPosition.dx;
        final dy = details.localPosition.dy;

        if (showMenu) return;

        if (dx < size.width / 3 && dy < size.height / 3) {
          prev();
        } else if (dx < size.width / 3 && dy > 2* size.height / 3) {
          next();
        } else if (dx > 2 * size.width / 3 && dy < size.height / 3) {
          next();
        } else if (dx > 2 * size.width / 3 && dy > 2 * size.height / 3) {
          prev();
        } else {
          setState(() => showMenu = true);
        }
      },
      child: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(image, fit: BoxFit.cover),
          ),
          if (showMenu)
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Fin du test'),
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () => setState(() => showMenu = false),
                    child: const Text('Fermer le menu'),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
