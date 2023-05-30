import 'package:chatdemo/utilities/extensions.dart';

import '../main.dart';
import 'constants.dart';

class PreferenceManager {
  Future<bool> checkIfAutoAuth() async {
    var isAutoAuth = await storage.read(key: StorageKey.KEY_AUTO_AUTH);
    if (isAutoAuth == "true") {
      var email = await storage.read(key: StorageKey.KEY_CRED_LOGIN);
      var pswd = await storage.read(key: StorageKey.KEY_CRED_PSWD);
      if (email?.isNullOrEmpty() == false && pswd?.isNullOrEmpty() == false) {
        return true;
      }
    } else {
      return false;
    }

    return false;
  }

  Future<String?> getPref({required String value}) async {
    return await storage.read(key: value);
  }
}
