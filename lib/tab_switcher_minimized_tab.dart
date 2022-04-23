import 'package:flutter/material.dart';
import 'package:tab_switcher/tab_switcher_controller.dart';
import 'package:tab_switcher/ui_image_widget.dart';

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

    return Dismissible(
      movementDuration: Duration(milliseconds: 1),
      resizeDuration: Duration(milliseconds: 1),
      key: ValueKey(_tab.index),
      onDismissed: (direction) => onClose(),
      child: GestureDetector(
        onTap: onTap,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          child: Container(
            decoration: BoxDecoration(
              color: _isCurrent ? theme.colorScheme.secondary : theme.colorScheme.background,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(color: Colors.black12, spreadRadius: 1.5, blurRadius: 4),
              ],
            ),
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.only(left: 8, right: 8, top: 4, bottom: 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          title,
                          style: TextStyle(fontSize: 14),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                      ),
                      GestureDetector(
                        child: Padding(
                          padding: const EdgeInsets.all(4),
                          child: Icon(Icons.close, size: 20, color: Colors.white30),
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
                          padding: EdgeInsets.only(left: 8, right: 8, top: 0, bottom: 4),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  subtitle,
                                  style: TextStyle(fontSize: 12, color: Colors.white54),
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
                                ? Center(
                                    child: Text(
                                      'No preview',
                                      style: TextStyle(
                                        color: Colors.white54,
                                        fontSize: 10,
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
      ),
    );
  }
}
