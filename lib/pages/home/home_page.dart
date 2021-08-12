import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:club_do_livro/pages/chatpage/chat_page.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {


  final String userId;

  HomePage({this.userId});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  FirebaseFirestore firestore = FirebaseFirestore.instance;
  List _users = [];
  bool _isLoading = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getUsers();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: (){
        return null;
      },
      child: Scaffold(
        appBar: AppBar(
          leading: Container(),
          title: Text("Listagem"),
          centerTitle: true,
        ),
        body: ListView.builder(
          itemCount: _users.length,
          itemBuilder: (context, index){
            return Container(
              padding: const EdgeInsets.all(2.0),
              child: InkWell(
                onTap: () {
                  _createChatRoom(_users[index]);
                },
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Text(_users[index]["nome"]),
                  ),
                ),
              ),
            );
          },
        )
      ),
    );
  }

  void _createChatRoom(Map<String,dynamic> user) async{
    String chatRoomID = _getChatRoom(widget.userId, user["id"]);
    final chat = await firestore.collection("chatRooms").doc(chatRoomID).get();

    if(chat.data() == null){
      await firestore.collection("chatRooms").doc(chatRoomID).set({
        "chatroomID": chatRoomID,
        "users": [widget.userId, user["id"]]
      });
    }


    Navigator.push(context,
      MaterialPageRoute(builder: (context) => ChatPage(userId: widget.userId,chatRoomID: chatRoomID,userName: user["nome"]))
    );
  }

  String _getChatRoom(String a, String b){
    if(a.substring(0,1).codeUnitAt(0) > b.substring(0,1).codeUnitAt(0)) {
      return "$b\_$a";
    }else{
      return "$a\_$b";
    }
  }

  _getUsers()async{
    setState(() => _isLoading = true);
    firestore
        .collection("users")
        .where("id", isNotEqualTo: widget.userId)
        .get()
        .then((querySnapshot) {

          if(querySnapshot.docs.isEmpty){
            setState(() =>_isLoading = false);
          }
          querySnapshot.docs.forEach((user) {
            setState(() {
              _users.add(user.data());
              _isLoading = false;
            });
          });
    });
  }
}
