import 'package:shared_preferences/shared_preferences.dart';

class FutureObject {
    String prefValue = "";

    Future<FutureObject> create() async {
      return FutureObject();
    }

    Future<void> setToSharedPreference() async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString("pref_value", "Hello World");
      print("done");
    }

    Future<void> getFromSharedPreference() async {
      await Future.delayed(Duration(seconds: 2));
      SharedPreferences prefs = await SharedPreferences.getInstance();
      this.prefValue = prefs.getString("pref_value" ?? "");
    }
}
