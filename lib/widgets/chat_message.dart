import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class ChatMessage extends StatelessWidget {
  final Map<String, dynamic> data;
  final String userId;
  ChatMessage(this.data, this.userId);

  @override
  Widget build(BuildContext context) {
    return userId == data["userId"] ? _chatBoxUser(context) : _chatBoxOther(context);
  }

  Widget _chatBoxOther(BuildContext context){
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Card(
            elevation: 1,
            color: Colors.deepOrange,
            shape: RoundedRectangleBorder(
                borderRadius:BorderRadius.only(
                    topLeft: Radius.circular(10.0),
                    topRight: Radius.circular(10.0),
                    bottomRight: Radius.circular(10.0)
                )
            ),
            margin: EdgeInsets.symmetric(vertical: 5.0, horizontal: 15.0),
            child:ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width * 0.8,
                  minHeight: 10.0,
                  maxHeight: double.infinity,

                ),
                child: Stack(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(
                        left: 10,
                        right: 50,
                        top: 5,
                        bottom: 14,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Padding(padding: EdgeInsets.symmetric(vertical: 3.0),
                            child: Text(
                              data["usuario"],
                              style: TextStyle(color: Colors.indigo, fontSize: 16.0, fontWeight: FontWeight.bold),
                            ),),
                          Text(data["message"], style: TextStyle(fontSize: 16.0, color: Colors.white),),
                        ],
                      ),
                    ),
                    Positioned(
                        bottom: 6,
                        right: 10,
                        child: Row(
                          children: [
                            Text(data["hours"] ?? "12:12",
                              style: TextStyle(color:Colors.black54, fontSize: 13),
                            )
                          ],
                        ))
                  ],
                )
            )
        )
      ],
    );
  }

  Widget _chatBoxUser(BuildContext context){
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment:  MainAxisAlignment.end,
      children: <Widget>[
        Card(
            elevation: 1,
            color:Colors.orange,
            shape: RoundedRectangleBorder(
                borderRadius:   BorderRadius.only(
                    topLeft: Radius.circular(10.0),
                    topRight: Radius.circular(10.0),
                    bottomLeft: Radius.circular(10.0)
                )
            ),
            margin: EdgeInsets.symmetric(vertical: 5.0, horizontal: 15.0),
            child:ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width * 0.8,
                  minHeight: 10.0,
                  maxHeight: double.infinity,

                ),
                child: Stack(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(
                        left: 10,
                        right: 50,
                        top: 5,
                        bottom: 14,
                      ),
                      child: Column(
                        crossAxisAlignment:  CrossAxisAlignment.end,
                        children: <Widget>[
                          Text(data["message"], style: TextStyle(fontSize: 16.0, color: Colors.white),),
                        ],
                      ),
                    ),
                    Positioned(
                        bottom: 6,
                        right: 10,
                        child: Row(
                          children: [
                            Text(data["hours"],
                              style: TextStyle(color:Colors.black54, fontSize: 13),
                            )
                          ],
                        ))
                  ],
                )
            )
        )
      ],
    );
  }
}