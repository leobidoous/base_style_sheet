part of 'custom_dropdown.dart';

class _DropdownList<T> extends StatelessWidget {
  const _DropdownList({
    required this.value,
    required this.items,
    required this.padding,
    required this.fontSize,
    required this.onChanged,
    required this.itemStyle,
    required this.heightType,
    required this.scrollController,
    required this.itemSelectedStyle,
  });
  final String value;
  final double fontSize;
  final EdgeInsets? padding;
  final TextStyle? itemStyle;
  final TextStyle? itemSelectedStyle;
  final DropdownHeightType heightType;
  final ScrollController scrollController;
  final List<CustomDropdownItem<T>> items;
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
              radius: Spacing.md.value,
              hoverColor: Colors.transparent,
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
              onTap: () => onChanged(items[index]),
              child: Container(
                alignment: Alignment.centerLeft,
                constraints: BoxConstraints(
                  minHeight: switch (heightType) {
                    DropdownHeightType.normal => AppThemeBase.buttonHeightMD,
                    DropdownHeightType.small => AppThemeBase.buttonHeightSM,
                  },
                ),
                child: Padding(
                  padding:
                      padding ?? EdgeInsets.symmetric(horizontal: fontSize),
                  child: items[index].item ??
                      CustomScrollContent(
                        scrollDirection: Axis.horizontal,
                        child: Text(
                          items[index].label,
                          style: items[index].label == value
                              ? itemSelectedStyle ??
                                  context.textTheme.bodyMedium?.copyWith(
                                    fontSize: fontSize,
                                    color: context.colorScheme.primary,
                                    fontWeight: AppFontWeight.bold.value,
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
