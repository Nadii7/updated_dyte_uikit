# Dyte UI Kit

An easy-to-integrate Flutter package for all your audio-video call, and does all the heavylifting using state-of-the-art Dyte's SDK and infrastructure.


A following example showcases some of the screens you get with this package:

<table>
    <tbody>
        <tr>
            <td align="center" style="background-color: white">
                <img src="https://cdn.dyte.in/flutter_uikit/flutter-setup-page.png" width="225"/>
            </td>
            <td align="center" style="background-color: white">
                <img src="https://cdn.dyte.in/flutter_uikit/flutter-video-call.png" width="225"/>
            </td>
            <td align="center" style="background-color: white">
                <img src="https://cdn.dyte.in/flutter_uikit/flutter-advanced-features.png" width="225"/>
            </td>
        </tr>
        <tr>
            <td align="center" style="background-color: white">
                <img src="https://cdn.dyte.in/flutter_uikit/flutter-chat.png" width="225"/>
            </td>
            <td align="center" style="background-color: white">
                <img src="https://cdn.dyte.in/flutter_uikit/flutter-participant-list.png" width="225"/>
            </td>
        </tr>
    </tbody>
</table>


## Before getting started:
- Create an account on [Dyte Developer Portal](http://dev.dyte.io/)
- Create some [presets](https://dev.dyte.io/roles-presets) on the portal.
> **_Presets:_**  Permissions that you grant to certain role in your Dyte dev portal organization.
- Create a [Dyte meeting](https://docs.dyte.io/api/?v=v2#/operations/create_meeting).
- [Add participant](https://docs.dyte.io/api/?v=v2#/operations/add_participant) to your meeting.

- As you add a participant to your meeting, you'll get a `authToken`. That's all you require to initialize a full-feature dyte audio/video call.


## Usage

### Step 1: Install the SDK

- Add `dyte_uikit` as a dependency in your `pubspec.yaml`, or run `flutter pub add dyte_uikit`.

```dart
    flutter pub add dyte_uikit
```

### Step 2: Android & iOS Permissions

- #### Android

    Set `compileSdkVersion 33` & `minSdkVersion 21` inside app-level `build.grade`.
    ```dart

    defaultConfig {
        ...

        compileSdkVersion 33
        minSdkVersion 21

        ...
    }
    ```

- #### iOS

    1.  Set minimum deployment target for your Flutter app to 13.0 or higher in your Podfile.
    ```Swift
    platform :ios, '13.0'
    ```
    2. Add the following keys to your `Info.plist file to get Camera & Microphone permission.
    ```
    /* Attach the permission to use camera & microphone. */

    <key>NSCameraUsageDescription</key>
    <string>For people to see you during meetings, we need access to your camera.</string>
    
    <key>NSMicrophoneUsageDescription</key>
    <string>For people to hear you during meetings, we need access to your microphone.</string>
    ```

### Step 3: Initialize the Dyte Meeting SDK

Build DyteMeetingInfo object (preferably _v2 meeting_) using the `authToken` you fetched from [Before Getting Started](#before-getting-started) section as follows:

```dart
    final meetingInfoV2 = DyteMeetingInfoV2(authToken: '<auth_token>');
```
The `DyteUIKit` is the main class of the SDK. It is the entry point and the only class required to initialize Dyte UI Kit SDK.

```dart

/* Passing the DyteMeetingInfoV2 object `meetingInfo` you created in the Step 3,
*/

final uikitInfo = DyteUIKitInfo(
      meetingInfo,
      // Optional: Pass the DyteDesignTokens object to customize the UI
      designToken: DyteDesignTokens(
        colorToken: DyteColorToken(
          brandColor: Colors.purple,
          backgroundColor: Colors.black,
          textOnBackground: Colors.white,
          textOnBrand: Colors.white,
        ),
      ),
    );

final uiKit = DyteUIKitBuilder.build(uiKitInfo: uikitInfo);


```

### Step 4: Launch the meeting UI

To launch the meeting UI all you need to do is call the `loadUI()` method of the `DyteUIKit` object which will return a `Widget`. You can push this widget as a page to start the flow of prebuilt Flutter UI Kit.

```dart
    import 'package:dyte_uikit/dyte_uikit.dart';
    import 'package:flutter/material.dart';

    class DyteMeetingPage extends StatelessWidget {
      const DyteMeetingPage({super.key});
    
      @override
      Widget build(BuildContext context) {
        ...
        // Push this widget as page in your app
        return uiKit.loadUI();
      }
    }
```


### Conclusion

To know more about the customization you can do with `dyte_uikit`, head over to [docs.dyte.io/flutter](`https://docs.dyte.io/flutter).

### Sample app
You can clone our [sample app](https://github.com/dyte-io/mobile-samples/tree/main/flutter_uikit) to get more idea about the implementation of `dyte_uikit` in Flutter application.