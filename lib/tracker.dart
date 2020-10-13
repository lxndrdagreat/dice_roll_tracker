import 'package:flutter/material.dart';

class Tracker extends StatelessWidget {

  final int value;
  final String label;
  final Function(int delta) onChange;

  Tracker({ @required this.label, @required this.value, @required this.onChange });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 30),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(label, style: Theme.of(context).textTheme.headline6),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [

              FloatingActionButton(
                child: Icon(Icons.remove),
                onPressed: () {
                  onChange(-1);
                },
              ),

              Container(
                width: 200,
                padding: EdgeInsets.symmetric(horizontal: 60),
                child: Text(
                  '$value',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headline3,
                ),
              ),

              FloatingActionButton(
                child: Icon(Icons.add),
                onPressed: () {
                  onChange(1);
                },
              ),

            ],
          )
        ],
      ),
    );
  }
}