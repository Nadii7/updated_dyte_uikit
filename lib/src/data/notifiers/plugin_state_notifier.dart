import 'package:dyte_core/dyte_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PluginNotifer extends Notifier<List<DytePlugin>>
    implements DyteDataEventsListener {
  @override
  void onPluginUpdate(List<DytePlugin> plugin) {
    state = plugin;
  }

  @override
  List<DytePlugin> build() {
    return [];
  }

  @override
  void onMetaUpdate(
    String roomName,
    String meetingTitle,
    String meetingStartedTimestamp,
    DyteRoomType roomType,
    DyteDesignTokens designTokens,
  ) {}

  @override
  void onScreenShareUpdate(List<DyteMeetingParticipant> screenShares) {}

  @override
  void onSelfPermissionsUpdate(DytePermissions permissions) {}

  @override
  void onLivestreamUpdate(DyteLivestreamData livestreamData) {}
}
