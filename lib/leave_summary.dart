// Copyright 2017 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.
import 'package:Shrine/Bottomnavigationbar.dart';
import 'package:Shrine/model/model.dart';
import 'package:Shrine/services/newservices.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import 'drawer.dart';
import 'globals.dart';
import 'home.dart';
import 'leave.dart';
import 'login.dart';
import 'services/services.dart';

// This app is a stateful, it tracks the user's current choice.
class LeaveSummary extends StatefulWidget {
  @override
  _LeaveSummary createState() => _LeaveSummary();
}

class _LeaveSummary extends State<LeaveSummary> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  NewServices ns = new NewServices();
  var profileimage;
  bool _checkLoaded = true;
  int _currentIndex = 1;
  bool _visible = true;
  String location_addr = "";
  String location_addr1 = "";
  String act = "";
  String act1 = "";
  String admin_sts='0';
  int response;
  String fname = "",
      lname = "",
      empid = "",
      email = "",
      status = "",
      orgid = "",
      orgdir = "",
      sstatus = "",
      org_name = "",
      desination = "",
      profile = "",
      latit = "",
      longi = "";
  String lid = "";
  String shiftId = "";
  TextEditingController client_name,comments;
  @override
  void initState() {
    client_name = new TextEditingController();
    comments = new TextEditingController();
    super.initState();
    initPlatformState();
  }
  @override
  // Platform messages are asynchronous, so we initialize in an async method.
  initPlatformState() async {
    appResumedPausedLogic(context);
    final prefs = await SharedPreferences.getInstance();
    empid = prefs.getString('empid') ?? '';
    orgdir = prefs.getString('orgdir') ?? '';
    admin_sts = prefs.getString('sstatus') ?? '0';
    response = prefs.getInt('response') ?? 0;
    if (response == 1) {
     // Loc lock = new Loc();
     // location_addr = await lock.initPlatformState();
      //act =await checkPunch(empid, orgdir);
      //act= 'PunchOut';
      setState(() {
        location_addr1 = location_addr;
        response = prefs.getInt('response') ?? 0;
        fname = prefs.getString('fname') ?? '';
        lname = prefs.getString('lname') ?? '';
        empid = prefs.getString('empid') ?? '';
        email = prefs.getString('email') ?? '';
        status = prefs.getString('status') ?? '';
        orgid = prefs.getString('orgid') ?? '';
        orgdir = prefs.getString('orgdir') ?? '';
        sstatus = prefs.getString('sstatus') ?? '';
        org_name = prefs.getString('org_name') ?? '';
        desination = prefs.getString('desination') ?? '';
        profile = prefs.getString('profile') ?? '';
        lid = prefs.getString('lid') ?? "0";
        act= lid!='0'?'PunchOut':'PunchIn';

        profileimage = new NetworkImage(profile);
        profileimage.resolve(new ImageConfiguration()).addListener((_, __) {
          if (mounted) {
            setState(() {
              _checkLoaded = false;
            });
          }
        });
        latit = prefs.getString('latit') ?? '';
        longi = prefs.getString('longi') ?? '';
        shiftId = prefs.getString('shiftId') ?? "";
        print("this is set state " + lid);
        act1 = act;
      });
    }
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


  withdrawlLeave(String leaveid) async{
    NewServices ns = new NewServices();
    var leave = Leave(leaveid: leaveid, orgid: orgid, uid: empid, approverstatus: '5');
    var islogin = await ns.withdrawLeave(leave);;
    print(islogin);
    if(islogin=="success"){
       Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => LeaveSummary()),
      );
      /*showDialog(context: context, child:
      new AlertDialog(
        title: new Text("Congrats!"),
        content: new Text("Your leave is withdrawl successfully!"),
      )
      );*/
    }else if(islogin=="failure"){
      // ignore: deprecated_member_use
      showDialog(context: context, child:
      new AlertDialog(
        title: new Text("Sorry!"),
        content: new Text("Leave withdrawl failed."),
      )
      );
    }else{
      // ignore: deprecated_member_use
      showDialog(context: context, child:
      new AlertDialog(
        title: new Text("Sorry!"),
        content: new Text("Poor network connection."),
      )
      );
    }
  }

  confirmWithdrawl(String leaveid) async{
    // ignore: deprecated_member_use
    showDialog(context: context, child:
    new AlertDialog(
      title: new Text("Do you really want to withdraw your leave."),
      content:  ButtonBar(
        children: <Widget>[
          FlatButton(
            shape: Border.all(),
            child: Text('CANCEL'),
            onPressed: () {
              Navigator.of(context, rootNavigator: true).pop();
            },
          ),
          RaisedButton(
            child: Text('Withdraw'),
            color: appcolor,
            onPressed: () {
              Navigator.of(context, rootNavigator: true).pop();
              withdrawlLeave(leaveid);
            },
          ),
        ],
      ),
    )
    );
  }

  @override
  Widget build(BuildContext context) {
    return (response == 0) ? new LoginPage() : getmainhomewidget();
  }

  void showInSnackBar(String value) {
    final snackBar = SnackBar(
        content: Text(value, textAlign: TextAlign.center,));
    _scaffoldKey.currentState.showSnackBar(snackBar);
  }

  getmainhomewidget() {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
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
      bottomNavigationBar: Bottomnavigationbar(),

      endDrawer: new AppDrawer(),
      body: (act1 == '') ? Center(child: loader()) : checkalreadylogin(),
      floatingActionButton: new FloatingActionButton(
        onPressed: (){
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => LeavePage()),
          );
        },
        tooltip: 'Request Leave',
        child: new Icon(Icons.add),
      ),
    );
  }

  checkalreadylogin() {
    if (response == 1) {
      return new IndexedStack(
        index: _currentIndex,
        children: <Widget>[
          underdevelopment(),
          mainbodyWidget(),
          underdevelopment()
        ],
      );
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => LoginPage()),
      );
    }
  }

  loader() {/*
    return new Container(
      child: Center(
        child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Image.asset(
                  'assets/spinner.gif', height: 150.0, width: 150.0),
            ]),
      ),
    );*/
  }

  underdevelopment() {
    return new Container(
      child: Center(
        child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Icon(Icons.android, color: appcolor,),
              Text("Under development",
                style: new TextStyle(fontSize: 30.0, color: appcolor),)
            ]),
      ),
    );
  }

  mainbodyWidget() {
    return SafeArea(
      child: ListView(
        children: <Widget>[
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              SizedBox(height: 15.0),
              (act1 == '') ? loader() : getMarkAttendanceWidgit(act1),
              //getMarkAttendanceWidgit(),
            ],
          ),


        ],
      ),

    );
  }

  getMarkAttendanceWidgit(act1) {
    double h_width = MediaQuery.of(context).size.width*0.5; // screen's 50%
    double f_width = MediaQuery.of(context).size.width*1;

//print('==========================='+act1);
    return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Text('Leave History',
              style: new TextStyle(fontSize: 22.0, color: Colors.black54)),
          //SizedBox(height: 10.0),

          new Divider(color: Colors.black54,height: 1.5,),
          new Row(
            mainAxisAlignment: MainAxisAlignment.start,
//            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(height: 50.0,),
              SizedBox(width: MediaQuery.of(context).size.width*0.02),
              Container(
                width: MediaQuery.of(context).size.width*0.30,
                child:Text('Details',style: TextStyle(color: appcolor,fontWeight:FontWeight.bold,fontSize: 16.0),),
              ),

              SizedBox(height: 50.0,),
              Container(
                width: MediaQuery.of(context).size.width*0.22,
                child:Text('From',style: TextStyle(color: appcolor,fontWeight:FontWeight.bold,fontSize: 16.0),),
              ),
              SizedBox(height: 50.0,),
              Container(
                width: MediaQuery.of(context).size.width*0.24,
                child:Text('To',style: TextStyle(color: appcolor,fontWeight:FontWeight.bold,fontSize: 16.0),),
              ),
              Container(
                width: MediaQuery.of(context).size.width*0.22,
                child:Text('Status',style: TextStyle(color: appcolor,fontWeight:FontWeight.bold,fontSize: 16.0),),
              ),
            ],
          ),
          new Divider(),

          new Container(
            height: MediaQuery.of(context).size.height*.60,
            width: MediaQuery.of(context).size.width*.99,
            //padding: EdgeInsets.only(bottom: 15.0),
            color: Colors.white,
            //////////////////////////////////////////////////////////////////////---------------------------------
            child: new FutureBuilder<List<Leave>>(
              future: ns.getLeaveSummary(empid),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                 if (snapshot.data.length>0) {
                   return new ListView.builder(
                       scrollDirection: Axis.vertical,
                       itemCount: snapshot.data.length,
                       itemBuilder: (BuildContext context, int index) {
                         return new Column(
                             crossAxisAlignment: CrossAxisAlignment.start,
                             children: <Widget>[
                               new Row(
                                 crossAxisAlignment: CrossAxisAlignment.start,
                                 mainAxisAlignment: MainAxisAlignment.start,
                                 children: <Widget>[
                                   new Container(
                                       width: MediaQuery
                                           .of(context)
                                           .size
                                           .width * 0.30,
                                       child: Column(
                                         crossAxisAlignment: CrossAxisAlignment
                                             .start,
                                         children: <Widget>[
                                           new SizedBox(width: 5.0,),
                                           new Text(
                                             "Day(s) " +
                                                 snapshot.data[index].leavedays
                                                     .toString(),
                                             style: TextStyle(
                                                 fontWeight: FontWeight.bold),),
                                           (snapshot.data[index].withdrawlsts &&
                                               snapshot.data[index]
                                                   .approverstatus.toString() !=
                                                   'Withdraw' &&
                                               snapshot.data[index]
                                                   .approverstatus.toString() !=
                                                   "Rejected")
                                               ? new Container(
                                               height: 18.5,
                                               child: new FlatButton(
                                                 padding: EdgeInsets.all(1.0),
                                                 color: buttoncolor,
                                                 onPressed: () {
                                                   confirmWithdrawl(
                                                       snapshot.data[index]
                                                           .leaveid.toString());
                                                 },
                                                 child: Text("withdraw"),
                                               )
                                           )
                                               : Center(),
                                         ],
                                       )),

                                   new Container(
                                     width: MediaQuery
                                         .of(context)
                                         .size
                                         .width * 0.22,
                                     child: Text(
                                         snapshot.data[index].leavefrom
                                             .toString(), style: TextStyle(
                                         fontWeight: FontWeight.bold)),
                                   ),
                                   new Container(
                                     width: MediaQuery
                                         .of(context)
                                         .size
                                         .width * 0.22,
                                     child: Text(
                                         snapshot.data[index].leaveto
                                             .toString(), style: TextStyle(
                                         fontWeight: FontWeight.bold)),
                                   ),
                                   Container(
                                     width: MediaQuery
                                         .of(context)
                                         .size
                                         .width * 0.22,
                                     decoration: new ShapeDecoration(
                                       shape: new RoundedRectangleBorder(
                                           borderRadius: new BorderRadius
                                               .circular(2.0)),
                                       color: snapshot.data[index]
                                           .approverstatus.toString() ==
                                           'Approved' ? Colors.green
                                           .withOpacity(0.75) : snapshot
                                           .data[index].approverstatus
                                           .toString() == 'Rejected' ||
                                           snapshot.data[index].approverstatus
                                               .toString() == 'Cancel' ? Colors
                                           .red.withOpacity(0.65) : snapshot
                                           .data[index].approverstatus
                                           .toString().startsWith('Pending')
                                           ? buttoncolor
                                           : Colors.black12,
                                     ),

                                     //color: Colors.black12, // withdrawn
                                     //color: Colors.orangeAccent, // pending
                                     //color: Colors.red.withOpacity(0.65), // rejected,cancel
                                     // color: Colors.green.withOpacity(0.75), // approved
                                     padding: EdgeInsets.only(top: 1.5,
                                         bottom: 1.5,
                                         left: 8.0,
                                         right: 8.0),
                                     margin: EdgeInsets.only(top: 4.0),
                                     child: Text(
                                       snapshot.data[index].approverstatus
                                           .toString(), style: TextStyle(
                                       color: Colors.white, fontSize: 14.0,),
                                       textAlign: TextAlign.center,),
                                   ),
                                   /*  (snapshot.data[index].withdrawlsts && snapshot.data[index].ApprovalSts.toString()!='Withdraw' && snapshot.data[index].ApprovalSts.toString()!="Rejected")?Container(
                                  height: 25.0,
                                  width: 25.0,
                                  child: FittedBox(
                                      child:new  FloatingActionButton(
                                        backgroundColor: Colors.redAccent,
                                        onPressed: () {
                                          confirmWithdrawl(snapshot.data[index].TimeOffId.toString());
                                        },
                                        tooltip: 'Withdraw Timeoff',
                                        child: new Icon(Icons.refresh, size: 40.0,),
                                      )
                                  )
                              ): Container(),*/
                                   //Divider(),
                                 ],
                               ),
                               //SizedBox(width: 30.0,),

                               snapshot.data[index].reason.toString() != '-'
                                   ? Container(
                                 width: MediaQuery
                                     .of(context)
                                     .size
                                     .width * .90,
                                 padding: EdgeInsets.only(
                                     top: 1.5, bottom: 1.5),
                                 margin: EdgeInsets.only(top: 4.0),
                                 child: Text('Reason: ' +
                                     snapshot.data[index].reason.toString(),
                                   style: TextStyle(color: Colors.black54),),
                               )
                                   : Center(),
                               snapshot.data[index].comment.toString() != '-'
                                   ? Container(
                                 width: MediaQuery
                                     .of(context)
                                     .size
                                     .width * .90,
                                 padding: EdgeInsets.only(
                                     top: 1.5, bottom: 1.5),
                                 margin: EdgeInsets.only(top: 4.0),
                                 child: Text('Comment: ' +
                                     snapshot.data[index].comment.toString(),
                                   style: TextStyle(color: Colors.black54),),
                               )
                                   : Center(),

                               Divider(color: Colors.black45,),
                             ]);
                       }
                   );
                 }else
                   return new Center(
                     child: Text('No Leave History'),
                   );
                } else if (snapshot.hasError) {
                  return new Text("Unable to connect server");
                }

                // By default, show a loading spinner
                return new Center( child: CircularProgressIndicator());
              },
            ),
            //////////////////////////////////////////////////////////////////////---------------------------------
          ),

        ]);
  }




  getPunchPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    print('getPunchPrefs called: new lid- '+ prefs.getString('lid').toString());
    return prefs.getString('lid');
  }


/////////////////////futere method dor getting today's punched liist-start

/////////////////////futere method dor getting today's punched liist-close

}


class TimeOff {
  String TimeofDate;
  String TimeFrom;
  String TimeTo;
  String hrs;
  String Reason;
  String ApprovalSts;
  String ApproverComment;

  TimeOff({this.TimeofDate,this.TimeFrom,this.TimeTo,this.hrs,this.Reason,this.ApprovalSts,this.ApproverComment});

}