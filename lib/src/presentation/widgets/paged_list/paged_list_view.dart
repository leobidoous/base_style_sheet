import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../../../core/themes/app_theme_factory.dart';
import '../../../core/themes/typography/typography_constants.dart';
import '../../controllers/paged_list_controller.dart';
import '../../extensions/build_context_extensions.dart';
import '../custom_loading.dart';
import '../custom_refresh_indicator.dart';
import '../custom_wrap.dart';
import '../empties/list_empty.dart';
import '../errors/custom_request_error.dart';

enum PagedListMode { normal, wrap }

class PagedListView<E, S> extends StatefulWidget {
  const PagedListView({
    super.key,
    this.nCols,
    this.physics,
    this.thickness,
    this.refreshLogo,
    this.scrollController,
    this.shrinkWrap = false,
    this.allowRefresh = true,
    required this.itemBuilder,
    this.parentScrollController,
    required this.listController,
    this.safeAreaLastItem = true,
    this.padding = EdgeInsets.zero,
    required this.separatorBuilder,
    this.mode = PagedListMode.normal,
    this.noItemsFoundIndicatorBuilder,
    this.newPageErrorIndicatorBuilder,
    this.firstPageErrorIndicatorBuilder,
    this.newPageProgressIndicatorBuilder,
    this.scrollDirection = Axis.vertical,
    this.firstPageProgressIndicatorBuilder,
  });

  final int? nCols;
  final bool shrinkWrap;
  final bool allowRefresh;
  final double? thickness;
  final PagedListMode mode;
  final EdgeInsets padding;
  final String? refreshLogo;
  final Axis scrollDirection;
  final bool safeAreaLastItem;
  final ScrollPhysics? physics;
  final ScrollController? scrollController;
  final ScrollController? parentScrollController;
  final PagedListController<E, S> listController;
  final Widget Function(BuildContext context, int index) separatorBuilder;
  final Widget Function(BuildContext context, S state, int index) itemBuilder;
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
  State<PagedListView<E, S>> createState() => _PagedListViewState<E, S>();
}

class _PagedListViewState<E, S> extends State<PagedListView<E, S>> {
  late final ScrollController _scrollController;
  late final PagedListController<E, S> _listController;

