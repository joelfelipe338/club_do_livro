import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:club_do_livro/pages/home/home_page.dart';
import 'package:club_do_livro/widgets/custom_button.dart';
import 'package:club_do_livro/widgets/custom_input.dart';
import 'package:flutter/material.dart';

class PerfilPage extends StatefulWidget {

  final String? userId;

  PerfilPage({this.userId});

  @override
  _PerfilPageState createState() => _PerfilPageState();
}

class _PerfilPageState extends State<PerfilPage> {

  final _formKey = GlobalKey<FormState>();
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final _nomeController = TextEditingController();
  final _sobrenomeController = TextEditingController();
  final _idadeController = TextEditingController();
  List _categories = [
    {
      "nome": "Fantasia",
      "ativo": false,
    },
    {
      "nome": "Comedia",
      "ativo": false,
    },
    {
      "nome": "Romance",
      "ativo": false,
    },
    {
      "nome": "Terror",
      "ativo": false,
    },
    {
      "nome": "Suspense",
      "ativo": false,
    },
    {
      "nome": "Video-game",
      "ativo": false,
    },
    {
      "nome": "Sobrevivência",
      "ativo": false,
    },
    {
      "nome": "Drama",
      "ativo": false,
    },
    {
      "nome": "Infantil",
      "ativo": false,
    },
    {
      "nome": "Aventura",
      "ativo": false,
    },
    {
      "nome": "Futuristico",
      "ativo": false,
    },
    {
      "nome": "Outro",
      "ativo": false,
    },
  ];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getUser();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: (){
        return Future.value(false);
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.deepOrange,
          title: Text("Perfil"),
          centerTitle: true,
          leading: Container(),
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
            Center(
              child: Form(
                key: _formKey,
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CustomInput(controller: _nomeController,name: "Nome",icon: Icons.person,),
                      CustomInput(controller: _sobrenomeController,name: "Sobrenome",icon: Icons.person,),
                      CustomInput(controller: _idadeController,name: "Idade",icon: Icons.person),
                      SizedBox(height: 20,),
                      Text("Gêneros preferidos", style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),),
                      Expanded(
                        child: GridView.count(
                          crossAxisCount: 2,
                          childAspectRatio: 5,
                          children: List.generate(_categories.length, (index) {
                            return Center(
                              child: CheckboxListTile(
                                title: Text(_categories[index]["nome"], style: TextStyle(color: Colors.white, fontSize: 14),),
                                value: _categories[index]["ativo"],
                                activeColor: Colors.deepOrange,
                                onChanged: (value){
                                  setState(() {
                                    _categories[index]["ativo"] = value;
                                  });
                              },)
                            );
                          }),
                        ),
                      ),
                      CustomButton(Colors.deepOrange, Colors.white, _saveUser,Text("Salvar dados")),
                  ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  void _saveUser() async {
    if (_formKey.currentState!.validate()) {

      _formKey.currentState!.save();

      FirebaseFirestore.instance.collection("users").doc(widget.userId).update({
        "ativo": true,
        "nome": _nomeController.text,
        "idade": _idadeController.text,
        "sobrenome": _sobrenomeController.text,
        "categorias": _categories,
      });

      Navigator.push(context,
          MaterialPageRoute(builder: (context) => HomePage(userId: widget.userId,))
      );
    }
  }

  void _getUser() async{

    final user = await firestore.collection("users").doc(widget.userId).get();
    if(user.exists){
      _nomeController.text = user.data()?["nome"];
      _sobrenomeController.text = user.data()?["sobrenome"];
      _idadeController.text = user.data()?["idade"];
      setState(() {
        _categories = user.data()?["categorias"];
      });
    }else{
      await FirebaseFirestore.instance.collection("users").doc(widget.userId).set({
        "id": widget.userId,
        "ativo": false,
        "nome": "",
        "idade": "",
        "sobrenome": "",
        "categorias": _categories}
      );
    }
  }
}
