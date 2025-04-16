import 'package:flutter/material.dart';
import 'package:sports_link/widgets/notification_item.dart'
    as notification_item;

void showNotificationDropdown({
  required BuildContext context,
  required GlobalKey notificationButtonKey,
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
    items: _buildNotificationItems(),
  ).then((_) => onClose());
}

List<PopupMenuItem<String>> _buildNotificationItems() {
  return [
    _buildNotificationItem('Reserva #1234 confirmada com sucesso'),
    _buildNotificationItem('Nova mensagem de Rafael'),
    _buildNotificationItem('Partida #5678 foi cancelada'),
  ];
}

PopupMenuItem<String> _buildNotificationItem(String text) {
  return PopupMenuItem(
    value: 'notification',
    child: notification_item.NotificationItem(text: text),
  );
}
