import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:video_player/video_player.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.asset("assets/rain.mp4")
      ..initialize().then((_) {
        _controller.play();
        _controller.setLooping(true);
        // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
        setState(() {});
      });
  }

  // @override
  // void initState() {
  //   super.initState();
  //   // Pointing the video controller to our local asset.
  //   _controller = VideoPlayerController.asset("assets/coffee.mp4")
  //     ..initialize().then((_) {
  //       // Once the video has been loaded we play the video and set looping to true.
  //       _controller.play();
  //       _controller.setLooping(true);
  //       // Ensure the first frame is shown after the video is initialized.
  //       setState(() {});
  //     });
  // }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding:  EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.1, bottom: MediaQuery.of(context).size.height * 0.02,),
        child: Stack(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(vertical: MediaQuery.of(context).size.height * 0.17),
              child: FittedBox(
                // If your background video doesn't look right, try changing the BoxFit property.
                // BoxFit.fill created the look I was going for.
                fit: BoxFit.fill,
                child: SizedBox(
                  width: MediaQuery.of(context).size.width * 1,
                  height: MediaQuery.of(context).size.width * 1,
                  child: VideoPlayer(_controller),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Align(
                alignment: Alignment.topLeft,
                child: Text(
                  "18\u2103",
                  style: GoogleFonts.openSans(
                    fontSize: 64,
                    color: Colors.indigoAccent,
                  ),
                ),
              ),
            ),
            Positioned(
                top: MediaQuery.of(context).size.height * 0.12,
                // left: MediaQuery.of(context).size.height * 0.021,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      "Rainy day",
                      style: GoogleFonts.roboto(
                        fontSize: 18,
                        color: Colors.black45,
                      ),
                    ),
                  ),
                )),
            Padding(
              padding: EdgeInsets.only(
                  top: MediaQuery.of(context).size.height * 0.035,
                  right: MediaQuery.of(context).size.height * 0.021),
              child: Align(
                alignment: Alignment.topRight,
                child: Text(
                  "50%",
                  style: GoogleFonts.roboto(
                    fontSize: 24,
                    color: Colors.black45,
                  ),
                ),
              ),
            ),
            Padding(
                padding: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height * 0.07,
                    right: MediaQuery.of(context).size.height * 0.021),
                child: Align(
                  alignment: Alignment.topRight,
                  child: Text(
                    "9 km/h",
                    style: GoogleFonts.roboto(
                      fontSize: 18,
                      color: Colors.black45,
                    ),
                  ),
                )),
            Padding(
              padding: EdgeInsets.only(
                top: MediaQuery.of(context).size.height * 0.17,
              ),
              child: Align(
                  alignment: Alignment.topCenter,
                  child: Text("Slupsk", style: GoogleFonts.roboto(
                    fontSize: 28,
                    color: Colors.black45,
                  ),)),
            ),
            Padding(
              padding: EdgeInsets.only(
                top: MediaQuery.of(context).size.height * 0.55,
              ),
              child: Align(
                  alignment: Alignment.topCenter,
                  child: Text("Wednesday", style: GoogleFonts.roboto(
                    fontSize: 28,
                    color: Colors.black45,
                  ),)),
            ),
            Padding(
              padding: EdgeInsets.only(
                top: MediaQuery.of(context).size.height * 0.6,
              ),
              child: Align(
                  alignment: Alignment.topCenter,
                  child: Text("08.09.2022", style: GoogleFonts.roboto(
                    fontSize: 14,
                    color: Colors.black45,
                  ),)),
            ),
            Padding(
              padding: EdgeInsets.only(
            top: MediaQuery.of(context).size.height * 0.7),
              child: SingleChildScrollView(

                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 15),
                      child: Column(
                        children: [
                          Text("09.09", style: GoogleFonts.roboto(
                            fontSize: 12,
                            color: Colors.black45,
                          ),),
                          Icon(Icons.sunny, color: Colors.black45, size: 40,),
                          Text("Thursday", style: GoogleFonts.roboto(
                            fontSize: 12,
                            color: Colors.black45,
                          ),),
                          Text("18\u2103", style: GoogleFonts.fredoka(
                            fontSize: 18,
                            color: Colors.black45,
                          ),)
                        ],
                      ),
                    ),

                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 15),
                      child: Column(
                        children: [
                          Text("09.09", style: GoogleFonts.roboto(
                            fontSize: 12,
                            color: Colors.black45,
                          ),),
                          Icon(Icons.sunny, color: Colors.black45, size: 40,),
                          Text("Thursday", style: GoogleFonts.roboto(
                            fontSize: 12,
                            color: Colors.black45,
                          ),),
                          Text("18\u2103", style: GoogleFonts.fredoka(
                            fontSize: 18,
                            color: Colors.black45,
                          ),)
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 15),
                      child: Column(
                        children: [
                          Text("09.09", style: GoogleFonts.roboto(
                            fontSize: 12,
                            color: Colors.black45,
                          ),),
                          Icon(Icons.sunny, color: Colors.black45, size: 40,),
                          Text("Thursday", style: GoogleFonts.roboto(
                            fontSize: 12,
                            color: Colors.black45,
                          ),),
                          Text("18\u2103", style: GoogleFonts.fredoka(
                            fontSize: 18,
                            color: Colors.black45,
                          ),)
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 15),
                      child: Column(
                        children: [
                          Text("09.09", style: GoogleFonts.roboto(
                            fontSize: 12,
                            color: Colors.black45,
                          ),),
                          Icon(Icons.sunny, color: Colors.black45, size: 40,),
                          Text("Thursday", style: GoogleFonts.roboto(
                            fontSize: 12,
                            color: Colors.black45,
                          ),),
                          Text("18\u2103", style: GoogleFonts.fredoka(
                            fontSize: 18,
                            color: Colors.black45,
                          ),)
                        ],
                      ),
                    ),

                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 15),
                      child: Column(
                        children: [
                          Text("09.09", style: GoogleFonts.roboto(
                            fontSize: 12,
                            color: Colors.black45,
                          ),),
                          Icon(Icons.sunny, color: Colors.black45, size: 40,),
                          Text("Thursday", style: GoogleFonts.roboto(
                            fontSize: 12,
                            color: Colors.black45,
                          ),),
                          Text("18\u2103", style: GoogleFonts.fredoka(
                            fontSize: 18,
                            color: Colors.black45,
                          ),)
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
