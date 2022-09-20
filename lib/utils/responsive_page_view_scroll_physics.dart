import 'package:flutter/cupertino.dart';

/// Fast and steady scrolling physics based on [ScrollPhysics].
class ResponsiveClampedScrollPhysics extends ScrollPhysics {
  const ResponsiveClampedScrollPhysics({ScrollPhysics? parent}) : super(parent: parent);

  @override
  ResponsiveClampedScrollPhysics applyTo(ScrollPhysics? ancestor) {
    return ResponsiveClampedScrollPhysics(parent: buildParent(ancestor));
  }

  @override
  SpringDescription get spring => const SpringDescription(
        mass: 80,
        stiffness: 100,
        damping: 1,
      );
}

/// Fast and steady scrolling physics based on [BouncingScrollPhysics].
class ResponsiveBouncingScrollPhysics extends BouncingScrollPhysics {
  const ResponsiveBouncingScrollPhysics({ScrollPhysics? parent}) : super(parent: parent);

  @override
  ResponsiveBouncingScrollPhysics applyTo(ScrollPhysics? ancestor) {
    return ResponsiveBouncingScrollPhysics(parent: buildParent(ancestor));
  }

  @override
  SpringDescription get spring => const SpringDescription(
        mass: 80,
        stiffness: 100,
        damping: 1,
      );
}
