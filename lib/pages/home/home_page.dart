import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:club_do_livro/pages/chatpage/chat_page.dart';
import 'package:club_do_livro/pages/contatos/contatos.dart';
import 'package:club_do_livro/pages/perfil/perfil_page.dart';
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
  List _usersFilter = [];
  bool _isLoading = false;
  bool _filtroAtivo = true;
  List _filtros = [];

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
          leading: IconButton(
            icon: Icon(Icons.exit_to_app),
            onPressed: (){
              Navigator.popUntil(context, ModalRoute.withName('/'));
            },
          ),
          actions: [
            IconButton(icon: Icon(Icons.person), onPressed: (){
              Navigator.push(context,
                MaterialPageRoute(builder: (context) => PerfilPage(userId: widget.userId,))
              ).then((value){
                _getUsers();
              });
            })
          ],
          backgroundColor: Colors.deepOrange,
          title: Text("Tela principal"),
          centerTitle: true,
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: (){
            Navigator.push(context,
              MaterialPageRoute(builder: (context)=>ContactsPage(userId: widget.userId,))
            );
          },
          tooltip: "Contatos",
          backgroundColor: Colors.deepOrange,
          child: Icon(Icons.message, color: Colors.white,),
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
            )
                : Column(
              children: [
                Row(
                  children: [
                    Padding(
                        padding: const EdgeInsets.only(left: 10.0),
                        child: Icon(
                          Icons.filter_list_alt,
                          size: 20.0,color: Colors.white,
                        )),
                    Expanded(
                      child: SingleChildScrollView(
                        physics: BouncingScrollPhysics(),
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: List.generate(_filtros.length, (index){
                            return chipCustom(_filtros[index]);
                          }),
                        ),
                      ),
                    )
                  ],
                ),
                (_filtroAtivo ? _usersFilter.isEmpty : _users.isEmpty) ? Center(child: Text("Nenhum usuario encontrado",
                  style: TextStyle(color: Colors.white),
                ),) :
                Expanded(child: ListView.builder(
                  itemCount: _filtroAtivo ? _usersFilter.length : _users.length,
                  itemBuilder: (context, index){
                    return Container(
                      padding: const EdgeInsets.all(2.0),
                      child: InkWell(
                        onTap: () {
                          _createChatRoom(_filtroAtivo ? _usersFilter[index] : _users[index]);
                        },
                        child: _userCard(_filtroAtivo ? _usersFilter[index] : _users[index])
                      ),
                    );
                  },
                )
                )
              ],
            )

          ],
        )

      ),
    );
  }

  Widget _userCard(Map<String, dynamic> user){
    return Card(
      color: Colors.deepOrange,
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("${user["nome"]} ${user["sobrenome"]} - ${user["idade"]} anos", style: TextStyle(color: Colors.white),),
            SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              scrollDirection: Axis.horizontal,
              child: Row(
                children: List.generate(user["categorias"].length, (index){
                  if(user["categorias"][index]["ativo"]){
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(user["categorias"][index]["nome"], style: TextStyle(color: Colors.yellow, fontSize: 14, decoration: TextDecoration.underline),),
                    );
                  }else{
                    return Container();
                  }
                }),
              ),
            )
          ],
        ),
      )
    );
  }

  Widget chipCustom(Map<String, dynamic> item) {
    return Padding(
      padding: EdgeInsets.all(5.0),
      child: GestureDetector(
        child: Chip(
          elevation: item["ativo"] ? 5 : 0,
          backgroundColor: item["ativo"]
              ? Colors.deepOrange
              : Colors.amber,
          label: Text(
            item["nome"],
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
        onTap: () {
          setState(() {
            item["ativo"] = !item["ativo"];

            _filtroAtivo = _filtros.any((data) => data["ativo"]);
            if (!_filtroAtivo) {
              _usersFilter = [];
            } else {
              _filtrar();
            }
          });
        },
      ),
    );
  }

  void _filtrar(){

    _usersFilter = [];
    bool encontrou = false;
    var filtrosAtivos = [];

    _filtros.forEach((filtro) {
      if(filtro["ativo"]) {
        filtrosAtivos.add(filtro["nome"]);
      }
    });

    setState(() {
      _usersFilter = _users.where((data) {
        print("oiss");
        encontrou = false;
        filtrosAtivos.forEach((element) {
          if((data["categorias"].any((categoria){
            return ((categoria["nome"] == element) && categoria["ativo"]);
          }))){
            encontrou = true;
          }
        });
        return encontrou;

      }).toList();
    });
  }

  void _createChatRoom(Map<String,dynamic> user) async{
    String chatRoomID = _getChatRoom(widget.userId, user["id"]);
    final chat = await firestore.collection("chatRooms").doc(chatRoomID).get();

    if(chat.data() == null){
      await firestore.collection("chatRooms").doc(chatRoomID).set({
        "chatroomID": chatRoomID,
        "users": [widget.userId, user["id"]],
        "ultima_mensagem": "",
        "horario_ultima_mensagem": "",
        "time": DateTime.now().millisecondsSinceEpoch,
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
    _users = [];
    setState(() => _isLoading = true);
    firestore
        .collection("users")
        .get()
        .then((querySnapshot) {

          if(querySnapshot.docs.isEmpty){
            setState(() =>_isLoading = false);
          }
          querySnapshot.docs.forEach((user) {
            if(user.data()["id"] == widget.userId){
              _filtros = user.data()["categorias"];
            }else{
              setState(() {

                _users.add(user.data());
                _isLoading = false;
              });
            }
            print("oalalsdaksfdnf");
            print(user.data()["categorias"]);
            print(user.data());

          });
    });
    await Future.delayed(Duration(seconds: 2));
    _filtrar();

  }
}
