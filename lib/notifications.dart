// Copyright 2017 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.
import 'package:Shrine/services/services.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import 'Bottomnavigationbar.dart';
import 'Image_view.dart';
import 'drawer.dart';
import 'globals.dart';
import 'home.dart';

// This app is a stateful, it tracks the user's current choice.
class Notifications extends StatefulWidget {
  @override
  _Notifications createState() => _Notifications();
}
String _orgName="";
String org_name="";
class _Notifications extends State<Notifications> with SingleTickerProviderStateMixin {
  TabController _controller;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  String fname="";
  String lname="";
  String desination="";
  String profile="";
  int _currentIndex = 1;
  String admin_sts='0';
  String countP='-',countA='-',countL='-',countE='-';
  List<Map<String,String>> chartData;
  void showInSnackBar(String value) {
    final snackBar = SnackBar(
        content: Text(value,textAlign: TextAlign.center,));
    _scaffoldKey.currentState.showSnackBar(snackBar);
  }
  getOrgName() async{
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _orgName= prefs.getString('org_name') ?? '';
    });
/*
    getChartDataToday().then((onValue){
      print('get chart data summary called successfully......');
      setState(() {
        countP=onValue[0]['present'];
        countA=onValue[0]['absent'];
        countL=onValue[0]['late'];
        countE=onValue[0]['early'];
      });
    });
*/
  }
  @override
  void initState() {
    super.initState();
    checkNetForOfflineMode(context);
    appResumedPausedLogic(context);
    initPlatformState();
    _controller = new TabController(length: 4, vsync: this);
    getOrgName();

  }

  openWhatsApp() async{
    //prefix0.facebookChannel.invokeMethod("logContactEvent");
    // print("Language is "+window.locale.countryCode);
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

  initPlatformState() async {
    appResumedPausedLogic(context);
    checkNetForOfflineMode(context);

    final prefs = await SharedPreferences.getInstance();

    setState(() {
      fname = prefs.getString('fname') ?? '';
      lname = prefs.getString('lname') ?? '';
      desination = prefs.getString('desination') ?? '';
      profile = prefs.getString('profile') ?? '';
      org_name = prefs.getString('org_name') ?? '';
      admin_sts = prefs.getString('sstatus') ?? '';
    });
  }
  Future<bool> sendToHome() async{
    /*Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => HomePage()),
    );*/
    print("-------> back button pressed");
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => HomePage()), (Route<dynamic> route) => false,
    );
    return false;
  }
  @override
  Widget build(BuildContext context) {
    return new WillPopScope(
        onWillPop: ()=> sendToHome(),
        child: new Scaffold(
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
            leading: IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: () {
                  Navigator.pop(context);
                }),
            backgroundColor: appcolor,
          ),
          bottomNavigationBar: Bottomnavigationbar(),
          endDrawer: new AppDrawer(),

          body: getWidgets(context),
        )
    );

  }
  getWidgets(context) {
    return new ListView(
      physics: NeverScrollableScrollPhysics(),
      children: <Widget>[
        SizedBox(height:3.0),
        Container(
          padding: EdgeInsets.only(top:12.0,bottom: 2.0),
          child:Center(
            child:Text('Rejected Attendance Log',
                style: new TextStyle(fontSize: 22.0, color: appcolor,)),
          ),
        ),
        Divider(color: Colors.black54,height: 1.5,),



        new Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//            crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(height: 70.0,),
            Container(
              width: MediaQuery.of(context).size.width*0.22,
              child:Text('     Selfie',style: TextStyle(color: appcolor,fontWeight:FontWeight.bold,fontSize: 16.0),),
            ),
            SizedBox(height: 70.0,),
            Container(
              width: MediaQuery.of(context).size.width*0.44,
              child:Text('Event',style: TextStyle(color: appcolor,fontWeight:FontWeight.bold,fontSize: 16.0),),
            ),
            SizedBox(height: 70.0,),
            Container(
              width: MediaQuery.of(context).size.width*0.22,
              child:Text('Reason',style: TextStyle(color: appcolor,fontWeight:FontWeight.bold,fontSize: 16.0),),
            ),
          ],
        ),
        new Divider(height: 1.0,color: Colors.black45,),
        new Container(
            height: MediaQuery.of(context).size.height*0.60,
            child: new FutureBuilder<List<SyncNotification>>(
              future: getNotifications(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  if(snapshot.data.length>0) {
                    return new ListView.builder(
                        scrollDirection: Axis.vertical,
                        itemCount: snapshot.data.length,
                        itemBuilder: (BuildContext context, int index) {
                          return new Column(
                              children: <Widget>[
                                Row(
                                  mainAxisAlignment: MainAxisAlignment
                                      .spaceAround,
                                  children: <Widget>[
                                    SizedBox(height: 40.0,),


                                    Container(
                                        width: MediaQuery
                                            .of(context)
                                            .size
                                            .width * 0.22,
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment
                                              .center,
                                          children: <Widget>[

                                            Container(
                                              width: 62.0,
                                              height: 62.0,
                                              child:InkWell(
                                                child: Container(
                                                    decoration: new BoxDecoration(
                                                        shape: BoxShape
                                                            .circle,
                                                        image: new DecorationImage(
                                                            fit: BoxFit.fill,
                                                            image: new NetworkImage(
                                                                snapshot
                                                                    .data[index]
                                                                    .image)
                                                        )
                                                    )),
                                                onTap: (){
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(builder: (context) => ImageView(myimage: snapshot.data[index].image,org_name: _orgName)),
                                                  );
                                                },
                                              ),),

                                          ],
                                        )

                                    ),
                                    Container(
                                        width: MediaQuery
                                            .of(context)
                                            .size
                                            .width * 0.44,
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Text(snapshot.data[index].Action
                                                .toString()+"\n"+snapshot.data[index].Time.toString()+", "+snapshot.data[index].OfflineMarkedDate.toString() ,style: TextStyle(fontSize: 15.0)),


                                          ],
                                        )

                                    ),

                                    Container(
                                      width: MediaQuery
                                          .of(context)
                                          .size
                                          .width * 0.22,
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: <Widget>[
                                          Text(snapshot.data[index].ReasonForFailure
                                              .toString(), style: TextStyle(
                                            color: Colors.black87,
                                            fontWeight: FontWeight.bold,
                                          ),),

                                          SizedBox(height: 15.0,),


                                        ],
                                      ),
                                    ),
                                  ],

                                ),
                                Divider(color: Colors.black26,),
                              ]);
                        }
                    );
                  }else{

                    return new Container(
                        height: MediaQuery.of(context).size.height*0.30,
                        child:Center(
                          child: Container(
                            width: MediaQuery.of(context).size.width*1,
                            color: appcolor.withOpacity(0.1),
                            padding:EdgeInsets.only(top:5.0,bottom: 5.0),
                            child:Text("No logs found",style: TextStyle(fontSize: 18.0),textAlign: TextAlign.center,),
                          ),
                        )
                    );
                  }
                }
                else if (snapshot.hasError) {
                  return new Center(child:Text("Unable to connect server"));
                }

                // By default, show a loading spinner
                return new Center( child: CircularProgressIndicator());
              },
            )
        ),
      ],
    );

  }
}



