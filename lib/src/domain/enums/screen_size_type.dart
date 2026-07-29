enum ScreenSizeType { phone, tablet, desktop, largeDesktop, extraLargeDesktop }

extension ScreenSizeTypeExt on ScreenSizeType {
  double get width {
    switch (this) {
      case .phone:
        return 480;
      case .tablet:
        return 768;
      case .desktop:
        return 1024;
      case .largeDesktop:
        return 1440;
      case .extraLargeDesktop:
        return .infinity;
    }
  }
}

ScreenSizeType getScreenSizeType(double width) {
  if (width <= 480) {
    return .phone;
  } else if (width > 480 && width <= 768) {
    return .tablet;
  } else if (width > 768 && width <= 1024) {
    return .desktop;
  } else if (width > 1024 && width <= 1440) {
    return .largeDesktop;
  } else {
    return .extraLargeDesktop;
  }
}
