import 'package:base_style_sheet/base_style_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late PagedListController<Exception, String> tableController;

  final columns = List.generate(
    8,
    (index) => TableColumnConfig<String>(
      header: 'Coluna $index',
      width: 220,
      cellBuilder: (context, item, rowIndex) =>
          Text('$item-$index', key: Key('cell-$rowIndex-$index')),
    ),
  );

  Widget buildSubject() {
    return MaterialApp(
      home: Scaffold(
        body: Builder(
          builder: (context) => PagedTableView<Exception, String>(
            context: context,
            columns: columns,
            allowRefresh: false,
            tableController: tableController,
          ),
        ),
      ),
    );
  }

  setUp(() {
    tableController = PagedListController<Exception, String>(pageSize: 3)
      ..setListener(({required pageKey, pageSize}) async {
        return List.generate(3, (index) => 'item$index');
      });
  });

  tearDown(() => tableController.dispose());

  testWidgets('renders all headers and cells after fetching', (tester) async {
    await tester.pumpWidget(buildSubject());
    await tester.pump(Durations.medium1);
    await tester.pumpAndSettle();

    expect(find.byType(DataTable), findsOneWidget);
    expect(find.byKey(const Key('cell-0-0')), findsOneWidget);
    expect(find.byKey(const Key('cell-2-7')), findsOneWidget);
  });

  testWidgets('wraps the table in an always visible horizontal scrollbar', (
    tester,
  ) async {
    await tester.pumpWidget(buildSubject());
    await tester.pump(Durations.medium1);
    await tester.pumpAndSettle();

    final horizontalScrollView = tester.widget<SingleChildScrollView>(
      find
          .ancestor(
            of: find.byType(DataTable),
            matching: find.byType(SingleChildScrollView),
          )
          .first,
    );
    expect(horizontalScrollView.scrollDirection, Axis.horizontal);

    final scrollbar = tester.widget<RawScrollbar>(
      find
          .ancestor(
            of: find.byType(DataTable),
            matching: find.byType(RawScrollbar),
          )
          .first,
    );
    expect(scrollbar.controller, same(horizontalScrollView.controller));
    expect(scrollbar.interactive, isTrue);
    expect(scrollbar.thumbVisibility, isTrue);
    expect(scrollbar.trackVisibility, isTrue);
  });

  testWidgets('paints the scrollbar outside the table card in its own strip', (
    tester,
  ) async {
    await tester.pumpWidget(buildSubject());
    await tester.pump(Durations.medium1);
    await tester.pumpAndSettle();

    final scrollbarFinder = find
        .ancestor(
          of: find.byType(DataTable),
          matching: find.byType(RawScrollbar),
        )
        .first;
    final scrollbar = tester.widget<RawScrollbar>(scrollbarFinder);
    expect(scrollbar.padding, EdgeInsets.zero);

    final scrollbarColumn = scrollbar.child as Column;
    expect(scrollbarColumn.children.first, isA<ClipRRect>());
    expect(
      scrollbarColumn.children.last,
      isA<SizedBox>().having(
        (strip) => strip.height,
        'height',
        Spacing.sm.height,
      ),
    );
    expect(
      find.descendant(
        of: find.byType(ClipRRect),
        matching: find.byType(DataTable),
      ),
      findsOneWidget,
    );
  });

  testWidgets('dragging the scrollbar thumb scrolls the table horizontally', (
    tester,
  ) async {
    await tester.pumpWidget(buildSubject());
    await tester.pump(Durations.medium1);
    await tester.pumpAndSettle();

    final horizontalScrollView = tester.widget<SingleChildScrollView>(
      find
          .ancestor(
            of: find.byType(DataTable),
            matching: find.byType(SingleChildScrollView),
          )
          .first,
    );
    final controller = horizontalScrollView.controller!;
    expect(controller.offset, 0);

    await tester.drag(find.byType(DataTable), const Offset(-300, 0));
    await tester.pumpAndSettle();

    expect(controller.offset, greaterThan(0));
  });
}
