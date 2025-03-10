import 'package:dyte_uikit/src/data/models/notification.dart';

abstract class NotificationState {}

class OnNotificationInitial extends NotificationState {}

class OnNewNotificationReceived extends NotificationState {
  final DyteNotification notification;
  OnNewNotificationReceived(this.notification);
}
