import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:club_do_livro/pages/chatpage/chat_page.dart';
import 'package:flutter/material.dart';

class ContactsPage extends StatefulWidget {


  final String userId;

  ContactsPage({this.userId});

  @override
  _ContactsPageState createState() => _ContactsPageState();
}

class _ContactsPageState extends State<ContactsPage> {

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
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.deepOrange,
          title: Text("Contatos"),
          centerTitle: true,
        ),
        body: Stack(
          children: [
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
            _isLoading ? Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            ):StreamBuilder<QuerySnapshot>(
              stream:firestore.collection("chatRooms").where("users", arrayContains: widget.userId).orderBy("time").snapshots(),

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
                      itemCount: _users.length,
                      itemBuilder: (context, index){
                        return Container(
                            padding: const EdgeInsets.all(2.0),
                            child: userCard(_users[index], documents[index].data())
                        );
                      },
                    );
                }
              },
            ),


          ],
        )

    );
  }

  Widget userCard(Map<String, dynamic> user, Map<String, dynamic> chats){

    return InkWell(
      onTap: () {
        _irParaChatRoom(user);
      },
      child: Card(
        color: Colors.transparent,
        elevation: 0,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              CircleAvatar(
                backgroundColor: Colors.transparent,
                radius: 26,
                backgroundImage: AssetImage('assets/perfil.jpg')
              ),
              SizedBox(width: 10,),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(user["nome"],
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                      fontWeight: FontWeight.bold
                    ),
                  ),
                  SizedBox(height: 5,),
                  Container(
                    width: 200,
                    child: Text(chats["ultima_mensagem"] ?? "",
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          fontSize: 14,
                          color: Colors.white60,
                      ),
                    ),
                  )
                ],
              ),
              Spacer(),
              Center(
                child: Text(chats["horario_ultima_mensagem"] ?? "",
                  style: TextStyle(
                    color: Colors.white,
                  ),),
              )
            ],
          ),
        )
      ),
    );
  }

  void _irParaChatRoom(Map<String,dynamic> user) async{
    String chatRoomID = _getChatRoom(widget.userId, user["id"]);

    Navigator.push(context,
        MaterialPageRoute(builder: (context) => ChatPage(userId: widget.userId,chatRoomID: chatRoomID,userName: user["nome"]))
    ).whenComplete(() => _getUsers());
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
    String ID;
    List<String> IDs = [];
    _users = [];
    firestore
        .collection("chatRooms")
        .where("users", arrayContains: widget.userId).orderBy("time")
        .get()
        .then((querySnapshot) {
      if(querySnapshot.docs.isEmpty){
        setState(() =>_isLoading = false);
      }
      querySnapshot.docs.forEach((doc){

        doc.data()["users"][0] == widget.userId
            ? ID = doc.data()["users"][1]
            : ID = doc.data()["users"][0];
        IDs.add(ID);

      });
      print(IDs);
      Future.forEach(IDs,(id) async{
        print(id);
        await firestore.collection("users").doc(id).get().then((user) {
          print("dsssssssssss");
          print(user["nome"]);

            _users.add(user.data());

        });

      }).then((value)=>setState((){
        _isLoading = false;
        _users = _users.reversed.toList();
      }));


    });

  }
}
