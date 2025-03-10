import 'package:flutter/material.dart';

enum ButtonState {
  normal,
  loading,
  complete,
  disabled,
}

class DyteButtonController extends ValueNotifier<ButtonState> {
  DyteButtonController() : super(ButtonState.normal);

  void changeState(ButtonState state) => value = state;
}
