import 'dart:convert';

import 'package:http/http.dart' as http;

class SignUpService {
  signUp(String email, String senha) async{
    final url = Uri.parse(
        "https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=AIzaSyCvS41_ik5aD1qbNFqJR4kzJGmfeaAqSpk ");
    final responde = await http.post(url,
        body: json.encode(
            {"email": email, "password": senha, "returnSecureToken": true}));
    print(responde.body);
    if(responde.statusCode == 200){
      return true;
    }else{
      return false;
    }

  }
}
