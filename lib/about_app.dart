import 'dart:ui';

import 'package:Shrine/services/services.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import 'drawer.dart';
import 'globals.dart';
import 'home.dart';



void main() => runApp(new AboutApp());

class AboutApp extends StatefulWidget {
  @override
  _AboutApp createState() => _AboutApp();
}

class _AboutApp extends State<AboutApp> {
  String fname="";
  String lname="";
  String desination="";
  String profile="";
  String org_name="";
  bool _isButtonDisabled = false;
  String admin_sts='0';
  String buystatus = "";
  String new_ver='3.1.9';
  TextEditingController textsms = new TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  initPlatformState() async {
    final prefs = await SharedPreferences.getInstance();
    checkNow().then((res){
      setState(() {
        new_ver=res;
        print("new_ver");
        print(new_ver);
      });
    });
    setState(() {
      admin_sts = prefs.getString('sstatus').toString();
      buystatus = prefs.getString('buysts') ?? '';
      fname = prefs.getString('fname') ?? '';
      lname = prefs.getString('lname') ?? '';
      desination = prefs.getString('desination') ?? '';
      profile = prefs.getString('profile') ?? '';
      org_name = prefs.getString('org_name') ?? '';
      // _animatedHeight = 0.0;
    });
  }

  openWhatsApp() async{
    //prefix0.facebookChannel.invokeMethod("logContactEvent");
    print("Language is "+window.locale.countryCode);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var name=prefs.getString("fname")??"";
    var org_name= prefs.getString('org_name') ?? '';
    var country = prefs.getString("org_country")??"";
    //  String country=window.locale.countryCode;
    var message;

    message="Hello%20I%20am%20"+name+"%20from%20"+org_name+"%0AI%20need%20some%20help%20regarding%20ubiAttendance%20app";

    var url;
    if(country=="93")
      url = "https://wa.me/916264345459?text="+message;
    else{
      url = "https://wa.me/971555524131?text="+message;
    }
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch Maps';
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        key: _scaffoldKey,
        backgroundColor: Colors.white,
        appBar: new AppBar(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              new Text(org_name, style: new TextStyle(fontSize: 20.0)),
              admin_sts == '1' || admin_sts == '2'? new IconButton(
                icon: new Image.asset('assets/whatsapp.png', height: 25.0, width: 25.0),
                onPressed: () => openWhatsApp(),
              ):Container(),
            ],
          ),
          leading: IconButton(icon:Icon(Icons.arrow_back),onPressed:(){
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => HomePage()),
            );
          },),
          backgroundColor: appcolor,
        ),
        endDrawer: new AppDrawer(),
        body: userWidget()
    );
  }

  userWidget(){
    return ListView(
      children: <Widget>[
        Container(
          margin: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(height: 60,),
              Center(
                child:Text(
                    "ubiAttendance",
                    style: new TextStyle(
                        fontSize: 32.0,
                        color:appcolor,
                      fontWeight: FontWeight.w600
                    )
                ),
              ),
              SizedBox(height: 15,),
              Center(
                child: Text(
                  'Installed Version '+appVersion,
                  style: TextStyle(
                    fontSize: 16.0,
                  ),
                ),
              ),
              SizedBox(height: 10,),
              Center(
                child: new_ver!=appVersion?Text(
                  'This is not the latest version of ubiattendance.',
                  style: TextStyle(
                    fontSize: 16.0,
                  ),
                ):Text(
                  'The latest version is already installed.',
                  style: TextStyle(
                    fontSize: 16.0,
                  ),
                )
              ),
            ],
          ),

        ),
      ],
    );
  }
}