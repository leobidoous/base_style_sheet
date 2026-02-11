import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

import '../containers/custom_shimmer.dart';
import 'widgets/image_error.dart';

class ImageUrl extends StatelessWidget {
  const ImageUrl({
    super.key,
    required this.fit,
    required this.url,
    required this.headers,
    required this.cacheKey,
    required this.imageSize,
    required this.placeholder,
    required this.cacheManager,
    required this.errorBuilder,
    required this.memCacheWidth,
    required this.memCacheHeight,
    required this.maxWidthDiskCache,
    required this.maxHeightDiskCache,
  });

  final BoxFit fit;
  final String url;
  final String? cacheKey;
  final Size? imageSize;
  final int? memCacheWidth;
  final int? memCacheHeight;
  final int? maxWidthDiskCache;
  final int? maxHeightDiskCache;
  final Map<String, String>? headers;
  final BaseCacheManager? cacheManager;
  final Widget Function(String err)? errorBuilder;
  final Widget Function(BuildContext context, String value)? placeholder;

  @override
  Widget build(BuildContext context) {
    // No web, usar Image.network diretamente evita CORS issues
    if (kIsWeb) {
      return Image.network(
        url,
        fit: fit,
        headers: headers,
        width: imageSize?.width,
        height: imageSize?.height,
        cacheWidth: memCacheWidth,
        cacheHeight: memCacheHeight,
        webHtmlElementStrategy: .prefer,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return placeholder?.call(context, url) ??
              Center(
                child: CustomShimmer(
                  width: imageSize?.width ?? 32,
                  height: imageSize?.height ?? 32,
                ),
              );
        },
        errorBuilder: (context, error, stackTrace) =>
            errorBuilder?.call(error.toString()) ??
            ImageError(error: error.toString()),
      );
    }

    // Mobile: usar CachedNetworkImage para cache otimizado
    return CachedNetworkImage(
      fit: fit,
      key: key,
      imageUrl: url,
      cacheKey: cacheKey,
      httpHeaders: headers,
      width: imageSize?.width,
      height: imageSize?.height,
      cacheManager: cacheManager,
      memCacheWidth: memCacheWidth,
      memCacheHeight: memCacheHeight,
      imageRenderMethodForWeb: .HtmlImage,
      maxWidthDiskCache: maxWidthDiskCache,
      maxHeightDiskCache: maxHeightDiskCache,
      placeholder:
          placeholder ??
          (context, url) => Center(
            child: CustomShimmer(
              width: imageSize?.width ?? 32,
              height: imageSize?.height ?? 32,
            ),
          ),
      errorWidget: (context, url, error) =>
          errorBuilder?.call(error.toString()) ??
          ImageError(error: error.toString()),
    );
  }
}
