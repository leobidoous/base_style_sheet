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
import '../empties/list_empty.dart';
import '../errors/custom_request_error.dart';

class PagedWrapView<E, S> extends StatefulWidget {
  const PagedWrapView({
    super.key,
    this.thickness,
    this.refreshLogo,
    this.scrollController,
    this.shrinkWrap = false,
    required this.itemBuilder,
    this.parentScrollController,
    required this.listController,
    this.safeAreaLastItem = true,
    this.padding = EdgeInsets.zero,
    required this.separatorBuilder,
    this.noItemsFoundIndicatorBuilder,
    this.newPageErrorIndicatorBuilder,
    this.firstPageErrorIndicatorBuilder,
    this.newPageProgressIndicatorBuilder,
    this.scrollDirection = Axis.vertical,
    this.firstPageProgressIndicatorBuilder,
  });

  final bool shrinkWrap;
  final double? thickness;
  final EdgeInsets padding;
  final String? refreshLogo;
  final Axis scrollDirection;
  final bool safeAreaLastItem;
  final ScrollController? scrollController;
  final ScrollController? parentScrollController;
  final PagedListController<E, S> listController;
  final Widget Function(BuildContext, int) separatorBuilder;
  final Widget Function(BuildContext, S, int) itemBuilder;
  final Widget Function(BuildContext, Function())? noItemsFoundIndicatorBuilder;
  final Widget Function(
    BuildContext,
    E?,
    Function(),
  )? newPageErrorIndicatorBuilder;
  final Widget Function(
    BuildContext,
    E?,
    Function(),
  )? firstPageErrorIndicatorBuilder;
  final Widget Function(BuildContext)? newPageProgressIndicatorBuilder;
  final Widget Function(BuildContext)? firstPageProgressIndicatorBuilder;

  @override
  State<PagedWrapView<E, S>> createState() => _PagedListViewState<E, S>();
}

class _PagedListViewState<E, S> extends State<PagedWrapView<E, S>> {
  late final ScrollController _scrollController;
  late final PagedListController<E, S> _listController;

  @override
  void initState() {
    super.initState();
    _listController = widget.listController;
    _scrollController = widget.scrollController ??
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
        .fetchNewItems(pageKey: _listController.config.pageKey)
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
                  message: _listController.error.toString(),
                  onPressed: _listController.refresh,
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
        return CustomRefreshIndicator(
          onRefresh: _listController.refresh,
          refreshLogo: widget.refreshLogo,
          child: RawScrollbar(
            padding: EdgeInsets.zero,
            thumbColor: context.colorScheme.primary,
            radius: context.theme.borderRadiusXLG.bottomLeft,
            thickness: widget.thickness ?? (kIsWeb ? 0 : null),
            controller: widget.parentScrollController == null
                ? _scrollController
                : null,
            child: ListView.separated(
              padding: widget.padding,
              itemCount: state.length,
              reverse: _listController.reverse,
              addAutomaticKeepAlives: false,
              separatorBuilder: widget.separatorBuilder,
              controller: widget.parentScrollController == null
                  ? _scrollController
                  : null,
              shrinkWrap: widget.shrinkWrap,
              scrollDirection: widget.scrollDirection,
              physics: widget.shrinkWrap
                  ? const NeverScrollableScrollPhysics()
                  : const BouncingScrollPhysics(
                      parent: AlwaysScrollableScrollPhysics(),
                    ),
              itemBuilder: (_, index) => _listItem(state, index),
            ),
          ),
        );
      },
    );
  }

  Widget _listItem(List<S> items, int index) {
    return SafeArea(
      top: false,
      bottom: (_listController.reverse
              ? items.first == items[index]
              : items.last == items[index]) &&
          widget.safeAreaLastItem,
      child: switch (widget.scrollDirection) {
        Axis.horizontal => Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (_listController.reverse)
                if (items.last == items[index]) ..._errorAndLoading(index),
              widget.itemBuilder(context, items[index], index),
              if (!_listController.reverse)
                if (items.last == items[index]) ..._errorAndLoading(index),
            ],
          ),
        Axis.vertical => Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (_listController.reverse)
                if (items.last == items[index]) ..._errorAndLoading(index),
              widget.itemBuilder(context, items[index], index),
              if (!_listController.reverse)
                if (items.last == items[index]) ..._errorAndLoading(index),
            ],
          ),
      },
    );
  }

  List<Widget> _errorAndLoading(int index) {
    return [
      if (_listController.hasError || _listController.isLoading)
        widget.separatorBuilder(context, index),
      if (_listController.hasError && !_listController.isLoading)
        widget.newPageErrorIndicatorBuilder?.call(
              context,
              _listController.error,
              _fetchItemsAndScroll,
            ) ??
            CustomRequestError(
              padding: EdgeInsets.zero,
              onPressed: _fetchItemsAndScroll,
              message: _listController.error.toString(),
            ),
      if (_listController.isLoading)
        widget.newPageProgressIndicatorBuilder?.call(context) ??
            Center(
              child: CustomLoading(
                width: AppFontSize.iconButton.value,
                height: AppFontSize.iconButton.value,
              ),
            ),
    ];
  }
}
