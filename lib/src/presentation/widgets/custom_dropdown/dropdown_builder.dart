part of 'custom_dropdown.dart';

class _DropdownBuilder<T> extends StatefulWidget {
  const _DropdownBuilder({
    super.key,
    this.width,
    this.padding,
    this.itemStyle,
    this.value = '',
    this.listPadding,
    this.placeholder,
    this.boxDecoration,
    required this.items,
    required this.isOnTop,
    required this.fontSize,
    this.canSearch = false,
    this.itemSelectedStyle,
    required this.hintChild,
    required this.onChanged,
    required this.heightType,
    required this.scrollController,
  });
  final bool isOnTop;
  final String value;
  final double? width;
  final bool canSearch;
  final double fontSize;
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
  final Function(CustomDropdownItem<T>) onChanged;

  @override
  State<_DropdownBuilder<T>> createState() => _DropdownBuilderState<T>();
}

class _DropdownBuilderState<T> extends State<_DropdownBuilder<T>> {
  final _textController = TextEditingController();

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  List<CustomDropdownItem<T>> get _filteredItems => widget.items
      .where(
        (e) =>
            e.label.toLowerCase().contains(_textController.text.toLowerCase()),
      )
      .toList();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (widget.isOnTop) ...[
          widget.hintChild,
          const CustomDivider(height: 0),
          if (widget.canSearch) _searchField,
        ],
        Flexible(
          child: SizedBox(
            width: widget.width,
            child: _filteredItems.isEmpty
                ? ListEmpty(message: 'Nenhum item encontrado.')
                : _DropdownList(
                    value: widget.value,
                    items: _filteredItems,
                    fontSize: widget.fontSize,
                    onChanged: widget.onChanged,
                    padding: widget.listPadding,
                    itemStyle: widget.itemStyle,
                    heightType: widget.heightType,
                    scrollController: widget.scrollController,
                    itemSelectedStyle: widget.itemSelectedStyle,
                  ),
          ),
        ),
        if (!widget.isOnTop) ...[
          if (widget.canSearch) ...[
            const CustomDivider(height: 0),
            _searchField,
          ],
          const CustomDivider(height: 0),
          widget.hintChild,
        ],
      ],
    );
  }

  Widget get _searchField {
    return Padding(
      padding: widget.padding ?? EdgeInsets.all(Spacing.xs.value),
      child: CustomInputField(
        controller: _textController,
        hintText: widget.placeholder,
        onChanged: (input) {
          setState(() {});
        },
        suffixIcon: AnimatedScale(
          scale: _textController.text.isNotEmpty ? 1 : 0,
          duration: const Duration(milliseconds: 250),
          child: SizedBox(
            width: AppThemeBase.buttonHeightMD,
            child: Center(
              child: CustomButton.icon(
                onPressed: () => setState(() {
                  _textController.clear();
                }),
                type: ButtonType.noShape,
                icon: Icons.close_rounded,
                heightType: ButtonHeightType.small,
              ),
            ),
          ),
        ),
        heightType: InputHeightType.small,
        borderRadius:
            widget.boxDecoration?.borderRadius?.resolve(TextDirection.ltr) ??
                context.theme.borderRadiusSM,
      ),
    );
  }
}
