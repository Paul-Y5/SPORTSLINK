import 'package:flutter/material.dart';
import 'package:sports_link/models/utilizador.dart';
import 'package:sports_link/widgets/notification_item.dart'
    as notification_item;

void showNotificationDropdown({
  required BuildContext context,
  required GlobalKey notificationButtonKey,
  required Function() onClose,
  required Utilizador user,
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
    items: _buildNotificationItems(user.notificacoes),
  ).then((_) => onClose());
}

List<PopupMenuItem<String>> _buildNotificationItems(
  List<String> notifications,
) {
  if (notifications.isEmpty) {
    return [
      const PopupMenuItem<String>(
        value: 'none',
        child: ListTile(
          leading: Icon(Icons.notifications_off, color: Colors.grey),
          title: Text('Sem notificações no momento'),
        ),
      ),
    ];
  }

  return [
    for (String notification in notifications)
      _buildNotificationItem(notification),
  ];
}

PopupMenuItem<String> _buildNotificationItem(String text) {
  return PopupMenuItem(
    value: 'notification',
    child: notification_item.NotificationItem(text: text),
  );
}
