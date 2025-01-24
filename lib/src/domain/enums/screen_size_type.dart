enum ScreenSizeType { phone, tablet, desktop, largeDesktop, extraLargeDesktop }

extension ScreenSizeTypeExt on ScreenSizeType {
  double get width {
    switch (this) {
      case ScreenSizeType.phone:
        return 480;
      case ScreenSizeType.tablet:
        return 768;
      case ScreenSizeType.desktop:
        return 1024;
      case ScreenSizeType.largeDesktop:
        return 1440;
      case ScreenSizeType.extraLargeDesktop:
        return double.infinity;
    }
  }
}

ScreenSizeType getScreenSizeType(double width) {
  if (width <= 480) {
    return ScreenSizeType.phone;
  } else if (width > 480 && width <= 768) {
    return ScreenSizeType.tablet;
  } else if (width > 768 && width <= 1024) {
    return ScreenSizeType.desktop;
  } else if (width > 1024 && width <= 1440) {
    return ScreenSizeType.largeDesktop;
  } else {
    return ScreenSizeType.extraLargeDesktop;
  }
}
