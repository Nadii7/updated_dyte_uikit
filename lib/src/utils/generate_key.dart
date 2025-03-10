import 'package:dyte_uikit/dyte_uikit.dart';
import 'package:flutter/rendering.dart';

Key generateKeyForParticipant(
  DyteMeetingParticipant participant, {
  String pageName = 'DyteGridView',
}) {
  return Key(
      'DyteParticipant: ${participant.id}${participant.videoEnabled}Page:$pageName');
}

Key generateAudioKeyForParticipant(
  DyteMeetingParticipant participant, {
  String pageName = 'DyteGridView',
}) {
  return Key(
      'DyteParticipant: ${participant.id}${participant.audioEnabled}Page:$pageName');
}

Key generateVideoKeyForParticipant(DyteMeetingParticipant participant,
    {String pageName = 'DyteGridView'}) {
  return Key(
      'DyteParticipant: ${participant.id}${participant.videoEnabled}Page:$pageName');
}
