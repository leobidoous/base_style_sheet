import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../containers/custom_shimmer.dart';
import 'widgets/custom_photo_view.dart';
import 'widgets/image_error.dart';

class ImageUrl extends StatelessWidget {
  const ImageUrl({
    super.key,
    required this.fit,
    required this.url,
    required this.imageSize,
  });

  final BoxFit fit;
  final String url;
  final Size? imageSize;

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: url,
      placeholder: (context, url) => Center(
        child: CustomShimmer(
          width: imageSize?.width ?? 32,
          height: imageSize?.height ?? 32,
        ),
      ),
      maxHeightDiskCache: 1000,
      maxWidthDiskCache: 1000,
      imageBuilder: (context, image) {
        return Semantics(
          button: true,
          child: InkWell(
            onTap: () => CustomPhotoView(image: image).show(context),
            child: Image(image: image, fit: fit),
          ),
        );
      },
      errorWidget: (context, url, error) {
        return ImageError(error: error.toString());
      },
    );
  }
}
