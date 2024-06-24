import 'package:flutter/material.dart';

class HomeChat extends StatefulWidget {
  @override
  _HomeChatState createState() => _HomeChatState();
}

class _HomeChatState extends State<HomeChat> {
  // final _usernameController = TextEditingController();
  // late String _usernameError;
  // bool _loading = false;

  // Future<void> _onGoPressed() async {
  //   final username = _usernameController.text;
  //   if (username.isNotEmpty) {
  //     final client = StreamChat.of(context).client;
  //     setState(() {
  //       _loading = true;
  //     });
  //     await client.connectUser(
  //       User(
  //         id: username,
  //         extraData: {
  //           'image': DataUtils.getUserImage(username),
  //         },
  //       ),
  //       client.devToken(username).toString(),
  //     );
  //     setState(() {
  //       _loading = false;
  //     });
  //     Navigator.of(context).push(
  //       MaterialPageRoute(
  //         builder: (_) => FriendsChat(),
  //       ),
  //     );
  //   } else {
  //     setState(() {
  //       _usernameError = 'Username no valido';
  //     });
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Prueba de Chat"),
      ),
      body: Center(
        child: Card(
          child: Container(
            padding: EdgeInsets.all(24.5),
            child: Text(
              'EN DESARROLLO',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ),

        // child: _loading
        //     ? CircularProgressIndicator()
        //     : Card(
        //         elevation: 11,
        //         margin: const EdgeInsets.all(15.0),
        //         child: Padding(
        //           padding: const EdgeInsets.all(20.0),
        //           child: Column(
        //             children: [
        //               Text("Hola Usuario"),
        //               TextField(
        //                 controller: _usernameController,
        //                 decoration: InputDecoration(
        //                   hintText: 'Nombre de Usuario',
        //                   errorText: _usernameError,
        //                 ),
        //               ),
        //               ElevatedButton(
        //                 onPressed: _onGoPressed,
        //                 child: Text("GO"),
        //               ),
        //             ],
        //           ),
        //         ),
        //       ),
      ),
    );
  }
}
