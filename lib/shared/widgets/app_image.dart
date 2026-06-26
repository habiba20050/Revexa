import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:revexa/core/utils/image_url_utils.dart';

class AppImage extends StatelessWidget {
  final String? source;
  final BoxFit fit;
  final double? width;
  final double? height;
  final Widget? placeholder;
  final Widget? errorWidget;

  const AppImage({
    super.key,
    required this.source,
    this.fit = BoxFit.cover,
    this.width,
    this.height,
    this.placeholder,
    this.errorWidget,
  });

  @override
  Widget build(BuildContext context) {
    final resolved = ImageUrlUtils.resolve(source);
    if (resolved == null || resolved.isEmpty) {
      return errorWidget ?? const SizedBox.shrink();
    }
    if (ImageUrlUtils.isAsset(resolved)) {
      return Image.asset(
        resolved,
        fit: fit,
        width: width,
        height: height,
        errorBuilder: (_, __, ___) =>
            errorWidget ?? const SizedBox.shrink(),
      );
    }
    if (ImageUrlUtils.isNetwork(resolved)) {
      return CachedNetworkImage(
        imageUrl: resolved,
        fit: fit,
        width: width,
        height: height,
        placeholder: (_, __) =>
            placeholder ??
            const Center(
              child: SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator.adaptive(strokeWidth: 2),
              ),
            ),
        errorWidget: (_, __, ___) =>
            errorWidget ?? const SizedBox.shrink(),
      );
    }
    return errorWidget ?? const SizedBox.shrink();
  }
}

class AppCircleAvatar extends StatelessWidget {
  final String? imageUrl;
  final double radius;
  final Color backgroundColor;
  final Widget fallback;

  const AppCircleAvatar({
    super.key,
    required this.imageUrl,
    required this.radius,
    required this.backgroundColor,
    required this.fallback,
  });

  @override
  Widget build(BuildContext context) {
    final resolved = ImageUrlUtils.resolve(imageUrl);
    final size = radius * 2;
    if (resolved != null &&
        (ImageUrlUtils.isNetwork(resolved) || ImageUrlUtils.isAsset(resolved))) {
      return ClipOval(
        child: SizedBox(
          width: size,
          height: size,
          child: AppImage(
            source: resolved,
            fit: BoxFit.cover,
            width: size,
            height: size,
            errorWidget: _fallbackBox(fallback),
          ),
        ),
      );
    }
    return CircleAvatar(
      radius: radius,
      backgroundColor: backgroundColor,
      child: fallback,
    );
  }

  Widget _fallbackBox(Widget child) {
    return Container(
      width: size,
      height: size,
      color: backgroundColor,
      alignment: Alignment.center,
      child: child,
    );
  }

  double get size => radius * 2;
}
