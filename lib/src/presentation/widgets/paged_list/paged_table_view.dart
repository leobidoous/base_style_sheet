import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../../core/themes/app_theme_factory.dart';
import '../../../core/themes/spacing/spacing.dart';
import '../../../core/themes/typography/typography_constants.dart';
import '../../controllers/paged_list_controller.dart';
import '../../extensions/build_context_extensions.dart';
import '../buttons/custom_button.dart';
import '../containers/custom_shimmer.dart';
import '../custom_refresh_indicator.dart';
import '../custom_scroll_content.dart';
import '../dropdown/custom_dropdown.dart';
import '../empties/list_empty.dart';
import '../errors/custom_request_error.dart';

/// Configuração de uma coluna da tabela
class TableColumnConfig<S> {
  const TableColumnConfig({
    this.flex,
    this.width,
    this.onTap,
    this.boxDecoration,
    required this.header,
    required this.cellBuilder,
    this.alignment = .centerLeft,
  }) : assert(
         width == null || flex == null,
         'Não é possível definir width e flex simultaneamente',
       );

  final int? flex;
  final String header;
  final double? width;
  final Alignment alignment;
  final Function(S item)? onTap;
  final BoxDecoration? boxDecoration;
  final Widget Function(BuildContext context, S item, int index) cellBuilder;
}

class PagedTableView<E, S> extends StatefulWidget {
  const PagedTableView({
    super.key,
    this.physics,
    this.thickness,
    this.refreshLogo,
    this.boxDecoration,
    this.padding = .zero,
    required this.columns,
    required this.context,
    this.scrollController,
    this.shrinkWrap = false,
    this.allowRefresh = true,
    this.parentScrollController,
    required this.tableController,
    this.allowHorizontalScroll = true,
    this.noItemsFoundIndicatorBuilder,
    this.newPageErrorIndicatorBuilder,
    this.firstPageErrorIndicatorBuilder,
    this.newPageProgressIndicatorBuilder,
    this.firstPageProgressIndicatorBuilder,
    this.clipBehavior = .antiAliasWithSaveLayer,
  });

  final bool shrinkWrap;
  final bool allowRefresh;
  final double? thickness;
  final Clip clipBehavior;
  final EdgeInsets padding;
  final String? refreshLogo;
  final BuildContext context;
  final ScrollPhysics? physics;
  final bool allowHorizontalScroll;
  final BoxDecoration? boxDecoration;
  final List<TableColumnConfig<S>> columns;
  final ScrollController? scrollController;
  final ScrollController? parentScrollController;
  final PagedListController<E, S> tableController;
  final Widget Function(BuildContext context, Function() onRefresh)?
  noItemsFoundIndicatorBuilder;
  final Widget Function(BuildContext context, E? error, Function() onRefresh)?
  newPageErrorIndicatorBuilder;
  final Widget Function(BuildContext context, E? error, Function() onRefresh)?
  firstPageErrorIndicatorBuilder;
  final Widget Function(BuildContext context)? newPageProgressIndicatorBuilder;
  final Widget Function(BuildContext context)?
  firstPageProgressIndicatorBuilder;

  @override
  State<PagedTableView<E, S>> createState() => _PagedTableViewState<E, S>();
}

