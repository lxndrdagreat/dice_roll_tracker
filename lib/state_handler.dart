import 'package:shared_preferences/shared_preferences.dart';

class SavedState {
  final int successes;
  final int failures;
  const SavedState({this.successes, this.failures});
}

Future<SavedState> loadSavedState() async {
  final prefs = await SharedPreferences.getInstance();
  final successes = (prefs.getInt('successes') ?? 0);
  final failures = (prefs.getInt('failures') ?? 0);
  return SavedState(successes: successes, failures: failures);
}

Future<void> saveState(int successes, int failures) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setInt('successes', successes);
  await prefs.setInt('failures', failures);
}

Future<void> clearState() async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.remove('successes');
  await prefs.remove('failures');
}
