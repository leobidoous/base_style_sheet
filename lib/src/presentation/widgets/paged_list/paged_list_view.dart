import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../../../core/themes/app_theme_factory.dart';
import '../../../core/themes/spacing/spacing.dart';
import '../../extensions/build_context_extensions.dart';
import '../custom_loading.dart';
import '../custom_refresh_indicator.dart';
import '../empties/list_empty.dart';
import '../errors/custom_request_error.dart';
import 'paged_list_controller.dart';

class PagedListView<E, S> extends StatefulWidget {
  const PagedListView({
    super.key,
    this.thickness,
    this.refreshLogo,
    this.scrollController,
    this.shrinkWrap = false,
    required this.itemBuilder,
    this.initWithRequest = true,
    this.parentScrollController,
    required this.listController,
    this.safeAreaLastItem = true,
    this.padding = EdgeInsets.zero,
    required this.separatorBuilder,
    this.noItemsFoundIndicatorBuilder,
    this.newPageErrorIndicatorBuilder,
    this.firstPageErrorIndicatorBuilder,
    this.newPageProgressIndicatorBuilder,
    this.firstPageProgressIndicatorBuilder,
  });

  final bool shrinkWrap;
  final double? thickness;
  final EdgeInsets padding;
  final String? refreshLogo;
  final bool initWithRequest;
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
  State<PagedListView<E, S>> createState() => _PagedListViewState<E, S>();
}

class _PagedListViewState<E, S> extends State<PagedListView<E, S>> {
  late final ScrollController scrollController;
  late final PagedListController<E, S> controller;

  @override
  void initState() {
    super.initState();
    controller = widget.listController;
    scrollController = widget.scrollController ??
        widget.parentScrollController ??
        ScrollController();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if (widget.initWithRequest) controller.refresh();
    });
    scrollController.addListener(() {
      final max = scrollController.position.maxScrollExtent;

      if (max == 0 ||
          controller.searchPercent <=
              (scrollController.offset / max * 100).ceil()) {
        if (controller.isLoading || controller.hasError) return;

        _fetchItemsAndScroll();
      }
    });
  }

  Future<void> _fetchItemsAndScroll() async {
    await controller
        .fetchNewItems(pageKey: controller.config.pageKey)
        .whenComplete(() {
      if (controller.hasError) {
        WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
          scrollController.animateTo(
            duration: const Duration(milliseconds: 250),
            scrollController.position.maxScrollExtent,
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
      scrollController.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<List<S>>(
      valueListenable: controller,
      builder: (context, state, child) {
        if (controller.isLoading && state.isEmpty) {
          return widget.firstPageProgressIndicatorBuilder?.call(context) ??
              Center(
                child: Padding(
                  padding: widget.padding,
                  child: const CustomLoading(),
                ),
              );
        } else if (controller.hasError && state.isEmpty) {
          return Center(
            child: widget.firstPageErrorIndicatorBuilder?.call(
                  context,
                  (controller.error as E),
                  controller.refresh,
                ) ??
                CustomRequestError(
                  padding: widget.padding,
                  message: controller.error.toString(),
                  onPressed: controller.refresh,
                ),
          );
        } else if (state.isEmpty) {
          return Center(
            child: widget.noItemsFoundIndicatorBuilder?.call(
                  context,
                  controller.refresh,
                ) ??
                ListEmpty(
                  padding: widget.padding,
                  onPressed: controller.refresh,
                  message: 'Nenhum item encontrado.',
                ),
          );
        }
        return CustomRefreshIndicator(
          onRefresh: controller.refresh,
          refreshLogo: widget.refreshLogo,
          child: RawScrollbar(
            padding: EdgeInsets.zero,
            controller:
                widget.parentScrollController == null ? scrollController : null,
            thumbColor: context.colorScheme.primary,
            thickness: widget.thickness,
            radius: context.theme.borderRadiusXLG.bottomLeft,
            child: ListView.builder(
              padding: widget.padding,
              itemCount: state.length,
              reverse: controller.reverse,
              addAutomaticKeepAlives: false,
              controller: widget.parentScrollController == null
                  ? scrollController
                  : null,
              shrinkWrap: widget.shrinkWrap,
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
    return RepaintBoundary(
      child: SafeArea(
        top: false,
        bottom: (controller.reverse
                ? items.first == items[index]
                : items.last == items[index]) &&
            widget.safeAreaLastItem,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (controller.reverse)
              if (items.last == items[index]) ..._errorAndLoading(index),
            widget.itemBuilder(context, items[index], index),
            if ((controller.reverse
                ? items.first != items[index]
                : items.last != items[index]))
              widget.separatorBuilder(context, index),
            if (!controller.reverse)
              if (items.last == items[index]) ..._errorAndLoading(index),
          ],
        ),
      ),
    );
  }

  List<Widget> _errorAndLoading(int index) {
    return [
      if (controller.hasError || controller.isLoading)
        widget.separatorBuilder(context, index),
      if (controller.hasError && !controller.isLoading)
        widget.newPageErrorIndicatorBuilder?.call(
              context,
              controller.error,
              _fetchItemsAndScroll,
            ) ??
            CustomRequestError(
              padding: EdgeInsets.zero,
              message: controller.error.toString(),
              onPressed: _fetchItemsAndScroll,
            ),
      if (controller.isLoading)
        widget.newPageProgressIndicatorBuilder?.call(context) ??
            Center(
              child: CustomLoading(
                width: const Spacing(3).value,
                height: const Spacing(3).value,
              ),
            ),
    ];
  }
}
