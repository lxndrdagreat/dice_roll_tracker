import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class Session {
  final DateTime date;
  int successes = 0;
  int failures = 0;

  Session({this.successes = 0, this.failures = 0, this.date});

  static Session fromData(dynamic data) {
    var date = DateTime.now();
    if (data.containsKey('date') && data['date'] != null) {
      date = DateTime.tryParse(data['date']);
      if (date == null) {
        // failed
        date = DateTime.now();
      }
    }
    return Session(
      successes: data['successes'] ?? 0,
      failures: data['failures'] ?? 0,
      date: date
    );
  }

  Map<String, dynamic> toJson() => {
    'successes': successes,
    'failures': failures,
    'date': date.toIso8601String()
  };
}

class SavedState {
  final List<Session> sessions = List<Session>();

  SavedState([List<Session> items]) {
    if (items != null) {
      for (var item in items) {
        sessions.add(item);
      }
    }
  }
}

Future<SavedState> loadSavedState() async {
  final prefs = await SharedPreferences.getInstance();
  if (prefs.containsKey('sessions')) {
    final data = jsonDecode(prefs.getString('sessions'));
    return SavedState(
        (data as List<dynamic>).map((e) => Session.fromData(e)).toList()
    );
  } else {
    return SavedState();
  }
}

Future<void> saveState(List<Session> sessions) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString('sessions', jsonEncode(sessions));
}

Future<Session> activeSession() async {
  final state = await loadSavedState();
  if (state == null || state.sessions.isEmpty) {
    return await createNewSession();
  }

  return state.sessions.last;
}

Future<void> saveSession(int successes, int failures) async {
  final state = await loadSavedState();
  if (state.sessions.isEmpty) {
    state.sessions.add(
      Session(
        successes: successes,
        failures: failures,
        date: DateTime.now()
      )
    );
  } else {
    final session = state.sessions.last;
    session.successes = successes;
    session.failures = failures;
  }
  await saveState(state.sessions);
}

Future<void> clearState() async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.remove('sessions');
}

Future<Session> createNewSession() async {
  final session = Session(date: DateTime.now());

  final state = await loadSavedState();
  state.sessions.add(session);
  await saveState(state.sessions);

  return session;
}

Future deleteSession(int index) async {
  final state = await loadSavedState();
  if (state.sessions.isEmpty || index < 0 || index >= state.sessions.length) {
    return;
  }
  state.sessions.removeAt(index);
  await saveState(state.sessions);
}