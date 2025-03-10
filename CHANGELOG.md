# Dyte UI Kit

## 0.0.1

- initial release.

## 0.0.1+1

- added freezed files

## 0.0.2

- Migrated to use `dyte_core` : `0.1.1+0`

## 0.0.2+1

- Migrated to use `dyte_core` : `0.1.1+1`
- Bug fixes:
- Release not happening on android fix.
- Grid tile size is made dynamic.
- lock portrait mode for meeting room.
- file name overflow in chat.
- Setup page orientation fix.

## 0.0.2+2

Migrated to use `dyte_core` : `0.1.1+3`
Fix `pod install` error for `DyteiOSCore`.Migrated to use `dyte_core` : `0.1.1+0`

## 0.0.2+3

- Video view stability
- Pagination support added
- iOS: List of Plugin/Screenshare added
- Add 2 page indicator
- Empty Screen on Polls
- Poll UI polish
- Polls: Count to be shown when poll is completed
- Count votes to be shown
- Settings screen should show selected audio/video device
- Unread chat and polls badge added
- Migrated to support dart-3

## 0.0.2+4

- `PeerVideoView` import bug fixed.

## 0.0.3+0

- added support for older flutter versions
- Refine Notification snackbar behaviour
- Update Icons: camera switch and stage
- Show image (if available) in place of initials when video is off.
- Unread badge fix

## 0.0.3+1

- changed `image_gallery_saver` to latest.

## 0.0.4

- Fixed black screen navigation bug on leaving the meet.
- Removed `clientContext` parameter.
- Show initial display name on setup screen from `authToken`.
- Added dismiss button to leave from Setup Screen.
- Join button enable/disable based on displayName.

## 0.0.4+1

- Fix `dyteClientAndroid` initialization on `onReattachedToEngine()`.
- Updated README.
- Added optimizations for participant count rebuilds.
- Fix disabling audio/video on setup screen when preset doesn't permit.

## 0.0.5

- Added simulator support.
- Time parse error fix.
- Minor UI changes.

## 0.0.5+1

- Fix crash on `nil` VideoView on iOS.

## 0.0.5+2

- Minor UI Changes.
- Added fix for `dyteClientAndroid` late initialise error.

## 0.0.5+3

- Added fix for `dyteClientAndroid` late initialise error.

## 0.1.0

- Integrated Livestream.
- Added support for stage management methods for livestream.
- Added host controls for livestream.

## 0.2.1

- Added support for DyteDesignTokens.
- Added support for localization.

## 0.2.4

- VideoView stabilty
- Bug fixes

## 0.2.5

- ios core version change
- Bug fixes

## 0.2.5+1

- Fix `DyteFlutterEnging` crash on cold install on Android.
- Added stage method using central stage apis.

## 0.2.6

- **FIX** : updated dyte_core to v0.2.2
- **FIX** : Reconnection fixes.
- **REFACTOR**: Refactor meeting, livestream and webinar screens.
- **FEAT**: central stage implemented for webinar and livestream.
- **FIX**: Polls view voters button logic fixed.

## 0.3.0

- **FEAT** : Unread count badge on more button in control bar.
- **FEAT** : Added notification when reconnection in progress.
- **FIX** : Fixed buttons as per updation in stage permission.
- **REFACTOR** : Added text when stage is empty.
- **FEAT** : Added labels to audio/video control bar buttons.
- **FIX** : Appbar title invisibility fix.
- **FIX** : Kick disabled for self.
- **FIX** : Design token for control bar audio/video buttons.
- **FEAT** : Custom color to IconButton that overrides design token.

## 0.4.1

- **FEAT** : updated dyte_core to 0.2.3+1
- **FEAT** : Changed poll design, removed vote button.
- **FEAT** : Added plugin activate/deactivate button on plugin screen.
- **FEAT** : Added loaders for audio/video toggle buttons.
- **REFACTOR** : Minor grid tile, app bar recorder tag.
- **FIX** : Video device toggle on settings screen.
- **FIX** : Video view sync with video button on setup screen.
- **REFACTOR** : Remove deisable all videos button.
- **REFACTOR** : Changed notification position from bottom to top.
- **REFACTOR** : Minor padding changes on plugin screen.
- **REFACTOR** : Minor design changes on app bar.
- **FIX** : Issue with multiple `(you)` tags.

