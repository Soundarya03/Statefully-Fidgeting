import 'package:flutter/material.dart';
import 'package:statefully_fidgeting/screens/joinhost.dart';
import 'package:flutter/services.dart';
import 'package:audioplayers/audio_cache.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:statefully_fidgeting/components/fidget_spinner.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Statefully Fidgeting',
      theme: ThemeData(
        primarySwatch: Colors.grey,
        textTheme: TextTheme(
          subtitle2: TextStyle(
            fontFamily: 'Quicksand',
            fontWeight: FontWeight.w500,
          ),
          subtitle1: TextStyle(
            fontFamily: 'Quicksand',
            fontWeight: FontWeight.w500,
          ),
          bodyText1: TextStyle(
            fontFamily: 'Quicksand',
            fontWeight: FontWeight.w500,
          ),
          bodyText2: TextStyle(
            fontFamily: 'Quicksand',
            fontWeight: FontWeight.w500,
          ),
          button: TextStyle(
            fontFamily: 'Quicksand',
            fontWeight: FontWeight.w700,
          ),
          headline6: TextStyle(
            fontFamily: 'Quicksand',
            fontWeight: FontWeight.w500,
          ),
          headline5: TextStyle(
            fontFamily: 'Quicksand',
            fontWeight: FontWeight.w500,
          ),
          headline4: TextStyle(
            fontFamily: 'Quicksand',
            fontWeight: FontWeight.w500,
          ),
          headline3: TextStyle(
            fontFamily: 'Quicksand',
            fontWeight: FontWeight.w500,
          ),
          headline2: TextStyle(
            fontFamily: 'Quicksand',
            fontWeight: FontWeight.w600,
          ),
          overline: TextStyle(
            fontFamily: 'Quicksand',
            fontWeight: FontWeight.w500,
          ),
          caption: TextStyle(
            fontFamily: 'Quicksand',
            fontWeight: FontWeight.w500,
          ),
          headline1: TextStyle(
            fontFamily: 'Quicksand',
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      darkTheme: ThemeData(
          brightness: Brightness.dark, primarySwatch: Colors.deepOrange),
      home: LandingPageMain(),
    );
  }
}

class LandingPageMain extends StatefulWidget {
  LandingPageMain({Key key}) : super(key: key);

  @override
  _LandingPageMainState createState() => _LandingPageMainState();
}

class _LandingPageMainState extends State<LandingPageMain> {
  Future<AudioPlayer> playLocalAsset() async {
    AudioCache cache = new AudioCache();
    return await cache.play("tspt_game_button_04_040.mp3");
  }

  @override
  Widget build(BuildContext context) {
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    Color dynamiciconcolor = (!isDarkMode) ? Colors.black : Colors.white;
    Color dynamicuicolor = (!isDarkMode) ? Colors.white70 : Colors.black;

    return Scaffold(
      body: Container(
        color: dynamicuicolor,
        // decoration: BoxDecoration(
        //   gradient: LinearGradient(
        //       begin: Alignment.topRight,
        //       end: Alignment.bottomLeft,
        //       colors: [Colors.pink, Colors.yellow]),
        // ),
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            Text(
              "Statefully Fidgeting",
              textAlign: TextAlign.left,
              style: TextStyle(
                shadows: [
                  Shadow(
                    blurRadius: 8.0,
                    color: Colors.lightGreenAccent[700],
                    offset: Offset(5.0, 5.0),
                  ),
                ],
                color: dynamiciconcolor,
                fontSize: 28,
                fontWeight: FontWeight.w600,
                fontFamily: 'Quicksand',
              ),
            ),
            CircleAvatar(
              radius: 50,
              backgroundColor: Colors.lightGreenAccent,
              /*shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(40.0),
              ),*/
              //backgroundcolor: Colors.lightGreenAccent[700],
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
            FidgetSpinner(),
          ],
        ),
      ),
    );
  }
}
