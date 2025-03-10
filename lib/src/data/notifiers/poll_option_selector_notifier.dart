import 'package:dyte_uikit/dyte_uikit.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PollOptionSelectorNotifier extends Notifier<DytePollOption?> {

  final DytePollMessage pollMessage;
  PollOptionSelectorNotifier(this.pollMessage);

  DytePollOption? get selectedOption => state;

  @override
  build() {
    for (final option in pollMessage.options) {
      if (option.votes.any((element) => element.id == dyteMobileClient.localUser.userId)) {
        return option;
      }
    }
    return null;
  }
}
