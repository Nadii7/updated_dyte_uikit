import 'dart:async';

import 'package:dyte_core/dyte_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../di/di.dart';

class DyteMeetingNotifier extends AutoDisposeNotifier<Duration?>
    implements DyteDataEventsListener {
  late DateTime dateUtc;
  late Duration meetingDuration;
  bool isTimestampPresent = false;

  updateMeetingDuration(Duration meetDuration) {
    Timer.periodic(const Duration(seconds: 1), (_) {
      final meetingDuration = DateTime.now().difference(dateUtc);
      state = meetingDuration;
    });
  }

  @override
  Duration? build() {
    if (dyteMobileClient.meta.meetingStartedTimeStamp == "") {
      return null;
    }
    isTimestampPresent = true;
    dateUtc = DateTime.parse(
      dyteMobileClient.meta.meetingStartedTimeStamp,
    ).toLocal();
    meetingDuration = DateTime.now().difference(dateUtc);
    updateMeetingDuration(meetingDuration);
    return meetingDuration;
  }

  @override
  void onLivestreamUpdate(DyteLivestreamData livestreamData) {}

  @override
  void onMetaUpdate(
    String roomName,
    String meetingTitle,
    String meetingStartedTimestamp,
    DyteRoomType roomType,
    DyteDesignTokens designTokens,
  ) {
    if (!isTimestampPresent && meetingStartedTimestamp != "") {
      dateUtc = DateTime.parse(
        meetingStartedTimestamp,
      ).toLocal();
      meetingDuration = DateTime.now().difference(dateUtc);
      updateMeetingDuration(meetingDuration);
    }
  }

  @override
  void onPluginUpdate(List<DytePlugin> plugin) {}

  @override
  void onScreenShareUpdate(List<DyteJoinedMeetingParticipant> screenShares) {}

  @override
  void onSelfPermissionsUpdate(DytePermissions permissions) {}
}
