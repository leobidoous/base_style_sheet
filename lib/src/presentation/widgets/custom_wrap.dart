import 'package:flutter/cupertino.dart';

class CustomWrap<T> extends StatelessWidget {
  const CustomWrap({
    super.key,
    this.nCols,
    this.spacing = 8,
    this.runSpacing = 8,
    required this.items,
    this.padding = EdgeInsets.zero,
    this.alignment = WrapAlignment.start,
    this.runAlignment = WrapAlignment.start,
    this.crossAxisAlignment = WrapCrossAlignment.center,
  });
  final int? nCols;
  final double spacing;
  final double runSpacing;
  final List<Widget> items;
  final EdgeInsets padding;
  final WrapAlignment runAlignment;
  final WrapAlignment alignment;
  final WrapCrossAlignment crossAxisAlignment;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: LayoutBuilder(
        builder: (context, constrains) {
          return Wrap(
            spacing: spacing,
            runSpacing: runSpacing,
            alignment: alignment,
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
