import 'package:club_do_livro/pages/cadasto/singup_page.dart';
import 'package:club_do_livro/pages/login/login_service.dart';
import 'package:club_do_livro/pages/perfil/perfil_page.dart';
import 'package:club_do_livro/widgets/custom_button.dart';
import 'package:club_do_livro/widgets/custom_input.dart';
import 'package:club_do_livro/widgets/custom_snack.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {


  final _emailController = TextEditingController();
  final _senhaController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
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
                padding: const EdgeInsets.all(40.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Clube do Livro", style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),),
                    CustomInput(controller: _emailController,name: "E-mail",icon: Icons.email_outlined,),
                    CustomInput(controller: _senhaController,name: "Senha",icon: Icons.vpn_key,obscure: true,),
                    SizedBox(height: 20,),
                    CustomButton(Colors.deepOrange, Colors.white,_login,
                        _isLoading ? SizedBox(
                      height: 14.0,
                      width: 14.0,
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    ):Text("Login"),),
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 35),
                      child: Divider(color: Colors.white,),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text("Ainda não tem uma conta", style: TextStyle(color: Colors.white, fontSize: 16),),
                    ),
                    CustomButton(Colors.white, Colors.deepOrange,(){
                      Navigator.push(context,
                        MaterialPageRoute(builder: (context) => SignupPage())
                      );
                    },Text("Cadastra-se"),),

                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  _login() async{
    print("oi");
    if(_formKey.currentState!.validate()){
      _formKey.currentState!.save();
      setState(()=> _isLoading = true);
      final response = await LoginService().login(_emailController.text, _senhaController.text);
      print(response);
      if(response) {
        Navigator.push(context,
          MaterialPageRoute(builder: (context) => PerfilPage())
        );
      }else{
        ScaffoldMessenger.of(context).showSnackBar(snack("Email ou Senha incorretos", Colors.red, 1));
      }
      setState(()=> _isLoading = false);
    }
  }
}