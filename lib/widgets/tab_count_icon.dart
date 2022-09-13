import 'package:flutter/material.dart';

import '../controller.dart';

/// Reusable button which shows supplied [TabSwitcherController]'s tab count
/// and triggers tab switching if tapped. For use in AppBar.
class TabCountIcon extends StatelessWidget {
  const TabCountIcon({required this.controller, Key? key}) : super(key: key);

  final TabSwitcherController controller;

  @override
  Widget build(BuildContext context) {
    return InkResponse(
      highlightShape: BoxShape.circle,
      onTap: controller.toggleTabSwitcher,
      child: Container(
        width: 48,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: 18,
              decoration: BoxDecoration(
                border: Border.all(color: IconTheme.of(context).color ?? Colors.white, width: 2),
                borderRadius: BorderRadius.all(
                  Radius.circular(4),
                ),
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 3.5),
                child: Center(
                  child: Opacity(
                    opacity: controller.tabCount == 0 ? 0 : 1,
                    child: Text(
                      controller.tabCount.toString(),
                      style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
