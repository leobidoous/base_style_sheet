part of 'custom_dropdown.dart';

class _DropdownList<T> extends StatelessWidget {
  const _DropdownList({
    required this.items,
    required this.padding,
    required this.onChanged,
    required this.itemStyle,
    required this.heightType,
    required this.itemSelected,
    required this.scrollController,
    required this.itemSelectedStyle,
  });
  final EdgeInsets? padding;
  final TextStyle? itemStyle;
  final TextStyle? itemSelectedStyle;
  final DropdownHeightType heightType;
  final ScrollController scrollController;
  final List<CustomDropdownItem<T>> items;
  final CustomDropdownItem<T>? itemSelected;
  final Function(CustomDropdownItem<T>) onChanged;

  @override
  Widget build(BuildContext context) {
    return RawScrollbar(
      padding: EdgeInsets.zero,
      thickness: kIsWeb ? 0 : null,
      controller: scrollController,
      thumbColor: context.colorScheme.primary,
      radius: context.theme.borderRadiusXSM.bottomLeft,
      child: ListView.separated(
        shrinkWrap: true,
        itemCount: items.length,
        padding: EdgeInsets.zero,
        controller: scrollController,
        physics: const BouncingScrollPhysics(
          parent: AlwaysScrollableScrollPhysics(),
        ),
        separatorBuilder: (_, __) => const CustomDivider(height: 0),
        itemBuilder: (context, index) {
          return Semantics(
            button: true,
            child: InkWell(
              onTap: () => onChanged(items[index]),
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
              hoverColor: Colors.transparent,
              radius: Spacing.md.value,
              child: Container(
                alignment: Alignment.centerLeft,
                constraints: BoxConstraints(
                  minHeight: switch (heightType) {
                    DropdownHeightType.normal => AppThemeBase.buttonHeightMD,
                    DropdownHeightType.small => AppThemeBase.buttonHeightSM,
                  },
                ),
                child: items[index].item ??
                    Padding(
                      padding: padding ??
                          EdgeInsets.symmetric(horizontal: Spacing.xs.value),
                      child: CustomScrollContent(
                        scrollDirection: Axis.horizontal,
                        child: Text(
                          items[index].label,
                          style: items[index].value == itemSelected?.value
                              ? itemSelectedStyle ??
                                  context.textTheme.bodyMedium?.copyWith(
                                    fontWeight: AppFontWeight.bold.value,
                                    color: context.colorScheme.primary,
                                  )
                              : itemStyle ?? context.textTheme.bodyMedium,
                        ),
                      ),
                    ),
              ),
            ),
          );
        },
      ),
    );
  }
}
