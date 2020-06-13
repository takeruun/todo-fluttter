import 'package:shared_preferences/shared_preferences.dart';

class SharePrefs {
  static final list_Items = "llist_item";
  static final completed_Items = "completed_imtes";
  static SharedPreferences _sharedPrefrences;

  static Future setInstance() async {
    if (null != _sharedPrefrences) return;
    _sharedPrefrences = await SharedPreferences.getInstance();
  }

  static Future<bool> setListItems(List<String> value) =>
      _sharedPrefrences.setStringList(list_Items, value);
  static List<String> getListItems() =>
      _sharedPrefrences.getStringList(list_Items) ?? [];

  static Future<bool> setCompletedItems(List<String> value) =>
      _sharedPrefrences.setStringList(completed_Items, value);
  static List<String> getCompletedItems() =>
      _sharedPrefrences.getStringList(completed_Items) ?? [];
}