  @override
  void initState() {
    super.initState();
    _listController = widget.listController;
    _scrollController =
        widget.scrollController ??
        widget.parentScrollController ??
        ScrollController();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if (_listController.config.initWithRequest) _listController.refresh();
    });
    _scrollController.addListener(() {
      final max = _scrollController.position.maxScrollExtent;

      if (max == 0 ||
          _listController.searchPercent <=
              (_scrollController.offset / max * 100).ceil()) {
        if (_listController.isLoading || _listController.hasError) return;

        _fetchItemsAndScroll();
      }
    });
  }

  Future<void> _fetchItemsAndScroll() async {
    await _listController
        .fetchNewItems(
          pageKey:
              _listController.config.pageKey +
              _listController.config.pageIncrement,
        )
        .whenComplete(() {
          if (_listController.hasError) {
            WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
              _scrollController.animateTo(
                duration: const Duration(milliseconds: 250),
                _scrollController.position.maxScrollExtent,
                curve: Curves.decelerate,
              );
            });
          }
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
        if (_listController.isLoading && state.isEmpty) {
          return widget.firstPageProgressIndicatorBuilder?.call(context) ??
              Center(
                child: Padding(
                  padding: widget.padding,
                  child: const CustomLoading(),
                ),
              );
        } else if (_listController.hasError && state.isEmpty) {
          return widget.firstPageErrorIndicatorBuilder?.call(
                context,
                (_listController.error as E),
                _listController.refresh,
              ) ??
              Center(
                child: CustomRequestError(
                  padding: widget.padding,
                  btnLabel: 'Tentar novamente',
                  onPressed: _listController.refresh,
                  message: _listController.error.toString(),
                ),
              );
        } else if (state.isEmpty) {
          return widget.noItemsFoundIndicatorBuilder?.call(
                context,
                _listController.refresh,
              ) ??
              Center(
                child: ListEmpty(
                  padding: widget.padding,
                  btnLabel: 'Tentar novamente',
                  onPressed: _listController.refresh,
                  message: 'Nenhum item encontrado.',
                ),
              );
        }
        final child = RawScrollbar(
          padding: EdgeInsets.zero,
          thumbColor: context.colorScheme.primary,
          radius: context.theme.borderRadiusXLG.bottomLeft,
          thickness: switch (defaultTargetPlatform) {
            TargetPlatform.android => widget.thickness,
            TargetPlatform.iOS => widget.thickness,
            TargetPlatform() => 0,
          },
          controller: widget.parentScrollController == null
              ? _scrollController
              : null,
          child: _scrollChild(state),
        );

        /// Validate if it is allowed to use
        /// the onRefresh from the listController
        if (!widget.allowRefresh) return child;

        return CustomRefreshIndicator(
          refreshLogo: widget.refreshLogo,
          reverse: _listController.reverse,
          onRefresh: _listController.refresh,
          child: child,
        );
      },
    );
  }

  Widget _scrollChild(List<S> state) {
    switch (widget.mode) {
      case PagedListMode.normal:
        return ListView.separated(
          padding: widget.padding,
          itemCount: state.length,
          addAutomaticKeepAlives: false,
          reverse: _listController.reverse,
          separatorBuilder: widget.separatorBuilder,
          controller: widget.parentScrollController == null
              ? _scrollController
              : null,
          shrinkWrap: widget.shrinkWrap,
          scrollDirection: widget.scrollDirection,
          physics: widget.shrinkWrap
              ? (widget.physics ?? NeverScrollableScrollPhysics())
              : const BouncingScrollPhysics(
                  parent: AlwaysScrollableScrollPhysics(),
                ),
          itemBuilder: (_, index) => _listItem(state, index),
        );
      case PagedListMode.wrap:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            CustomWrap(
              nCols: widget.nCols,
              padding: widget.padding,
              alignment: WrapAlignment.center,
              items: state
                  .map((i) => _listItem(state, state.indexOf(i)))
                  .toList(),
            ),
          ],
        );
    }
  }

  Widget _listItem(List<S> items, int index) {
    return SafeArea(
      top: false,
      bottom:
          (_listController.reverse
              ? items.first == items[index]
              : items.last == items[index]) &&
          widget.safeAreaLastItem,
      child: switch (widget.scrollDirection) {
        Axis.horizontal => Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (_listController.reverse)
              if (items.last == items[index]) ..._errorOrLoading(index),
            widget.itemBuilder(context, items[index], index),
            if (!_listController.reverse)
              if (items.last == items[index]) ..._errorOrLoading(index),
          ],
        ),
        Axis.vertical => Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: switch (widget.mode) {
            PagedListMode.wrap => CrossAxisAlignment.center,
            PagedListMode.normal => CrossAxisAlignment.stretch,
          },
          children: [
            if (_listController.reverse)
              if (items.last == items[index]) ..._errorOrLoading(index),
            widget.itemBuilder(context, items[index], index),
            if (!_listController.reverse)
              if (items.last == items[index]) ..._errorOrLoading(index),
          ],
        ),
      },
    );
  }

  List<Widget> _errorOrLoading(int index) {
    final errorOrLoading = [
      if (_listController.hasError)
        widget.newPageErrorIndicatorBuilder?.call(
              context,
              _listController.error,
              _fetchItemsAndScroll,
            ) ??
            CustomRequestError(
              padding: EdgeInsets.zero,
              onPressed: _fetchItemsAndScroll,
              message: _listController.error.toString(),
            )
      else if (_listController.isLoading)
        widget.newPageProgressIndicatorBuilder?.call(context) ??
            Center(
              child: CustomLoading(
                width: AppFontSize.iconButton.value,
                height: AppFontSize.iconButton.value,
              ),
            ),
    ];
    if (_listController.reverse) {
      return [
        ...errorOrLoading,
        if (_listController.isLoading || _listController.hasError)
          widget.separatorBuilder(context, index),
      ];
    } else {
      return [
        if (_listController.isLoading || _listController.hasError)
          widget.separatorBuilder(context, index),
        ...errorOrLoading,
      ];
    }
  }
}
