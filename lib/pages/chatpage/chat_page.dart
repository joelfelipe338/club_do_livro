import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:club_do_livro/widgets/chat_message.dart';
import 'package:club_do_livro/widgets/text_composer.dart';
import 'package:flutter/material.dart';

class ChatPage extends StatefulWidget {

  final String userId;
  final String chatRoomID;
  final String userName;

  ChatPage({this.userId, this.chatRoomID, this.userName = ""});

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {

  FirebaseFirestore firestore = FirebaseFirestore.instance;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepOrange,
        title:  Text(widget.userName),
        centerTitle: true,
      ),
      body: Stack(
        children: <Widget>[
          Container(
            height: double.infinity,
            decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                  colors: [
                    Colors.deepOrange,
                    Colors.yellow,
                  ],
                )
            ),
          ),
          Column(
            children: <Widget>[
              Expanded(
                child:StreamBuilder<QuerySnapshot>(
                  stream:firestore.collection("chatRooms").doc(widget.chatRoomID).collection("chats").orderBy("time").snapshots(),
                  builder: (context, snapshot){
                    switch(snapshot.connectionState){

                      case ConnectionState.none:
                      case ConnectionState.waiting:
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      default:
                        List<DocumentSnapshot> documents =
                        snapshot.data.docs.reversed.toList();

                        return ListView.builder(
                          itemCount: documents.length,
                          reverse: true,
                          itemBuilder: (context, index) {
                            print(documents[index].data());
                            return ChatMessage(documents[index].data() as Map<String,dynamic>, widget.userId);
                          },
                        );
                    }
                  },
                ),
              ),
              TextComposer(_enviar)
            ],
          ),
        ],
      ),
    );
  }

  void _enviar(String text) async {
    String message = text;
    final user = await FirebaseFirestore.instance.collection("users").doc(widget.userId).get();

    String hora = DateTime.now().hour < 10 ?
    DateTime.now().hour.toString() + "0:" :
    DateTime.now().hour.toString() ;
    String minuto = DateTime.now().minute < 10 ? DateTime.now().minute.toString() + "0": DateTime.now().minute.toString();
    String hora_atual = hora + ":" + minuto;

    firestore.collection("chatRooms").doc(widget.chatRoomID).collection("chats").add({

      "message": message,
      "usuario": user["nome"],
      "userId": user["id"],
      "time" : DateTime.now().millisecondsSinceEpoch,
      "hours": hora_atual,

    }).then((value) async{
      var t = await value.parent.get();
      print("sss");
      print(t.docs.length);
    });
  }

}
