import 'package:flutter/cupertino.dart';

class CustomWrap<T> extends StatelessWidget {
  CustomWrap({
    super.key,
    this.nCols,
    this.spacing = 8,
    this.runSpacing = 8,
    required this.items,
    this.padding = .zero,
    this.alignment = .start,
    this.flexChilds = const [],
    this.runAlignment = .start,
    this.useIntrinsicHeight = false,
    this.crossAxisAlignment = .center,
  }) : assert(
         flexChilds.isEmpty || nCols == null || flexChilds.length <= nCols,
         '''flexChilds.length (${flexChilds.length}) não pode ser maior que nCols ($nCols)''',
       );

  final int? nCols;
  final double spacing;
  final double runSpacing;
  final List<Widget> items;
  final EdgeInsets padding;
  final List<int> flexChilds;
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
            children: items.asMap().entries.map((entry) {
              final index = entry.key;
              final item = entry.value;

              double? width;

              if (nCols != null) {
                // Determina a posição na linha atual (0-indexed)
                final positionInRow = index % nCols!;

                // Se temos flexChilds definidos e 
                // a posição está dentro do range
                if (flexChilds.isNotEmpty &&
                    positionInRow < flexChilds.length) {
                  // Calcula a soma total dos flex da linha
                  final totalFlex = flexChilds
                      .take(nCols!)
                      .fold<int>(0, (sum, flex) => sum + flex);

                  // Pega o flex do item atual
                  final itemFlex = flexChilds[positionInRow];

                  // Calcula a largura proporcional
                  // Considera o spacing total da linha
                  final totalSpacing = spacing * (nCols! - 1);
                  final availableWidth = constrains.maxWidth - totalSpacing;

                  width = (availableWidth * (itemFlex / totalFlex))
                      .floorToDouble();
                } else {
                  // Para itens sem flex definido, calcula distribuição igual
                  // considerando quantos itens flexíveis existem na linha
                  final numFlexItems = flexChilds.length.clamp(0, nCols!);
                  final numEqualItems = nCols! - numFlexItems;

                  if (numEqualItems > 0) {
                    // Calcula o espaço usado pelos itens flexíveis
                    final totalSpacing = spacing * (nCols! - 1);
                    final availableWidth = constrains.maxWidth - totalSpacing;

                    if (flexChilds.isNotEmpty) {
                      final totalFlex = flexChilds
                          .take(nCols!)
                          .fold<int>(0, (sum, flex) => sum + flex);
                      final flexUsedWidth =
                          availableWidth *
                          (flexChilds
                                  .take(numFlexItems)
                                  .fold<int>(0, (sum, flex) => sum + flex) /
                              totalFlex);

                      // Divide o espaço restante igualmente
                      width = ((availableWidth - flexUsedWidth) / numEqualItems)
                          .floorToDouble();
                    } else {
                      // Se não tem flexChilds, divide igualmente
                      width = (availableWidth / nCols!).floorToDouble();
                    }
                  } else {
                    // Fallback para divisão igual
                    final totalSpacing = spacing * (nCols! - 1);
                    width = ((constrains.maxWidth - totalSpacing) / nCols!)
                        .floorToDouble();
                  }
                }
              }

              return SizedBox(width: width, child: item);
            }).toList(),
          );
        },
      ),
    );
  }
}
