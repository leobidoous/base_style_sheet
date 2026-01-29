part of 'custom_dropdown.dart';

class _DropdownBuilder<T> extends StatelessWidget {
  const _DropdownBuilder({
    super.key,
    this.width,
    this.padding,
    this.itemStyle,
    this.listPadding,
    this.placeholder,
    this.boxDecoration,
    required this.items,
    required this.isOnTop,
    required this.fontSize,
    this.itemSelectedStyle,
    required this.hintChild,
    required this.onChanged,
    required this.heightType,
    required this.valueSelected,
    required this.listController,
    required this.scrollController,
  });
  final bool isOnTop;
  final double? width;
  final double fontSize;
  final Widget hintChild;
  final EdgeInsets? padding;
  final String? placeholder;
  final String valueSelected;
  final TextStyle? itemStyle;
  final EdgeInsets? listPadding;
  final BoxDecoration? boxDecoration;
  final TextStyle? itemSelectedStyle;
  final DropdownHeightType heightType;
  final ScrollController scrollController;
  final List<CustomDropdownItem<T>> items;
  final Function(CustomDropdownItem<T>) onChanged;
  final PagedListController<dynamic, CustomDropdownItem<T>> listController;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: .min,
      crossAxisAlignment: .stretch,
      children: [
        if (isOnTop) ...[hintChild, const CustomDivider(height: 0)],
        Flexible(
          child: SizedBox(
            width: width,
            child: _DropdownList(
              items: items,
              fontSize: fontSize,
              onChanged: onChanged,
              padding: listPadding,
              itemStyle: itemStyle,
              heightType: heightType,
              valueSelected: valueSelected,
              listController: listController,
              scrollController: scrollController,
              itemSelectedStyle: itemSelectedStyle,
            ),
          ),
        ),
        if (!isOnTop) ...[const CustomDivider(height: 0), hintChild],
      ],
    );
  }
}
