import 'package:flutter/material.dart';
import 'package:sports_link/widgets/notification_dropdown.dart'
    as notification_dropdown;

bool isDropdownOpen = false;

void toggleDropdownOverlay(
  BuildContext context,
  List<PopupMenuEntry<String>> items,
) {
  isDropdownOpen = true;
  showMenu(
    context: context,
    position: const RelativeRect.fromLTRB(0, 80, 0, 0),
    items: items,
  ).then((_) => isDropdownOpen = false);
}

void showNotificationDropdown(
  BuildContext context,
  GlobalKey notificationButtonKey,
) {
  isDropdownOpen = true;
  notification_dropdown.showNotificationDropdown(
    context: context,
    notificationButtonKey: notificationButtonKey,
    onClose: () => isDropdownOpen = false,
  );
}
