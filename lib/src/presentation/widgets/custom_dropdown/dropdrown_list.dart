part of 'custom_dropdown.dart';

class _DropdownList<T> extends StatelessWidget {
  const _DropdownList({
    required this.items,
    required this.padding,
    required this.fontSize,
    required this.onChanged,
    required this.itemStyle,
    required this.heightType,
    required this.valueSelected,
    required this.listController,
    required this.scrollController,
    required this.itemSelectedStyle,
  });

  final double fontSize;
  final EdgeInsets? padding;
  final String valueSelected;
  final TextStyle? itemStyle;
  final TextStyle? itemSelectedStyle;
  final DropdownHeightType heightType;
  final ScrollController scrollController;
  final List<CustomDropdownItem<T>> items;
  final Function(CustomDropdownItem<T>) onChanged;
  final PagedListController<dynamic, CustomDropdownItem<T>> listController;

  @override
  Widget build(BuildContext context) {
    return PagedListView(
      shrinkWrap: true,
      safeAreaLastItem: false,
      listController: listController,
      scrollController: scrollController,
      physics: const BouncingScrollPhysics(
        parent: AlwaysScrollableScrollPhysics(),
      ),
      allowRefresh: !listController.config.preventNewFetch,
      separatorBuilder: (_, __) => const CustomDivider(height: 0),
      noItemsFoundIndicatorBuilder: (_, onRefresh) {
        return ListEmpty(
          message: 'Nenhum item encontrado',
          padding: padding ?? EdgeInsets.all(Spacing.sm.value),
        );
      },
      firstPageProgressIndicatorBuilder: (_) {
        return ListView.separated(
          itemCount: 5,
          shrinkWrap: true,
          padding: EdgeInsets.zero,
          separatorBuilder: (_, __) => const CustomDivider(height: 0),
          itemBuilder: (_, __) {
            return CustomCard(
              shaddow: [],
              color: Colors.transparent,
              border: context.theme.borderNone,
              borderRadius: context.theme.borderRadiusNone,
              constraints: BoxConstraints(
                minHeight: switch (heightType) {
                  DropdownHeightType.normal => AppThemeBase.buttonHeightMD,
                  DropdownHeightType.small => AppThemeBase.buttonHeightSM,
                },
              ),
              padding: padding ?? EdgeInsets.symmetric(horizontal: fontSize),
              child: Align(
                alignment: Alignment.centerLeft,
                child: CustomShimmer(height: fontSize),
              ),
            );
          },
        );
      },
      newPageErrorIndicatorBuilder: (_, error, onRefresh) {
        return Center(
          child: CustomRequestError(
            isSafeArea: false,
            onPressed: onRefresh,
            message: error?.toString(),
            btnLabel: 'Buscar novamente',
            padding: padding ?? EdgeInsets.all(Spacing.sm.value),
          ),
        );
      },
      firstPageErrorIndicatorBuilder: (_, error, onRefresh) {
        return Center(
          child: CustomRequestError(
            isSafeArea: false,
            onPressed: onRefresh,
            btnLabel: 'Buscar novamente',
            message: error?.toString(),
            padding: padding ?? EdgeInsets.all(Spacing.sm.value),
          ),
        );
      },
      itemBuilder: (context, item, index) {
        return CustomCard(
          shaddow: [],
          color: Colors.transparent,
          border: context.theme.borderNone,
          onTap: () => onChanged(item),
          borderRadius: context.theme.borderRadiusNone,
          constraints: BoxConstraints(
            minHeight: switch (heightType) {
              DropdownHeightType.normal => AppThemeBase.buttonHeightMD,
              DropdownHeightType.small => AppThemeBase.buttonHeightSM,
            },
          ),
          padding: padding ?? EdgeInsets.symmetric(horizontal: fontSize),
          child: Align(
            alignment: Alignment.centerLeft,
            child: item.item ??
                CustomScrollContent(
                  scrollDirection: Axis.horizontal,
                  child: Text(
                    item.label,
                    style: item.label == valueSelected
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
        );
      },
    );
  }
}
