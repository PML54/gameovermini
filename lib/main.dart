import 'dart:async';
import 'dart:html';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gameover/admingame.dart';
import 'package:gameover/adminmemotos.dart';
import 'package:gameover/adminphotos.dart';
import 'package:gameover/admintintin.dart';
import 'package:gameover/adminvideos.dart';
import 'package:gameover/configgamephl.dart';
import 'package:gameover/gamephlclass.dart';
import 'package:gameover/mementoes.dart';
import 'package:gameover/memolike.dart';
import 'package:gameover/sqlphl.dart';
import 'package:gameover/supercatrandom.dart';
import 'package:gameover/supervisorgames.dart';
import 'package:gameover/userconnect.dart';
import 'package:gameover/usercreate.dart';
import 'package:gameover/gamevideo.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

import 'package:dart_ipify/dart_ipify.dart';
import 'phlcommons.dart';
import 'package:intl/intl.dart';
//<PMLV2>
void main() {
  String myurl = Uri.base.toString(); //get complete url
  getParams();
  runApp(const MaterialApp(title: 'Navigation Basics', home: MenoPaul()));
}

void getParams() {
  var uri = Uri.dataFromString(window.location.href);
  Map<String, String> params = uri.queryParameters;
  var origin = params['origin'];
  var destiny = params['destiny'];
}

class MenoPaul extends StatefulWidget {
  const MenoPaul({Key? key}) : super(key: key);

  @override
  State<MenoPaul> createState() => _MenoPaulState();
}

class _MenoPaulState extends State<MenoPaul> {
  ConnectivityResult _connectionStatus = ConnectivityResult.none;
  String dispConnectivity = "";
  String errorMessage = "";
  bool boolMsg = false;
  late String ipv4name;
  String datecreate = "";
  final now = DateTime.now();
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<ConnectivityResult> _connectivitySubscription;
  bool isAdmin = false;
  bool isGamer = false;
  int gameCodeFetched = 0;
  String connectedGuy = "";
  List<MemopolUsers> listMemopolUsers = [];
  GameCommons myPerso = GameCommons("", 0, 0);

