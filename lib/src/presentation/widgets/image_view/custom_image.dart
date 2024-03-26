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
        Builder,
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
    this.urlSvgAsset,
    this.imageSize,
    this.asset,
    this.svgAsset,
    this.onTap,
    this.backgroundColor,
    this.border,
    this.packageName,
    this.shaddow = const [],
    this.fit = BoxFit.contain,
    this.enableGestures = false,
    this.borderRadius = BorderRadius.zero,
    this.imageColor,
    this.headers,
    this.maxHeightDiskCache,
    this.maxWidthDiskCache,
  });

  final File? file;
  final BoxFit fit;
  final String? url;
  final String? urlSvgAsset;
  final String? asset;
  final String? svgAsset;
  final Size? imageSize;
  final Color? backgroundColor;
  final Color? imageColor;
  final Border? border;
  final String? packageName;
  final List<BoxShadow> shaddow;
  final BorderRadius borderRadius;
  final bool enableGestures;
  final Function()? onTap;
  final int? maxWidthDiskCache;
  final int? maxHeightDiskCache;
  final Map<String, String>? headers;

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
          child: Builder(
            builder: (_) {
              if (url != null && url!.isNotEmpty) {
                return ImageUrl(
                  fit: fit,
                  url: url!,
                  headers: headers,
                  imageSize: imageSize,
                  maxWidthDiskCache: maxWidthDiskCache,
                  maxHeightDiskCache: maxHeightDiskCache,
                );
              } else if (urlSvgAsset != null && urlSvgAsset!.isNotEmpty) {
                return Semantics(
                  button: true,
                  child: InkWell(
                    onTap: () => CustomPhotoView(
                      image: AssetImage(asset!, package: packageName),
                    ).show(context),
                    child: SvgPicture.network(
                      urlSvgAsset!,
                      fit: fit,
                      width: imageSize?.width,
                      height: imageSize?.height,
                      colorFilter: (imageColor != null)
                          ? ColorFilter.mode(imageColor!, BlendMode.srcIn)
                          : null,
                      headers: headers,
                      placeholderBuilder: (context) => Center(
                        child: CustomShimmer(
                          width: imageSize?.width ?? 32,
                          height: imageSize?.height ?? 32,
                        ),
                      ),
                    ),
                  ),
                );
              } else if (asset != null && asset!.isNotEmpty) {
                return Semantics(
                  button: true,
                  child: InkWell(
                    onTap: () => CustomPhotoView(
                      image: AssetImage(asset!, package: packageName),
                    ).show(context),
                    child: Image.asset(
                      asset!,
                      fit: fit,
                      width: imageSize?.width,
                      height: imageSize?.height,
                      package: packageName,
                      color: imageColor,
                    ),
                  ),
                );
              } else if (svgAsset != null && svgAsset!.isNotEmpty) {
                return SvgPicture.asset(
                  svgAsset!,
                  fit: fit,
                  width: imageSize?.width,
                  height: imageSize?.height,
                  package: packageName,
                  colorFilter: (imageColor != null)
                      ? ColorFilter.mode(imageColor!, BlendMode.srcIn)
                      : null,
                );
              } else if (file != null) {
                return Semantics(
                  button: true,
                  child: InkWell(
                    onTap: () => CustomPhotoView(image: FileImage(file!)).show(
                      context,
                    ),
                    child: Image.file(
                      file!,
                      fit: fit,
                      width: imageSize?.width,
                      height: imageSize?.height,
                      color: imageColor,
                      errorBuilder: (context, error, stackTrace) => ImageError(
                        error: error.toString(),
                      ),
                    ),
                  ),
                );
              }
              return const ImageError(error: 'Nenhuma imagem fornecida');
            },
          ),
        ),
      ),
    );
  }
}