## 0.5.0

- **CHORE** : Upgraded flutter core to 0.3.0
- **FEAT** : added remove from stage button
- **FEAT** : added screenshare management

## 0.5.1

- **FIX** : Reverted `WillPopScope` change.

## 0.6.0

- **FEAT** : added exportable components: DyteMeetingTitle, DyteJoinButton, DyteLeaveButton, DyteLeaveMeetingDialog, DyteParticipantTile, DyteSelfAudioToggle, DyteSelfVideoToggle.
- **FIX** : Change signature of DyteUiKitBuilder.build(...)

## 0.6.1

- **FIX** : version bump for dyte_core (v0.3.2)

## 0.6.2

- **FIX** : version bump for dyte_core (v0.3.4)
- **FIX** : Added viewer list for webinar.
- **FIX** : Remove stage privileges when host is off stage.
- **FIX** : Added check for screenshare option.

## 0.7.0

- **FEAT** : Introduced `DyteReleaseResourcesButton` widget (to be used if you want to exit SDK before joining the call).
- **FIX** : upgrade `dyte_core` to v0.3.5.
- **REFACTOR** : Renamed ParticipantsPage to DyteParticipantsPage.
- **FIX** : Theme fixes for participant page, chat message layout.
- **FEAT** : Polls & Plugins screen are exportable.
- **FEAT** : Export DyteAudioIndicator, DyteNameTag, DyteSetupScreen.
- **FIX** : Added screenshare button checks for webinar and livestream control bars.
- **FIX** : Remove audio/video toggling if participant is offstage.
- **FIX** : Pin/unpin related fixes.
- **FIX** : Populates error details `onMeetingInitFailed()`/`onMeetingJoinFailed()`.
- **REFACTOR** : Introduced `DyteError` class.

## 0.7.1

- **FIX** : Previous meet join with different authToken in same app session.
- **FIX** : Respect limit on screenshare count from dev portal.
- **FIX** : Update to dyte_core v0.3.6.
- **REFACTOR** : Cleanup native listeners on release/leave meeting complete.

## 0.7.2

- **FIX** : Join room even when meeting title null.
- **FIX** : Upgraded to dyte_core 0.3.7.

## 0.7.3

- **FEAT** : Skip setup screen by passing `skipSetupScreen` param to `true` in `DyteUIKitBBuilder.build()`
- **FIX** : Fixed stuck on loading screen.
- **FIX** : Upgraded to dyte_core 0.3.8.

## 0.7.4

- **FIX**: Loader issue on end meeting for all/on removed from meeting/exiting from setup screen.
- **FIX**: Video flicker issue.
- **FIX**: Hide chat button from menu if can't send chat.

## 0.7.5

- **FIX**: iOS Screenshare.
- **FIX**: Return appropriate error details on exceptions page.
- **FIX**: Upgraded to `dyte_core` v0.3.9+1.

## 0.7.6

- **FIX**: Dispose objects in `DyteProvider`'s dispose method. Fixes multiple meeting join in same app session for using individual components.

## 0.7.7

- **FIX**: Handle concurrent modification issue.
- **FIX**: `DyteParticipantTil` sync in video status.

## 0.7.8

- **FIX**: Unread count of previous meeting is now not visible in the current meeting within the same app session.
- **FIX**: Upgraded to `dyte_core` v0.4.1.

## 0.7.9

- **FIX**: Fixed strings for custom locale.

## 0.8.0

- **FIX**: Endless connection requests to SocketService
- **FIX**: Pin-Unpin updates not reflected, need to re-open the Participant screen.

## 0.9.0

- **FIX**: Added landscape support for all screens.

## 0.9.1

- **FEAT**: Log SDK version.

## 0.9.2

- **FIX**: Fixed multiple screenshare launch in same session.

## 0.9.3

- **FIX**: Screenshare reconnection fix for control bar.
- **FIX**: Added support for AGP 8.0.0 & above, dyte_core v0.4.5.

## 0.9.4

- **FIX**: Unreads hiding more button on meeting screen.

## 0.9.5

- **FIX**: Fixed navigation routing on exiting dyte meeting.
