import 'package:flutter/cupertino.dart';

class CustomWrap<T> extends StatelessWidget {
  const CustomWrap({
    super.key,
    this.nCols,
    this.spacing = 8,
    this.runSpacing = 8,
    required this.items,
    this.padding = .zero,
    this.alignment = .start,
    this.runAlignment = .start,
    this.useIntrinsicHeight = false,
    this.crossAxisAlignment = .center,
  });
  final int? nCols;
  final double spacing;
  final double runSpacing;
  final List<Widget> items;
  final EdgeInsets padding;
  final WrapAlignment alignment;
  final bool useIntrinsicHeight;
  final WrapAlignment runAlignment;
  final WrapCrossAlignment crossAxisAlignment;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: LayoutBuilder(
        builder: (context, constrains) {
          return Wrap(
            spacing: spacing,
            alignment: alignment,
            runSpacing: runSpacing,
            runAlignment: runAlignment,
            crossAxisAlignment: crossAxisAlignment,
            children: items.map((item) {
              return SizedBox(
                width: nCols != null
                    ? ((constrains.maxWidth / nCols!) -
                              ((spacing * (nCols! - 1)) / nCols!))
                          .floor()
                          .toDouble()
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
