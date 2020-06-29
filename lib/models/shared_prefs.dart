import 'package:shared_preferences/shared_preferences.dart';

class SharePrefs {
  SharePrefs._();
  static final SharePrefs sharePrefs = SharePrefs._();

  static final list_Items = "llist_item";
  static final completed_Items = "completed_imtes";
  static final draft_title = 'draft_title';
  static final draft_subTitle = 'draft_subTitle';

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

  static Future<bool> setDraft(String str, bool draft_flag) {
    var draft = draft_flag ? draft_title : draft_subTitle;
    _sharedPrefrences.setString(draft, str);
  }

  static String getDraft(bool draft_flag) {
    var draft = draft_flag ? draft_title : draft_subTitle;
    _sharedPrefrences.getString(draft) ?? '';
  }

  static Future<bool> deleteDraft() {
    _sharedPrefrences.setString(draft_title, '');
    _sharedPrefrences.setString(draft_subTitle, '');
  }
}
