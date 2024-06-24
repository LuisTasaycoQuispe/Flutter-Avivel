// import 'package:app/pages/chat/data_utils.dart';
// import 'package:flutter/material.dart';
// import 'package:stream_chat_flutter/stream_chat_flutter.dart';

// class FriendsChat extends StatefulWidget {
//   @override
//   _FriendsChatState createState() => _FriendsChatState();
// }

// class _FriendsChatState extends State<FriendsChat> {
//   Future<void> _onCreateChannel() async {
//     final result = await showDialog(
//       context: context,
//       builder: (context) {
//         final channelController = TextEditingController();
//         return AlertDialog(
//           title: Text('Create Channel'),
//           content: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               TextField(
//                 controller: channelController,
//                 decoration: InputDecoration(
//                   hintText: 'Channel Name',
//                 ),
//               ),
//               ElevatedButton(
//                 onPressed: () =>
//                     Navigator.of(context).pop(channelController.text),
//                 child: Text("GO"),
//               ),
//             ],
//           ),
//         );
//       },
//     );
//     if (result != null) {
//       final client = StreamChat.of(context).client;
//       final channel = client.channel('messaging', id: result, extraData: {
//         'image': DataUtils.getChannelImage(),
//       });
//       await channel.create();
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       floatingActionButton: FloatingActionButton.extended(
//         onPressed: _onCreateChannel,
//         label: Text("Create"),
//       ),
//       appBar: AppBar(
//         title: Text("Public Chat"),
//       ),
//       body: ChannelsBloc(
//         key: _keyChannels,
//         child: ChannelListView(
//           channelWidget: ChannelPage(),
//         ),
//       ),
//     );
//   }


// }

// class ChannelPage extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: const StreamChannelHeader(),
//       body: Column(
//         children: [
//           Expanded(
//             child: StreamMessageListView(),
//           ),
//           StreamMessageInput(),
//         ],
//       ),
//     );
//   }
// }
