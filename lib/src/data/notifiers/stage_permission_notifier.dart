import 'package:dyte_core/dyte_core.dart';
import 'package:dyte_uikit/src/di/di.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class StagePermissionNotifier extends Notifier<DyteMediaPermission>
    implements DyteDataEventsListener {
  DyteMediaPermission _getStagePermission() {
    final audioPermission = dyteMobileClient.permissions.media.audio;
    final videoPermission = dyteMobileClient.permissions.media.video.permission;
    DyteMediaPermission stagePermission;
    if (audioPermission == DyteMediaPermission.notAllowed ||
        videoPermission == DyteMediaPermission.notAllowed) {
      stagePermission = DyteMediaPermission.notAllowed;
    } else if (audioPermission == DyteMediaPermission.canRequest ||
        videoPermission == DyteMediaPermission.canRequest) {
      stagePermission = DyteMediaPermission.canRequest;
    } else {
      stagePermission = DyteMediaPermission.allowed;
    }

    return stagePermission;
  }

  @override
  DyteMediaPermission build() {
    return _getStagePermission();
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
  ) {}

  @override
  void onPluginUpdate(List<DytePlugin> plugin) {}

  @override
  void onScreenShareUpdate(List<DyteMeetingParticipant> screenShares) {}

  @override
  void onSelfPermissionsUpdate(DytePermissions permissions) {
    state = _getStagePermission();
  }
}
