import 'package:flutter/material.dart';
import 'package:random_string/random_string.dart';
import 'package:statefully_fidgeting/screens/waitingroom.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:audioplayers/audio_cache.dart';
import 'package:audioplayers/audioplayers.dart';

class HostGamePopup extends StatefulWidget {
  HostGamePopup({Key key}) : super(key: key);

  @override
  _HostGamePopupState createState() => _HostGamePopupState();
}

class _HostGamePopupState extends State<HostGamePopup> {
  Future<AudioPlayer> playLocalAsset() async {
    AudioCache cache = new AudioCache();
    return await cache.play("chime_ping.mp3");
  }
  Future<int> createRoom(String _uid, String _name) async {
    final response = await http.get(
        'https://game-backend.glitch.me/createRoom/${_uid}/${_name}');

    if (response.statusCode == 200) {
      print('Room created');

      Navigator.pop(context);
      Navigator.push(
          context,
          new MaterialPageRoute(
              builder: (context) => WaitingRoom(
                    gameId: _uid,
                    isAdmin: true,
                    name: _name,

                  )));
      return 200;
    } else if (response.statusCode == 400) {
      return 400;
    } else {
      throw Exception('Failed create room');
    }
  }

  _displayCreateDialog(BuildContext context) async {
    final String gameID = randomNumeric(8);
    TextEditingController _nameController = TextEditingController();
    final _formKey = GlobalKey<FormState>();
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0)),
            title: Text('Do you want to host a game?'),
            content: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[

                  TextFormField(
                    keyboardType: TextInputType.visiblePassword,
                    controller: _nameController,
                    decoration: InputDecoration(
                        hintText: "Your Name",
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
                  Text('Room ID : $gameID'),
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
                  'Host',
                  style: TextStyle(color: Colors.green),
                ),
                onPressed: () {
                  playLocalAsset();
                  String name = _nameController.text == ""
                      ? "id"
                      : _nameController.text.trim();
                  if (_formKey.currentState.validate()) {
                    createRoom(gameID, name);
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
        splashColor: Colors.blue,
        borderRadius: BorderRadius.circular(25),
        onTap: () {
          _displayCreateDialog(context);
        },
        child: Container(
          padding: EdgeInsets.all(10),
          height: 50,
          child: Center(
            child: Text(
              "HOST A NEW GAME",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
                fontSize: 17,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
