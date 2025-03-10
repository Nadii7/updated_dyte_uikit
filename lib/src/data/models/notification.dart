class DyteNotification {
  final String message;
  final NotificationType type;

  DyteNotification(this.message, this.type);
}

// will be using this enum to show the correct icon in the notification
enum NotificationType {
  chat,
  poll,
  participant,
  plugin,
}
