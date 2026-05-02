part of 'custom_dropdown.dart';

class _DropdownBuilder<T> extends StatefulWidget {
  const _DropdownBuilder({
    super.key,
    required this.items,
    required this.isOnTop,
    required this.fontSize,
    required this.hintChild,
    required this.onChanged,
    required this.heightType,
    required this.valueSelected,
    required this.listController,
    required this.scrollController,
    this.width,
    this.padding,
    this.itemStyle,
    this.listPadding,
    this.placeholder,
    this.boxDecoration,
    this.itemSelectedStyle,
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
  State<_DropdownBuilder<T>> createState() => _DropdownBuilderState<T>();
}

class _DropdownBuilderState<T> extends State<_DropdownBuilder<T>> {
  late final GlobalKey _dropdownListKey;

  @override
  void initState() {
    super.initState();
    _dropdownListKey = GlobalKey(debugLabel: widget.valueSelected);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: .min,
      crossAxisAlignment: .stretch,
      children: [
        if (widget.isOnTop) ...[
          widget.hintChild,
          const CustomDivider(height: 0),
        ],
        Flexible(
          child: SizedBox(
            width: widget.width,
            child: _DropdownList(
              items: widget.items,
              key: _dropdownListKey,
              fontSize: widget.fontSize,
              onChanged: widget.onChanged,
              padding: widget.listPadding,
              itemStyle: widget.itemStyle,
              heightType: widget.heightType,
              valueSelected: widget.valueSelected,
              listController: widget.listController,
              scrollController: widget.scrollController,
              itemSelectedStyle: widget.itemSelectedStyle,
            ),
          ),
        ),
        if (!widget.isOnTop) ...[
          const CustomDivider(height: 0),
          widget.hintChild,
        ],
      ],
    );
  }
}
