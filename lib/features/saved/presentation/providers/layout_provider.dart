import 'package:flutter_riverpod/flutter_riverpod.dart';

enum PinLayout {
  wide,
  standard,
  compact,
}

class PinLayoutNotifier extends Notifier<PinLayout> {
  @override
  PinLayout build() {
    return PinLayout.compact;
  }

  void setLayout(PinLayout layout) {
    state = layout;
  }
}

final pinLayoutProvider = NotifierProvider<PinLayoutNotifier, PinLayout>(PinLayoutNotifier.new);
