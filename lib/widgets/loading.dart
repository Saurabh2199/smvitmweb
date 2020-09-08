import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Loading extends StatefulWidget {

  @override
  _LoadingState createState() => _LoadingState();
}

class _LoadingState extends State<Loading> {
  Color _color;

  double height = 0, width = 0;

  @override
  Widget build(BuildContext context) {

    _color = Theme.of(context).primaryColor;
    final _mediaQuery = MediaQuery.of(context).size;
    height = _mediaQuery.height;
    width = _mediaQuery.width;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SpinKitChasingDots(color: _color, size: 30,),
        SizedBox(height: 10,),
        Text("Please wait"),
      ],
    );
  }
}