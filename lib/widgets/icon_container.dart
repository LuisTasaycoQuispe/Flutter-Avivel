import 'package:flutter/material.dart';

class IconContainer extends StatelessWidget {
  const IconContainer({Key key = const Key('default')}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Image.asset('assets/LogoAvivel.png'),
      width: 100,
      height: 120,
      decoration: BoxDecoration(
        color: Color.fromARGB(255, 114, 57, 18),
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 10,
          ),
        ],
      ),
      padding: EdgeInsets.all(5),
    );
  }
}
