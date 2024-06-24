// import 'package:app/pages/chat/prueba_user.dart';
// import 'package:flutter/material.dart';
// import 'package:stream_chat_flutter/stream_chat_flutter.dart';

// class MainChatAppStream extends StatefulWidget {
//   @override
//   _MainChatAppStreamState createState() => _MainChatAppStreamState();
// }

// class _MainChatAppStreamState extends State<MainChatAppStream> {
//   late StreamChatClient _client;

//   @override
//   void initState() {
//     super.initState();
//     _client = StreamChatClient(
//       'f928e44z79ds',
//       logLevel: Level.INFO,
//     );
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       theme: ThemeData.light(),
//       builder: (context, child) {
//         return StreamChat(
//           client: _client,
//           child: child,
//         );
//       },
//       home: HomeChat(),
//     );
//   }
// }
