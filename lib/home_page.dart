import 'dart:math';
import 'package:flutter/material.dart';
import 'package:dice_roll_tracker/tracker.dart';
import 'package:dice_roll_tracker/state_handler.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _failures = 0;
  int _successes = 0;

  @override
  void initState() {
    super.initState();
    _loadState();
  }

  _loadState() async {
    final state = await loadSavedState();
    setState(() {
      _successes = state.successes;
      _failures = state.failures;
    });
  }

  void _incrementSuccesses([int delta = 1]) {
    setState(() {
      _successes = max(0, _successes + delta);
      saveState(_successes, _failures);
    });
  }

  void _incrementFailures([int delta = 1]) {
    setState(() {
      _failures = max(0, _failures + delta);
      saveState(_successes, _failures);
    });
  }

  num _rate() {
    var total = _failures + _successes;
    if (total == 0) {
      return 0;
    }
    return (_successes / total) * 100;
  }

  void _clearState() {
    clearState()
        .then((value) => _loadState());
  }

  _showAlertDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Reset Rolls?'),
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
                _clearState();
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
        title: Text(widget.title),
        actions: [
          IconButton(
            icon: Icon(Icons.delete_forever_outlined),
            onPressed: () {
              _showAlertDialog(context);
            },
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[

              Image.asset('assets/rolling-dices.png', height: 150,),

              Tracker(label: 'Successes', value: _successes, onChange: (delta) {
                _incrementSuccesses(delta);
              }),

              Tracker(label: 'Failures', value: _failures, onChange: (delta) {
                _incrementFailures(delta);
              }),


              Container(
                margin: EdgeInsets.symmetric(vertical: 30),
                child: Column(
                  children: [
                    Text(
                      '${_rate().toStringAsFixed(2)}%',
                      style: Theme.of(context).textTheme.headline3,
                    ),

                    Text(
                      'with ${ _successes + _failures } rolls',
                      style: Theme.of(context).textTheme.headline4,
                    ),
                  ],
                ),
              )

            ],
          ),
        ),
      ),
    );
  }
}