import 'package:cached_network_image/cached_network_image.dart';
import 'package:cached_network_image_platform_interface/cached_network_image_platform_interface.dart';
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
  final Widget Function(String)? errorBuilder;
  final Widget Function(BuildContext, String)? placeholder;

  @override
  Widget build(BuildContext context) {
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
      maxWidthDiskCache: maxWidthDiskCache,
      maxHeightDiskCache: maxHeightDiskCache,
      imageRenderMethodForWeb: ImageRenderMethodForWeb.HttpGet,
      placeholder:
          placeholder ??
          (context, url) => Center(
            child: CustomShimmer(
              width: imageSize?.width ?? 32,
              height: imageSize?.height ?? 32,
            ),
          ),
      errorWidget:
          (context, url, error) =>
              errorBuilder?.call(error.toString()) ??
              ImageError(error: error.toString()),
    );
  }
}
