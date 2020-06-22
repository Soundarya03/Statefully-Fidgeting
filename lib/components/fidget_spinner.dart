import 'package:audioplayers/audio_cache.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'dart:math' as math;

import 'package:statefully_fidgeting/screens/joinhost.dart';

class FidgetSpinner extends StatefulWidget {
  @override
  _FidgetSpinnerState createState() => _FidgetSpinnerState();
}

class _FidgetSpinnerState extends State<FidgetSpinner>
    with SingleTickerProviderStateMixin {
  AnimationController animController;
  Animation<double> animation;

  @override
  void initState() {
    super.initState();
    animController = AnimationController(
      duration: Duration(seconds: 5),
      vsync: this,
    );

    final curvedAnimation = CurvedAnimation(
      parent: animController,
      curve: Curves.bounceIn,
      reverseCurve: Curves.elasticOut,
    );

    animation =
        Tween<double>(begin: 0, end: 2 * math.pi).animate(curvedAnimation)
          ..addListener(() {
            setState(() {});
          })
          ..addStatusListener((status) {
            if (status == AnimationStatus.completed) {
              animController.reverse();
            } else if (status == AnimationStatus.dismissed) {
              animController.forward();
            }
          });

    animController.forward();
  }

  Future<AudioPlayer> playLocalAsset() async {
    AudioCache cache = new AudioCache();
    return await cache.play("tspt_game_button_04_040.mp3");
  }

  @override
  Widget build(BuildContext context) {
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    String img = 'images/circle-cropped.png';

    return Stack(children: <Widget>[
      Container(
        child: Transform.rotate(
          angle: animation.value,
          child: Container(
            alignment: Alignment.center,
            child: Image.asset(
              img,
              height: 300,
              width: 300,
            ),
          ),
        ),
      ),
      Positioned(
          bottom: 108,
          left: 153,
          child: Transform.rotate(
            angle: 0,
            child: CircleAvatar(
              radius: 42,
              backgroundColor: Colors.lightGreenAccent,
              child: InkWell(
                highlightColor: Colors.green,
                splashColor: Colors.blue,
                borderRadius: BorderRadius.circular(25),
                onTap: () {
                  playLocalAsset();

                  Navigator.push(
                      context,
                      new MaterialPageRoute(
                          builder: (context) => JoinHostChoice()));
                  //playLocalAsset();
                },
                child: Container(
                  padding: EdgeInsets.all(10),
                  height: 50,
                  child: Center(
                    child: Text(
                      "PLAY!",
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w800,
                        fontSize: 20,
                        fontFamily: 'Quicksand',
                      ),
                    ),
                  ),
                ),
              ),
            ),
          )),
    ]);
  }

  @override
  void dispose() {
    animController.dispose();
    super.dispose();
  }
}
