import 'dart:io' show File;

import 'package:flutter/material.dart'
    show
        AssetImage,
        BlendMode,
        Border,
        BorderRadius,
        BoxFit,
        BoxShadow,
        BuildContext,
        Center,
        Color,
        ColorFilter,
        FileImage,
        IgnorePointer,
        Image,
        InkWell,
        Semantics,
        Size,
        SizedBox,
        StatelessWidget,
        Widget;
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_svg/svg.dart';

import '../containers/custom_card.dart';
import '../containers/custom_shimmer.dart';
import 'image_url.dart' show ImageUrl;
import 'widgets/custom_photo_view.dart';
import 'widgets/image_error.dart';

class CustomImage extends StatelessWidget {
  const CustomImage({
    super.key,
    this.url,
    this.file,
    this.asset,
    this.onTap,
    this.urlSvg,
    this.border,
    this.headers,
    this.shaddow,
    this.svgAsset,
    this.cacheKey,
    this.imageSize,
    this.imageColor,
    this.packageName,
    this.placeholder,
    this.errorBuilder,
    this.cacheManager,
    this.memCacheWidth,
    this.memCacheHeight,
    this.backgroundColor,
    this.maxWidthDiskCache,
    this.maxHeightDiskCache,
    this.fit = BoxFit.contain,
    this.enableGestures = false,
    this.borderRadius = .zero,
  });

  final File? file;
  final BoxFit fit;
  final String? url;
  final String? asset;
  final String? urlSvg;
  final Border? border;
  final Size? imageSize;
  final String? cacheKey;
  final String? svgAsset;
  final Color? imageColor;
  final Function()? onTap;
  final int? memCacheWidth;
  final bool enableGestures;
  final int? memCacheHeight;
  final String? packageName;
  final Color? backgroundColor;
  final int? maxWidthDiskCache;
  final int? maxHeightDiskCache;
  final List<BoxShadow>? shaddow;
  final BorderRadius borderRadius;
  final Map<String, String>? headers;
  final BaseCacheManager? cacheManager;
  final Widget Function(String)? errorBuilder;
  final Widget Function(BuildContext, String)? placeholder;

  Widget _error([Object? err, StackTrace? stackTrace]) =>
      errorBuilder?.call('${err?.toString()} $stackTrace') ??
      ImageError(error: '${err?.toString()} $stackTrace');

  Widget? get _urlImage {
    if (url?.isEmpty ?? true) return null;
    return ImageUrl(
      fit: fit,
      url: url!,
      headers: headers,
      cacheKey: cacheKey,
      imageSize: imageSize,
      errorBuilder: _error,
      placeholder: placeholder,
      cacheManager: cacheManager,
      memCacheWidth: memCacheWidth,
      memCacheHeight: memCacheHeight,
      maxWidthDiskCache: maxWidthDiskCache,
      maxHeightDiskCache: maxHeightDiskCache,
    );
  }

  Widget? get _svgUrlImage {
    if (urlSvg?.isEmpty ?? true) return null;
    return SvgPicture.network(
      fit: fit,
      urlSvg!,
      headers: headers,
      width: imageSize?.width,
      height: imageSize?.height,
      colorFilter: (imageColor != null)
          ? ColorFilter.mode(imageColor!, BlendMode.srcIn)
          : null,
      errorBuilder: (_, error, stackTrace) => _error(error, stackTrace),
      placeholderBuilder: (context) => Center(
        child: CustomShimmer(
          width: imageSize?.width ?? 32,
          height: imageSize?.height ?? 32,
        ),
      ),
    );
  }

  Widget? get _svgAsset {
    if (svgAsset?.isEmpty ?? true) return null;
    return SvgPicture.asset(
      svgAsset!,
      fit: fit,
      width: imageSize?.width,
      height: imageSize?.height,
      package: packageName,
      errorBuilder: (_, error, stackTrace) => _error(error, stackTrace),
      colorFilter: (imageColor != null)
          ? ColorFilter.mode(imageColor!, BlendMode.srcIn)
          : null,
    );
  }

  Widget? _asset(BuildContext context) {
    if (asset?.isEmpty ?? true) return null;
    return Semantics(
      button: true,
      child: InkWell(
        onTap: () => CustomPhotoView(
          image: AssetImage(asset!, package: packageName),
        ).show(context),
        child: Image.asset(
          asset!,
          fit: fit,
          color: imageColor,
          package: packageName,
          width: imageSize?.width,
          height: imageSize?.height,
          errorBuilder: (_, error, stackTrace) => _error(error, stackTrace),
        ),
      ),
    );
  }

  Widget? _file(BuildContext context) {
    if (file?.path.isEmpty ?? true) return null;
    return Semantics(
      button: true,
      child: InkWell(
        onTap: () => CustomPhotoView(image: FileImage(file!)).show(context),
        child: Image.file(
          file!,
          fit: fit,
          color: imageColor,
          width: imageSize?.width,
          height: imageSize?.height,
          errorBuilder: (_, error, stackTrace) => _error(error, stackTrace),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CustomCard(
      onTap: onTap,
      border: border,
      shaddow: shaddow,
      color: backgroundColor,
      borderRadius: borderRadius,
      child: SizedBox(
        width: imageSize?.width,
        height: imageSize?.height,
        child: IgnorePointer(
          ignoring: !enableGestures,
          child:
              _urlImage ??
              _svgUrlImage ??
              _asset(context) ??
              _svgAsset ??
              _file(context) ??
              _error(),
        ),
      ),
    );
  }
}