  @override
  Widget build(BuildContext context) {
    if (PhlCommons.thatUid > 0) cleanLogins();
    setState(() {});
    SystemChrome.setSystemUIOverlayStyle(
        const SystemUiOverlayStyle(statusBarColor: Colors.transparent
            //color set to transperent or set your own color
            ));
    return Scaffold(
        appBar: AppBar(
          title: Text(
            'lamemopole.com V2.0' + myPerso.myPseudo,
            style: GoogleFonts.averageSans(fontSize: 15.0),
          ),
        ),
        body: SingleChildScrollView(
          child: Container(
            height: 400,
            constraints:
                BoxConstraints(minHeight: MediaQuery.of(context).size.height
                    //set minimum height equal to 100% of VH
                    ),
            width: MediaQuery.of(context).size.width,
            //make width of outer wrapper to 100%
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
                colors: [
                  Colors.orange,
                  Colors.deepOrangeAccent,
                  Colors.red,
                  Colors.redAccent,
                ],
              ),
            ),
            child: Column(
              children: [
                Visibility(
                  visible: isGamer || true,
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: ElevatedButton(
                          child: Text(
                            '-->MULTIJOUEURS',
                            style: GoogleFonts.averageSans(fontSize: 30.0),
                          ),
                          onPressed: () {
                            if (isGamer) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const GameSupervisor(),
                                  settings: RouteSettings(
                                    arguments: myPerso,
                                  ),
                                ),
                              );
                            } else {
                              setState(() {
                                boolMsg = true;
                                errorMessage =
                                    "Vous devez être connecté à un compte pour accéder au multijoueur !";
                              });
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: ElevatedButton(
                        child: Text(
                          '-->RANDOM NORMAL',
                          style: GoogleFonts.averageSans(fontSize: 25.0),
                        ),
                        onPressed: () {
                          setState(() {
                            boolMsg = false;
                            errorMessage = " ";
                          });

                          PhlCommons.random = 1; // Normal
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SuperCatRandom(),
                              settings: RouteSettings(
                                arguments: myPerso,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: ElevatedButton(
                        child: Text(
                          '-->RANDOM FILMS',
                          style: GoogleFonts.averageSans(fontSize: 25.0),
                        ),
                        onPressed: () {
                          setState(() {
                            boolMsg = false;
                            errorMessage = " ";
                          });

                          PhlCommons.random = 2; // Normal
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SuperCatRandom(),
                              settings: RouteSettings(
                                arguments: myPerso,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: ElevatedButton(
                        child: Text(
                          '-->FAVORI',
                          style: GoogleFonts.averageSans(fontSize: 25.0),
                        ),
                        onPressed: () {
                          setState(() {
                            boolMsg = false;
                            errorMessage = " ";
                          });

                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Memolike(),
                              settings: RouteSettings(
                                arguments: myPerso,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
                Visibility(
                  visible: isAdmin,
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: ElevatedButton(
                          child: Text(
                            '-->CLEAN CAPTIONS',
                            style: GoogleFonts.averageSans(fontSize: 25.0),
                          ),
                          onPressed: () {
                            setState(() {});

                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => AdminMemotos(),
                                settings: RouteSettings(
                                  arguments: myPerso,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(25.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Visibility(
                        visible: isAdmin,
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: ElevatedButton(
                            child: Text(
                              'CAPTION',
                              style: GoogleFonts.averageSans(fontSize: 15.0),
                            ),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => Memento(),
                                  settings: RouteSettings(
                                    arguments: myPerso,
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                      Row(
                        children: [
                          Visibility(
                            visible: isAdmin,
                            child: Padding(
                              padding: const EdgeInsets.all(2.0),
                              child: ElevatedButton(
                                child: Text(
                                  'TINTIN',
                                  style:
                                  GoogleFonts.averageSans(fontSize: 10.0),
                                ),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => AdminTintin()),
                                  );
                                },
                              ),
                            ),
                          ),
                          Visibility(
                            visible: isAdmin,
                            child: Padding(
                              padding: const EdgeInsets.all(2.0),
                              child: ElevatedButton(
                                child: Text(
                                  'ADMN',
                                  style:
                                      GoogleFonts.averageSans(fontSize: 10.0),
                                ),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => AdminGame()),
                                  );
                                },
                              ),
                            ),
                          ),
                          Visibility(
                            visible: isAdmin,
                            child: Padding(
                              padding: const EdgeInsets.all(2.0),
                              child: ElevatedButton(
                                child: Text(
                                  'PHOTO',
                                  style:
                                      GoogleFonts.averageSans(fontSize: 10.0),
                                ),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => AdminPhotos()),
                                  );
                                },
                              ),
                            ),
                          ),
                          Visibility(
                            visible: isAdmin,
                            child: Padding(
                              padding: const EdgeInsets.all(2.0),
                              child: ElevatedButton(
                                child: Text(
                                  'VIDEO',
                                  style:
                                      GoogleFonts.averageSans(fontSize: 10.0),
                                ),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => AdminVideos()),
                                  );
                                },
                              ),
                            ),
                          ),

                        ],
                      ),
                      Row(
                        children: [
                          Visibility(
                            visible: !isGamer,
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: ElevatedButton(
                                child: Text(
                                  'CONNEXION',
                                  style: GoogleFonts.averageSans(
                                      fontSize: 15.0, color: Colors.black),
                                ),
                                onPressed: () async {
                                  listMemopolUsers = await (Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => LoginPage()),
                                  ));
                                  setState(() {
                                    connectedGuy = listMemopolUsers[0].uname;
                                    if (listMemopolUsers[0].uprofile & 128 ==
                                        128) {
                                      isAdmin = true;
                                    }
                                    if (listMemopolUsers[0].uprofile & 4 == 4) {
                                      isGamer = true;
                                    }
                                    myPerso.myPseudo =
                                        listMemopolUsers[0].uname;
                                    myPerso.myProfile =
                                        listMemopolUsers[0].uprofile;
                                    myPerso.myUid = listMemopolUsers[0].uid;
                                  });
                                },
                              ),
                            ),
                          ),
                          Visibility(
                            visible: !isGamer,
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: ElevatedButton(
                                child: Text(
                                  'S’enregistrer',
                                  style: GoogleFonts.averageSans(
                                      fontSize: 15.0, color: Colors.black),
                                ),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => CreatePage()),
                                  );
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        bottomNavigationBar: Row(
          children: [
            Visibility(
              visible: boolMsg,
              child: ElevatedButton(
                onPressed: () {
                  setState(() {
                    boolMsg = false;
                  });
                },
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                    textStyle: const TextStyle(
                        fontSize: 14,
                        backgroundColor: Colors.red,
                        fontWeight: FontWeight.bold)),
                child: Text(errorMessage),
              ),
            ),
            Visibility(
              visible: isAdmin,
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: ElevatedButton(
                  child: Text(
                    'Check DATA',
                    style: GoogleFonts.averageSans(fontSize: 15.0),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const SqlPhl()),
                    );
                  },
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: ElevatedButton(
                child: Text(
                  'VIDEO',
                  style: GoogleFonts.averageSans(fontSize: 15.0),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => VideoPlayerScreen(),
                      settings: RouteSettings(
                        arguments: myPerso,
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ));
  }

  Future cleanLogins() async {
    Uri url = Uri.parse(pathPHP + "setGUOFFGAME.php");

    var data = {
      //<TODO>
      "UID": PhlCommons.thatUid.toString(),
    };

    http.Response response = await http.post(url, body: data);

    if (response.body.toString() == 'ERR_1001') {}
  }

  @override
  void dispose() {
    _connectivitySubscription.cancel();
    super.dispose();
  }

  Future<void> initConnectivity() async {
    late ConnectivityResult result;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      result = await _connectivity.checkConnectivity();
    } on PlatformException catch (e) {
      print('Couldn\'t check connectivity status');
      return;
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) {
      return Future.value(null);
    }

    return _updateConnectionStatus(result);
  }

  @override
  void initState() {
    super.initState();

    initConnectivity();
    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);

    setState(() {
      isAdmin = false;
      isGamer = false;

      datecreate = DateFormat('d/M/y').format(now); // 28/03/2020
      ipv4name = "xx.xx.xx.xx";
      getIP();

    });
  }

  Future<void> _updateConnectionStatus(ConnectivityResult result) async {
    setState(() {
      _connectionStatus = result;

      dispConnectivity = "***";

      if (result.toString() == "ConnectivityResult.wifi") {
        dispConnectivity = "Wifi";
      } else {
        dispConnectivity = "***";
      }
    });
  }
  Future whoPlay() async {
    Uri url = Uri.parse(pathPHP + "createMEMOPOLIP.php");
    var data = {


      "UIPTODAY": ipv4name,
      "ULDATE": datecreate,

    };

    bool syntaxOK = true;
    http.Response response = await http.post(url, body: data);
  }
  Future getIP() async {
    final ipv4 = await Ipify.ipv4();
    ipv4name = ipv4;
    whoPlay();
  }

}
