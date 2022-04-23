import 'package:flutter/material.dart';

typedef AnimatedGridBuilder<T> = Widget Function(BuildContext, T item, AnimatedGridDetails details);

/// Based on https://gist.github.com/lukepighetti/df460db180b9f6cb3410e3cc91ed74e6
class AnimatedGrid<T> extends StatelessWidget {
  /// An animated grid the animates when the items change sort.
  const AnimatedGrid({
    Key? key,
    required this.itemHeight,
    required this.items,
    required this.keyBuilder,
    required this.builder,
    this.columns = 2,
    this.duration = const Duration(milliseconds: 750),
    this.curve = Curves.elasticOut,
  }) : super(key: key);

  /// The grid items. Should all be the same height.
  final List<T> items;

  /// Construct keys given the item provided. Each key must be unique.
  final Key Function(T item) keyBuilder;

  /// Build a widget given a context, the current item, and the column and row index.
  final AnimatedGridBuilder<T> builder;

  /// The number of columns wide to display.
  final int columns;

  /// The height of each child.
  final double itemHeight;

  /// The duration of the sort animation.
  final Duration duration;

  /// The curve of the sort animation.
  final Curve curve;

  static int _rows(int columns, int count) => (count / columns).ceil();

  @visibleForTesting
  static List<int> gridIndicies(int index, int columns, int count) {
    final rows = _rows(columns, count);
    final maxItemsForGridSize = columns * rows;
    final yIndex = (index / maxItemsForGridSize * rows).floor();
    final xIndex = index % columns;
    return [xIndex, yIndex];
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        assert(constraints.hasBoundedWidth);
        assert(constraints.hasBoundedHeight == false);
        final width = constraints.maxWidth;

        final count = items.length;
        final itemWidth = width / columns;
        final rows = _rows(columns, count);
        final gridHeight = rows * itemHeight;

        return SizedBox(
          height: gridHeight,
          child: Stack(
            alignment: Alignment.topLeft,
            children: [
              for (var i = 0; i <= items.lastIndex; i++)
                Builder(
                  key: keyBuilder(items[i]),
                  builder: (context) {
                    final item = items[i];
                    final indicies = gridIndicies(i, columns, count);
                    assert(indicies.length == 2);

                    final xIndex = indicies.first;
                    final yIndex = indicies.last;
                    final offset = Offset(xIndex * itemWidth, yIndex * itemHeight);

                    return TweenAnimationBuilder<Offset>(
                      tween: Tween<Offset>(end: offset),
                      duration: duration,
                      curve: curve,
                      builder: (context, offset, child) {
                        return Transform.translate(
                          offset: offset,
                          child: child,
                        );
                      },
                      child: SizedBox(
                        height: itemHeight,
                        width: itemWidth,
                        child: builder(
                          context,
                          item,
                          AnimatedGridDetails(
                            index: i,
                            columnIndex: xIndex,
                            rowIndex: yIndex,
                            columns: columns,
                            rows: rows,
                          ),
                        ),
                      ),
                    );
                  },
                ),
            ],
          ),
        );
      },
    );
  }
}

class AnimatedGridDetails {
  /// A collection of details currently being used by [AnimatedGrid]
  AnimatedGridDetails({
    required this.index,
    required this.columnIndex,
    required this.rowIndex,
    required this.columns,
    required this.rows,
  });

  /// The current index
  final int index;

  /// The current column index
  final int columnIndex;

  /// The current row index
  final int rowIndex;

  /// The number of columns
  final int columns;

  /// The number of rows
  final int rows;
}

extension IterableX<T> on Iterable<T> {
  /// The last index on this iterable.
  ///
  /// Ie `[A,B,C].lastIndex == 2`
  int get lastIndex => length == 0 ? throw RangeError('Cannot find the last index of an empty iterable') : length - 1;
}
