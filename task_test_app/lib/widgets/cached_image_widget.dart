import 'package:flutter/material.dart';
import 'dart:typed_data';
import '../services/image_cache_service.dart';

class CachedImageWidget extends StatefulWidget {
  final String imageUrl;
  final double? width;
  final double? height;
  final BoxFit? fit;
  final Widget? placeholder;
  final Widget? errorWidget;
  final bool showLoadingIndicator;

  const CachedImageWidget({
    super.key,
    required this.imageUrl,
    this.width,
    this.height,
    this.fit,
    this.placeholder,
    this.errorWidget,
    this.showLoadingIndicator = true,
  });

  @override
  State<CachedImageWidget> createState() => _CachedImageWidgetState();
}

class _CachedImageWidgetState extends State<CachedImageWidget> {
  Uint8List? _imageData;
  bool _isLoading = false;
  bool _hasError = false;
  final ImageCacheService _imageCacheService = ImageCacheService.instance;

  @override
  void initState() {
    super.initState();
    _loadImage();
  }

  @override
  void didUpdateWidget(CachedImageWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.imageUrl != widget.imageUrl) {
      _loadImage();
    }
  }

  Future<void> _loadImage() async {
    if (mounted) {
      setState(() {
        _isLoading = true;
        _hasError = false;
      });
    }

    try {
      // Check if image is already cached in memory
      if (_imageCacheService.isImageCachedInMemory(widget.imageUrl)) {
        final imageData = _imageCacheService.getCachedImageFromMemory(widget.imageUrl);
        if (mounted) {
          setState(() {
            _imageData = imageData;
            _isLoading = false;
          });
        }
        return;
      }

      // Get image data (will cache if not already cached)
      final imageData = await _imageCacheService.getImageData(widget.imageUrl);
      
      if (mounted) {
        setState(() {
          _imageData = imageData;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _hasError = true;
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_hasError) {
      return widget.errorWidget ?? 
        Container(
          width: widget.width,
          height: widget.height,
          color: Colors.grey[300],
          child: const Icon(
            Icons.error_outline,
            color: Colors.red,
            size: 32,
          ),
        );
    }

    if (_isLoading) {
      if (widget.showLoadingIndicator) {
        return Container(
          width: widget.width,
          height: widget.height,
          color: Colors.grey[200],
          child: const Center(
            child: CircularProgressIndicator(),
          ),
        );
      } else {
        return widget.placeholder ?? 
          Container(
            width: widget.width,
            height: widget.height,
            color: Colors.grey[200],
          );
      }
    }

    if (_imageData != null) {
      return Image.memory(
        _imageData!,
        width: widget.width,
        height: widget.height,
        fit: widget.fit ?? BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return widget.errorWidget ?? 
            Container(
              width: widget.width,
              height: widget.height,
              color: Colors.grey[300],
              child: const Icon(
                Icons.error_outline,
                color: Colors.red,
                size: 32,
              ),
            );
        },
      );
    }

    return widget.placeholder ?? 
      Container(
        width: widget.width,
        height: widget.height,
        color: Colors.grey[200],
      );
  }
}
