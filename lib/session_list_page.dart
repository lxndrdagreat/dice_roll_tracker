import 'package:flutter/material.dart';
import 'package:dice_roll_tracker/state_handler.dart';

class SessionListPage extends StatefulWidget {
  static const String ROUTE = '/sessions';

  SessionListPage({Key key}) : super(key: key);

  @override
  _SessionListPageState createState() => _SessionListPageState();
}

class _SessionListPageState extends State {

  List<Session> _sessions = <Session>[];

  @override
  void initState() {
    super.initState();

    _loadSessionList();
  }

  _loadSessionList() async {
    final state = await loadSavedState();
    setState(() {
      _sessions = state.sessions.reversed.toList();
    });
  }

  _clearData(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Clear data?'),
            content: Text('Are you sure you want to reset?'),
            actions: [
              FlatButton(
                child: Text('Cancel'),
                onPressed: () {
                  Navigator.of(context, rootNavigator: true).pop();
                },
              ),

              FlatButton(
                child: Text('Continue'),
                onPressed: () {
                  clearState()
                  .then((value) {
                    _loadSessionList();
                    Navigator.of(context, rootNavigator: true).pop();
                  });
                },
              )
            ],
          );
        }
    );
  }

  _deleteSession(BuildContext context, int index) {

    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Delete session?'),
            content: Text('Are you sure you want to delete this session?'),
            actions: [
              FlatButton(
                child: Text('Cancel'),
                onPressed: () {
                  Navigator.of(context, rootNavigator: true).pop();
                },
              ),

              FlatButton(
                child: Text('Delete'),
                onPressed: () async {
                  await deleteSession(_sessions.length - 1 - index);
                  await _loadSessionList();
                  Navigator.of(context, rootNavigator: true).pop();
                },
              )
            ],
          );
        }
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Session History')
      ),
      body: ListView.builder(
        itemCount: _sessions.length,
        itemBuilder: (context, index) {
          final item = _sessions[index];

          final total = item.failures + item.successes;
          final rate = total == 0 ? 0 : (item.successes / total) * 100;

          return ListTile(
            title: Text('${item.date.year}-${item.date.month}-${item.date.day}'),
            subtitle: Text('${rate.toStringAsFixed(2)}% success'),
            trailing: IconButton(
              icon: Icon(Icons.delete),
              onPressed: () {
                _deleteSession(context, index);
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.delete),
        onPressed: () {
          _clearData(context);
        },
      ),
    );
  }
}
