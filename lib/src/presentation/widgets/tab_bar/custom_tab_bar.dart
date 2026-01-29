import 'package:flutter/material.dart';

import '../../../core/themes/spacing/spacing.dart';
import '../custom_scroll_content.dart';
import 'tab_bar_item.dart';

class CustomTabBar extends StatefulWidget {
  const CustomTabBar({
    super.key,
    required this.tabs,
    required this.tabSelected,
    this.onChange,
    this.padding,
  });

  final List<String> tabs;
  final EdgeInsets? padding;
  final int tabSelected;
  final Function(int)? onChange;

  @override
  State<CustomTabBar> createState() => _CustomTabBarState();
}

class _CustomTabBarState extends State<CustomTabBar> {
  late int tabSelected;

  @override
  Widget build(BuildContext context) {
    tabSelected = widget.tabSelected;
    return CustomScrollContent(
      scrollDirection: Axis.horizontal,
      alwaysScrollable: true,
      padding: widget.padding ?? .zero,
      child: Row(
        children: widget.tabs.map((tab) {
          return Semantics(
            button: true,
            child: InkWell(
              onTap: () {
                setState(() => tabSelected = widget.tabs.indexOf(tab));
                widget.onChange?.call(widget.tabs.indexOf(tab));
              },
              child: Padding(
                padding: .only(
                  right: tab != widget.tabs.last ? const Spacing(2).value : 0,
                ),
                child: TabBarItem(
                  title: tab,
                  selected: tabSelected == widget.tabs.indexOf(tab),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
