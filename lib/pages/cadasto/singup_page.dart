import 'package:club_do_livro/pages/cadasto/signup_service.dart';
import 'package:club_do_livro/widgets/custom_button.dart';
import 'package:club_do_livro/widgets/custom_input.dart';
import 'package:club_do_livro/widgets/custom_snack.dart';
import 'package:flutter/material.dart';

class SignupPage extends StatefulWidget {
  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {

  final _emailController = TextEditingController();
  final _senhaController = TextEditingController();
  final _resenhaController = TextEditingController();
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
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Padding(
                  padding: const EdgeInsets.all(40.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Cadastro", style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),),
                      CustomInput(controller: _emailController,name: "E-mail",icon: Icons.email_outlined,),
                      CustomInput(controller: _senhaController,name: "Senha",icon: Icons.vpn_key,obscure: true,validacao: (value){
                        if(value != _resenhaController.text ){
                          return "senhas não coincidem";
                        }else if(value.isEmpty){
                          return "Campo obrigatorio";
                        }else{
                          return null;
                        }
                      }),
                      CustomInput(controller: _resenhaController,name: "Confirme a senha",icon: Icons.vpn_key,obscure: true,validacao: (value){
                        if(value != _senhaController.text ){
                          return "senhas não coincidem";
                        }else if(value.isEmpty){
                          return "Campo obrigatorio";
                        }else{
                          return null;
                        }
                      },),
                      SizedBox(height: 20,),
                      CustomButton(Colors.white, Colors.deepOrange,_signup,
                          _isLoading ? SizedBox(
                        height: 14.0,
                        width: 14.0,
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.deepOrange),
                        ),
                      ):Text("Cadastra-se"),),

                    ],
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  _signup() async{
    if(_formKey.currentState.validate()){
      _formKey.currentState.save();
      setState(()=> _isLoading = true);
      final response = await SignUpService().signUp(_emailController.text, _senhaController.text);
      print(response);
      if(response) {
        Navigator.pop(context);
      }else{
        ScaffoldMessenger.of(context).showSnackBar(snack("Algum erro ocorreu", Colors.red, 1));
      }
      setState(()=> _isLoading = false);
    }
  }
}
