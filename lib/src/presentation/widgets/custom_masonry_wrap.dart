import 'package:flutter/cupertino.dart';

/// Example usage:
/// ```dart
/// CustomMasonryWrap(
///   nCols: 2,
///   spacing: 8,
///   runSpacing: 8,
///   items: [
///     Container(height: 100, child: Placeholder()),
///     Container(height: 200, child: Placeholder()),
///     Container(height: 150, child: Placeholder()),
///     Container(height: 180, child: Placeholder()),
///     Container(height: 120, child: Placeholder()),
///     Container(height: 160, child: Placeholder()),
///   ],
/// )
/// ```
class CustomMasonryWrap extends StatelessWidget {
  const CustomMasonryWrap({
    super.key,
    required this.nCols,
    this.spacing = 8,
    this.runSpacing = 8,
    required this.items,
    this.padding = .zero,
  });

  final int nCols;
  final double spacing;
  final double runSpacing;
  final List<Widget> items;
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: LayoutBuilder(
        builder: (context, constraints) {
          // Calcula a largura de cada coluna
          final totalSpacing = spacing * (nCols - 1);
          final columnWidth = (constraints.maxWidth - totalSpacing) / nCols;

          // Cria as colunas
          final columns = List.generate(nCols, (_) => <Widget>[]);

          // Distribui os itens pelas colunas de forma circular
          for (int i = 0; i < items.length; i++) {
            final columnIndex = i % nCols;
            columns[columnIndex].add(items[i]);
          }

          return Row(
            crossAxisAlignment: .start,
            children: () {
              final List<Widget> rowChildren = [];
              for (int i = 0; i < nCols; i++) {
                if (i > 0) {
                  rowChildren.add(SizedBox(width: spacing));
                }
                rowChildren.add(
                  SizedBox(
                    width: columnWidth,
                    child: Column(
                      mainAxisSize: .min,
                      crossAxisAlignment: .stretch,
                      children: columns[i].asMap().entries.map((entry) {
                        return Padding(
                          padding: EdgeInsets.only(
                            bottom: entry.key < columns[i].length - 1
                                ? runSpacing
                                : 0,
                          ),
                          child: entry.value,
                        );
                      }).toList(),
                    ),
                  ),
                );
              }
              return rowChildren;
            }(),
          );
        },
      ),
    );
  }
}
