import 'package:flutter/material.dart';

void showNotificationDropdown({
  required BuildContext context,
  required GlobalKey notificationButtonKey,
  required List<PopupMenuItem<String>> items,
  required Function() onClose,
}) {
  final RenderBox buttonBox =
      notificationButtonKey.currentContext!.findRenderObject() as RenderBox;
  final Offset buttonPosition = buttonBox.localToGlobal(Offset.zero);
  final Size buttonSize = buttonBox.size;

  showMenu(
    context: context,
    position: RelativeRect.fromLTRB(
      buttonPosition.dx,
      buttonPosition.dy + buttonSize.height,
      buttonPosition.dx + buttonSize.width,
      0,
    ),
    items: items,
  ).then((_) => onClose());
}