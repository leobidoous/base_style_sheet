part of 'custom_dropdown.dart';

class _DropdownBuilder<T> extends StatelessWidget {
  final bool isOnTop;
  final double? width;
  final Widget hintChild;
  final EdgeInsets? padding;
  final String? placeholder;
  final TextStyle? itemStyle;
  final EdgeInsets? listPadding;
  final BoxDecoration? boxDecoration;
  final TextStyle? itemSelectedStyle;
  final DropdownHeightType heightType;
  final ScrollController scrollController;
  final List<CustomDropdownItem<T>> items;
  final CustomDropdownItem<T>? itemSelected;
  final Function(CustomDropdownItem<T>) onChanged;

  const _DropdownBuilder({
    super.key,
    this.width,
    this.padding,
    this.itemStyle,
    this.listPadding,
    this.placeholder,
    this.itemSelected,
    this.boxDecoration,
    required this.items,
    required this.isOnTop,
    this.itemSelectedStyle,
    required this.hintChild,
    required this.onChanged,
    required this.heightType,
    required this.scrollController,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (isOnTop) ...[
          hintChild,
          const CustomDivider(height: 0),
        ],

        /// TODO: add search field into dropdown
        if (1 == 2)
          Padding(
            padding: padding ?? EdgeInsets.all(Spacing.xs.value),
            child: CustomInputField(
              hintText: placeholder,
              heightType: InputHeightType.small,
              borderRadius:
                  boxDecoration?.borderRadius?.resolve(TextDirection.ltr) ??
                      context.theme.borderRadiusSM,
            ),
          ),
        const CustomDivider(height: 0),
        Flexible(
          child: SizedBox(
            width: width,
            child: _DropdownList(
              items: items,
              onChanged: onChanged,
              padding: listPadding,
              itemStyle: itemStyle,
              heightType: heightType,
              itemSelected: itemSelected,
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
