import 'package:flutter/material.dart';
import 'package:statefully_fidgeting/screens/waitingroom.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:audioplayers/audio_cache.dart';
import 'package:audioplayers/audioplayers.dart';

class JoinGamePopup extends StatefulWidget {
  JoinGamePopup({Key key}) : super(key: key);

  @override
  _JoinGamePopupState createState() => _JoinGamePopupState();
}

class _JoinGamePopupState extends State<JoinGamePopup> {
  Future<AudioPlayer> playLocalAsset() async {
    AudioCache cache = new AudioCache();
    return await cache.play("chime_ping.mp3");
  }

  String gameID = '';
  String errorMessage = '';

  showtoast() => Fluttertoast.showToast(
      msg: errorMessage,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.TOP,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.red,
      textColor: Colors.white,
      fontSize: 16.0);
  Future<void> joinRoom(String _uid,String _name) async {
    final response = await http.get(
        'https://game-backend.glitch.me/joinRoom/${_uid}/${_name}');

    if (response.statusCode == 200) {
      print('Joined');
      Navigator.pop(context);
      Navigator.push(
          context,
          new MaterialPageRoute(
              builder: (context) => WaitingRoom(
                    gameId: _uid,
                    isAdmin: false,
                    name: _name,
                    
                  )));
      

    } else if (response.statusCode == 404) {
      setState(() {
        errorMessage = "There is no ongoing game for this GameID";
      });
      showtoast();
      print('Game not found');
    } else if (response.statusCode == 202) {
      setState(() {
        errorMessage =
            "Player with this name already exists, please use a different name or contact the host";
        
      });
      showtoast();
      print("player with this name already exists");
    } else {
      setState(() {
        errorMessage = "Failed to join room";
        
      });
      showtoast();
      throw Exception('Failed join room');
    }
  }

  _displayJoinDialog(BuildContext context) async {
    TextEditingController _idController = TextEditingController();
    TextEditingController _nameController = TextEditingController();
    final _formKey = GlobalKey<FormState>();
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0)),
            title: Text('Enter Room ID and password'),
            content: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  TextFormField(
                    keyboardType: TextInputType.visiblePassword,
                    controller: _nameController,
                    decoration: InputDecoration(
                        hintText: "Enter your name",
                        prefixIcon: Icon(Icons.account_circle)),
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Please enter your name';
                      } else if (value.length < 3) {
                        return 'Your name must be atleast 3 characters long';
                      } else if (value.length > 12) {
                        return 'Too long !';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    keyboardType: TextInputType.visiblePassword,
                    controller: _idController,
                    decoration: InputDecoration(
                        hintText: "Paste Room ID here",
                        prefixIcon: Icon(Icons.confirmation_number)),
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Please enter the room ID';
                      }

                      return null;
                    },
                  ),
                
                
                ],
              ),
            ),
            actions: <Widget>[
              new FlatButton(
                child: new Text('Cancel'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              new FlatButton(
                child: new Text(
                  'Join',
                  style: TextStyle(color: Colors.green),
                ),
                onPressed: () {
                  playLocalAsset();

                  String gameID = _idController.text == ""
                      ? "id"
                      : _idController.text.trim();
                  String name = _nameController.text == ""
                      ? "id"
                      : _nameController.text.trim();
                  if (_formKey.currentState.validate()) {
                    joinRoom(gameID, name);
                  }

                  //Navigator.pop(context);
                },
              )
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(25.0),
      ),
      color: Colors.black,
      child: InkWell(
        highlightColor: Colors.green,
        splashColor: Colors.black,
        borderRadius: BorderRadius.circular(25),
        onTap: () {
          _displayJoinDialog(context);
        },
        child: Container(
          padding: EdgeInsets.all(10),
          height: 60,
          child: Center(
            child: Text(
              "JOIN EXISTING GAME",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
                fontSize: 18,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
