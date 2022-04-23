import 'package:flutter/cupertino.dart';
import 'package:flutter/physics.dart';

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
