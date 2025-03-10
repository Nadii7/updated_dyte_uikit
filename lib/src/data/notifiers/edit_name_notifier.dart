import 'package:dyte_uikit/dyte_uikit.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class EditNameNotifier extends Notifier<String> {
  String _name = "";

  String get name => _name.trim();

  onChanged(String editedName) {
    _name = editedName;
    state = _name;
  }

  @override
  String build() {
    _name = dyteMobileClient.localUser.name;
    return name;
  }
}
