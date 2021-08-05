import 'dart:convert';

import 'package:http/http.dart' as http;

class LoginService {
  login(String email, String senha) async{
    final url = Uri.parse(
        "https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=AIzaSyCvS41_ik5aD1qbNFqJR4kzJGmfeaAqSpk ");
    final responde = await http.post(url,
        body: json.encode(
            {"email": email, "password": senha, "returnSecureToken": true}));
    if(responde.statusCode == 200){
      return json.decode(responde.body);
    }else{
      return null;
    }
  }
}
