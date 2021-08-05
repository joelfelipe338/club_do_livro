import 'package:flutter/material.dart';

class TextComposer extends StatefulWidget {

  Function enviar;
  TextComposer(this.enviar);

  @override
  _TextComposerState createState() => _TextComposerState();
}

class _TextComposerState extends State<TextComposer> {

  final _textController = new TextEditingController();
  bool _isComposing = false;

  @override
  Widget build(BuildContext context) {

    return Container(
      margin: EdgeInsets.all(5.0),
      decoration: BoxDecoration(
          color: Colors.black45,
          borderRadius: BorderRadius.horizontal(left: Radius.circular(20.0), right: Radius.circular(20.0))
      ),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxHeight: 100.0,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              width: 20.0,
            ),
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                reverse: true,
                child: TextField(
                  style: TextStyle(fontSize: 20.0, color: Colors.white),
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                  controller: _textController,
                  decoration: InputDecoration.collapsed(
                      hintText: "Digite Aqui...",
                      hintStyle: TextStyle(color: Colors.white, fontSize: 20.0)
                  ),
                  onChanged: (text){
                    setState(() {
                      text.isNotEmpty ?
                      _isComposing = true :
                      _isComposing = false;
                    });
                  },
                ),
              ),
            ),
            IconButton(
              icon: Icon(Icons.send, color: Colors.orange,),
              onPressed: _isComposing ? (){
                widget.enviar(_textController.text);
                _textController.text = "";
                setState(() {
                  _isComposing = false;
                });
              }: null,
            )
          ],
        ),
      ),
    );
  }
}