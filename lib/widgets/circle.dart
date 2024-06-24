import 'package:flutter/material.dart';

class Circle extends StatelessWidget {
  final double size;
  final List<Color> colors;
//se agrego el required en las dos key
  Circle({required Key key, required this.size, required this.colors})
      : assert(size > 0),
        assert(colors.length >= 2),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: this.size,
      height: size,
      decoration: BoxDecoration(
          color: Colors.orange,
          shape: BoxShape.circle,
          gradient: LinearGradient(
              colors: this.colors,
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter)),
    );
  }
}