class _PagedTableViewState<E, S> extends State<PagedTableView<E, S>> {
  late final PagedListController<E, S> _listController;
  late final ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController =
        widget.scrollController ??
        widget.parentScrollController ??
        ScrollController();
    _listController = widget.tableController;
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if (_listController.config.initWithRequest) _listController.refresh();
    });
  }

  @override
  void dispose() {
    if (widget.scrollController == null &&
        widget.parentScrollController == null) {
      _scrollController.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<List<S>>(
      valueListenable: _listController,
      builder: (context, state, child) {
        final child = RawScrollbar(
          padding: .zero,
          controller: _scrollController,
          thumbColor: context.colorScheme.primary,
          radius: context.theme.borderRadiusXLG.bottomLeft,
          thickness: switch (defaultTargetPlatform) {
            TargetPlatform.android => widget.thickness,
            TargetPlatform.iOS => widget.thickness,
            TargetPlatform() => 0,
          },
          child: _table(state),
        );

        /// Validate if it is allowed to use
        /// the onRefresh from the listController
        if (!widget.allowRefresh) return child;

        return CustomRefreshIndicator(
          refreshLogo: widget.refreshLogo,
          reverse: _listController.reverse,
          onRefresh: () async {
            _listController.update([]);
            _scrollController.animateTo(
              0,
              duration: Durations.short1,
              curve: Curves.decelerate,
            );
            _listController.fetchNewItems(
              pageKey: _listController.config.pageKey,
              forceFetch: true,
            );
          },
          child: child,
        );
      },
    );
  }

  Widget _table(List<S> state) {
    return CustomScrollContent(
      expanded: true,
      alwaysScrollable: true,
      padding: widget.padding,
      scrollController: _scrollController,
      child: Column(
        crossAxisAlignment: .stretch,
        children: [
          if (_listController.isLoading)
            widget.firstPageProgressIndicatorBuilder?.call(context) ??
                DataTable(
                  clipBehavior: widget.clipBehavior,
                  decoration: widget.boxDecoration,
                  columns: widget.columns.map((c) {
                    return DataColumn(
                      label: CustomScrollContent(
                        scrollDirection: .horizontal,
                        child: Text(
                          c.header,
                          overflow: .ellipsis,
                          style: context.textTheme.labelLarge?.copyWith(
                            fontWeight: AppFontWeight.semiBold.value,
                            color: context.colorScheme.onSurface,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                  rows: List.generate(_listController.config.pageSize, (i) {
                    return DataRow(
                      cells: widget.columns.map((c) {
                        return DataCell(
                          CustomShimmer(height: AppFontSize.bodyMedium.value),
                        );
                      }).toList(),
                    );
                  }),
                )
          else if (_listController.hasError)
            Column(
              crossAxisAlignment: .stretch,
              children: [
                widget.firstPageErrorIndicatorBuilder?.call(
                      context,
                      (_listController.error as E),
                      _listController.refresh,
                    ) ??
                    _dataTablePlaceholder,
                DecoratedBox(
                  decoration: widget.boxDecoration ?? BoxDecoration(),
                  child: Center(
                    child: CustomRequestError(
                      padding: widget.padding,
                      btnLabel: 'Tentar novamente',
                      message: _listController.error.toString(),
                      onPressed: () {
                        _listController.update([]);
                        _listController.fetchNewItems(
                          pageKey: _listController.config.pageKey,
                          forceFetch: true,
                        );
                      },
                    ),
                  ),
                ),
              ],
            )
          else if (state.isEmpty)
            Column(
              crossAxisAlignment: .stretch,
              children: [
                widget.noItemsFoundIndicatorBuilder?.call(
                      context,
                      _listController.refresh,
                    ) ??
                    _dataTablePlaceholder,
                DecoratedBox(
                  decoration: widget.boxDecoration ?? BoxDecoration(),
                  child: Center(
                    child: ListEmpty(
                      padding: widget.padding,
                      btnLabel: 'Tentar novamente',
                      header: Icon(
                        Icons.screen_search_desktop_outlined,
                        size: AppFontSize.iconButton.value * 3,
                        color: context.colorScheme.primary,
                      ),
                      message: 'Nenhum item encontrado.',
                      onPressed: () {
                        _listController.update([]);
                        _listController.fetchNewItems(
                          pageKey: _listController.config.pageKey,
                          forceFetch: true,
                        );
                      },
                    ),
                  ),
                ),
              ],
            )
          else
            LayoutBuilder(
              builder: (context, constraints) {
                return CustomScrollContent(
                  scrollDirection: .horizontal,
                  child: ConstrainedBox(
                    constraints: BoxConstraints(minWidth: constraints.maxWidth),
                    child: _dataTable,
                  ),
                );
              },
            ),
          widget.padding.bottom > 0
              ? SizedBox(height: widget.padding.bottom)
              : Spacing.sm.vertical,
          _footer,
        ],
      ),
    );
  }

  Widget get _dataTablePlaceholder {
    return DataTable(
      clipBehavior: widget.clipBehavior,
      decoration: widget.boxDecoration,
      columns: widget.columns.map((c) {
        return DataColumn(
          tooltip: c.header,
          headingRowAlignment: .start,
          label: CustomScrollContent(
            scrollDirection: .horizontal,
            child: Text(
              c.header,
              overflow: .ellipsis,
              style: context.textTheme.labelLarge?.copyWith(
                fontWeight: AppFontWeight.semiBold.value,
                color: context.colorScheme.onSurface,
              ),
            ),
          ),
        );
      }).toList(),
      rows: [],
    );
  }

  Widget get _dataTable {
    final state = _listController.state;
    return DataTable(
      clipBehavior: widget.clipBehavior,
      decoration: widget.boxDecoration,
      columns: widget.columns.asMap().entries.map((entry) {
        final c = entry.value;
        final columnWidth = c.width != null
            ? FixedColumnWidth(c.width!)
            : c.flex != null
            ? IntrinsicColumnWidth(flex: c.flex!.toDouble())
            : IntrinsicColumnWidth();
        return DataColumn(
          onSort: (columnIndex, ascending) {},
          columnWidth: MinColumnWidth(
            columnWidth,
            IntrinsicColumnWidth(flex: c.flex?.toDouble()),
          ),
          label: CustomScrollContent(
            scrollDirection: .horizontal,
            child: Text(
              c.header,
              style: context.textTheme.labelLarge?.copyWith(
                fontWeight: AppFontWeight.semiBold.value,
                color: context.colorScheme.onSurface,
              ),
            ),
          ),
        );
      }).toList(),
      rows: state.map((r) {
        return DataRow(
          selected: true,
          color: WidgetStatePropertyAll(context.colorScheme.surface),
          cells: widget.columns.map((c) {
            return DataCell(
              onTap: () => c.onTap?.call(r),
              c.cellBuilder(context, r, state.indexOf(r)),
            );
          }).toList(),
        );
      }).toList(),
    );
  }

  Widget get _footer {
    return Row(
      children: [
        CustomDropdown<int>(
          canSearch: false,
          isExpanded: false,
          useSafeArea: false,
          heightType: .normal,
          context: widget.context,
          useParendRenderBox: true,
          isEnabled: !_listController.isLoading,
          value: _listController.config.pageSize.toString(),
          items: [10, 20, 50].map((e) {
            return CustomDropdownItem(value: e, label: e.toString());
          }).toList(),
          onChanged: (value) {
            _listController.update([]);
            _listController.fetchNewItems(
              pageKey: _listController.config.pageKey,
              forceFetch: true,
              pageSize: value,
            );
          },
        ),
        Spacing.sm.horizontal,
        Expanded(
          child: Row(
            mainAxisAlignment: .end,
            children: [
              CustomButton.iconText(
                text: 'Anterior',
                isEnabled:
                    !_listController.isLoading &&
                    !_listController.hasError &&
                    _listController.config.pageKey >
                        _listController.firstPageKey,
                icon: Icons.chevron_left_rounded,
                heightType: .normal,
                onPressed: () {
                  _listController.update([]);
                  _listController.fetchNewItems(
                    forceFetch: true,
                    pageKey:
                        _listController.config.pageKey -
                        _listController.config.pageIncrement,
                  );
                },
              ),
              Spacing.sm.horizontal,
              Text((_listController.config.pageKey).toString()),
              Spacing.sm.horizontal,
              CustomButton.textIcon(
                text: 'Próximo',
                isEnabled:
                    !_listController.isLoading &&
                    !_listController.hasError &&
                    _listController.state.isNotEmpty &&
                    !_listController.config.isLastFetch,
                icon: Icons.chevron_right_rounded,
                heightType: .normal,
                onPressed: () {
                  _listController.update([]);
                  _listController.fetchNewItems(
                    forceFetch: true,
                    pageKey:
                        _listController.config.pageKey +
                        _listController.config.pageIncrement,
                  );
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}
