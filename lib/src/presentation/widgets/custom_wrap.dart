import 'package:flutter/material.dart'
    show
        BuildContext,
        EdgeInsets,
        LayoutBuilder,
        Padding,
        SizedBox,
        StatelessWidget,
        Widget,
        Wrap,
        WrapAlignment;

class CustomWrap<T> extends StatelessWidget {
  const CustomWrap({
    super.key,
    this.nCols,
    this.spacing = 8,
    this.runSpacing = 8,
    required this.items,
    this.padding = EdgeInsets.zero,
    this.wrapAlignment = WrapAlignment.start,
  });
  final int? nCols;
  final double spacing;
  final double runSpacing;
  final List<Widget> items;
  final EdgeInsets padding;
  final WrapAlignment wrapAlignment;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: LayoutBuilder(
        builder: (context, constrains) {
          return Wrap(
            spacing: spacing,
            runSpacing: runSpacing,
            alignment: wrapAlignment,
            children: items.map((item) {
              return SizedBox(
                width: nCols != null
                    ? (constrains.maxWidth / nCols!) -
                        ((spacing * (nCols! - 1)) / nCols!).ceil()
                    : null,
                child: item,
              );
            }).toList(),
          );
        },
      ),
    );
  }
}
