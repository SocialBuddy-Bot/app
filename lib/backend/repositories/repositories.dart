import 'package:flutter/foundation.dart';

import 'package:socialbuddybot/backend/api/api.dart';
import 'package:socialbuddybot/backend/app_state_store.dart';

export 'calendar_repository.dart';

abstract class Repository extends ChangeNotifier {
  Repository(this._api, this._appState);

  // ignore: unused_field
  final Api _api;
  // ignore: unused_field
  final AppStateStore _appState;

  void notify(Object _) {
    notifyListeners();
  }
}
