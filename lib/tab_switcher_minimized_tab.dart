import 'package:flutter/material.dart';
import 'package:tab_switcher/tab_switcher_controller.dart';
import 'package:tab_switcher/ui_image_widget.dart';

/// A widget representing single minimized tab.
/// Consists of title, subtitle, preview image and a close button.
/// Implements swipe to dismiss on it's own.
class TabSwitcherMinimizedTab extends StatelessWidget {
  TabSwitcherMinimizedTab(this._tab, this.onTap, this.onClose, this._isCurrent);

  final VoidCallback onClose;
  final VoidCallback onTap;
  final TabSwitcherTab _tab;
  final bool _isCurrent;

  @override
  Widget build(BuildContext context) {
    final title = _tab.getTitle();
    final subtitle = _tab.getSubtitle();
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Dismissible(
      movementDuration: Duration(milliseconds: 1),
      resizeDuration: Duration(milliseconds: 1),
      key: ValueKey(_tab.index),
      onDismissed: (direction) => onClose(),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            color: _isCurrent ? colorScheme.primary : colorScheme.surface,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(color: Colors.black12, spreadRadius: 1.5, blurRadius: 4),
            ],
          ),
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.only(left: 8, right: 4, top: 4, bottom: 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        title,
                        style:
                            TextStyle(fontSize: 14, color: _isCurrent ? colorScheme.onPrimary : colorScheme.onSurface),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                    ),
                    GestureDetector(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 2, right: 2),
                        child: Icon(
                          Icons.close,
                          size: 20,
                          color: _isCurrent
                              ? colorScheme.onPrimary.withOpacity(0.5)
                              : colorScheme.onSurface.withOpacity(0.5),
                        ),
                      ),
                      behavior: HitTestBehavior.opaque,
                      onTap: onClose,
                    ),
                  ],
                ),
              ),
              ...subtitle == null
                  ? []
                  : [
                      Padding(
                        padding: EdgeInsets.only(left: 8, right: 8, top: 0, bottom: 2),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                subtitle,
                                style: TextStyle(
                                    fontSize: 12,
                                    color: _isCurrent
                                        ? colorScheme.onPrimary.withOpacity(0.5)
                                        : colorScheme.onSurface.withOpacity(0.5)),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
              Expanded(
                child: Padding(
                  padding: EdgeInsets.all(4),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Expanded(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: _tab.previewImage == null
                              ? Container(
                                  color: colorScheme.surface,
                                  child: Center(
                                    child: Text(
                                      'No preview',
                                      style: TextStyle(
                                        color: colorScheme.onSurface.withOpacity(0.5),
                                        fontSize: 10,
                                      ),
                                    ),
                                  ),
                                )
                              : UiImageWidget(image: _tab.previewImage!, fit: BoxFit.fitWidth),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
