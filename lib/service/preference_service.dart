import 'package:shared_preferences/shared_preferences.dart';

const String darkTheme = 'dark-theme';

void setDarkTheme(bool value) async {
  SharedPreferences preferences = await SharedPreferences.getInstance();
  preferences.setBool(darkTheme, value);
}

Future<bool> isDarkTheme() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getBool(darkTheme) ?? false;
}
