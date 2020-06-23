// Copyright 2017 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:Shrine/Bottomnavigationbar.dart';
import 'package:Shrine/model/model.dart' as TimeOffModal;
import 'package:Shrine/services/gethome.dart';
import 'package:Shrine/services/newservices.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import 'drawer.dart';
import 'globals.dart';
import 'login.dart';
import 'timeoff_summary.dart';
// This app is a stateful, it tracks the user's current choice.
class PaymentPage extends StatefulWidget {
  @override
  _PaymentPageState createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  bool isloading = false;
  final _dateController = TextEditingController();
  final _starttimeController = TextEditingController();
  final _endtimeController = TextEditingController();
  final _reasonController = TextEditingController();
  TimeOfDay starttime;
  TimeOfDay endtime;
  FocusNode textSecondFocusNode = new FocusNode();
  FocusNode textthirdFocusNode = new FocusNode();
  FocusNode textfourthFocusNode = new FocusNode();
  final dateFormat = DateFormat("EEEE, MMMM d, yyyy");
  final timeFormat = DateFormat("H:mm");
  final _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  var _defaultimage = new NetworkImage(
      "http://ubiattendance.ubihrm.com/assets/img/avatar.png");
  var profileimage;
  bool _checkLoaded = true;
  bool _isButtonDisabled=false;
  int _currentIndex = 1;
  bool _visible = true;
  String location_addr="";
  String location_addr1="";
  String buystatus="";
  String trialstatus="";
  String orgmail="";
  String admin_sts='0';
  String act="";
  String act1="";
  int response;
  String fname="", lname="", empid="", email="", status="", orgid="", orgdir="", sstatus="", org_name="", desination="", profile,latit="",longi="";
  String aid="";
  String shiftId="";
  @override
  void initState() {
    super.initState();
    initPlatformState();
  }
  // Platform messages are asynchronous, so we initialize in an async method.
  initPlatformState() async {
    final prefs = await SharedPreferences.getInstance();
    empid = prefs.getString('empid') ?? '';
    orgdir = prefs.getString('orgdir') ?? '';
    response = prefs.getInt('response') ?? 0;
    if(response==1) {
     // Loc lock = new Loc();
    // location_addr = await lock.initPlatformState();

      Home ho = new Home();
      act = await ho.checkTimeIn(empid, orgdir,context);

      print("this is main "+location_addr);
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
        buystatus = prefs.getString('buysts') ?? '';
        trialstatus = prefs.getString('trialstatus') ?? '';
        orgmail = prefs.getString('orgmail') ?? '';

        profileimage = new NetworkImage(profile);
        print("1-"+profile);
        _checkLoaded = false;
        /*profileimage.resolve(new ImageConfiguration()).addListener((_, __) {
          if (mounted) {
            setState(() {
              _checkLoaded = false;
            });
          }
        });*/
        print("2-"+_checkLoaded.toString());
        latit = prefs.getString('latit') ?? '';
        longi = prefs.getString('longi') ?? '';
        aid = prefs.getString('aid') ?? "";
        shiftId = prefs.getString('shiftId') ?? "";
        print("this is set state "+location_addr1);
        act1=act;
        print(act1);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return (response==0) ? new LoginPage() : getmainhomewidget();
  }

  void showInSnackBar(String value) {
    final snackBar = SnackBar(
        content: Text(value,textAlign: TextAlign.center,));
    _scaffoldKey.currentState.showSnackBar(snackBar);
  }

  getmainhomewidget(){
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            new Text(org_name, style: new TextStyle(fontSize: 20.0)),
          ],
        ),
        leading: IconButton(icon:Icon(Icons.arrow_back),onPressed:(){
          Navigator.of(context).pop();
        },),
        backgroundColor: appcolor,
      ),
      bottomNavigationBar: Bottomnavigationbar(),
      endDrawer: new AppDrawer(),
      body: (act1=='') ? Center(child : loader()) : checkalreadylogin(),
    );

  }
  checkalreadylogin(){
    if(response==1) {
      return new IndexedStack(
        index: _currentIndex,
        children: <Widget>[
          underdevelopment(),
          mainbodyWidget(),
          underdevelopment()
        ],
      );
    }else{
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => LoginPage()),
      );
    }
  }
  loader(){
    return new Container(
      child: Center(
        child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Image.asset(
                  'assets/spinner.gif', height: 50.0, width: 50.0),
            ]),
      ),
    );
  }
  underdevelopment(){
    return new Container(
      child: Center(
        child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Icon(Icons.android,color: appcolor,),Text("Under development",style: new TextStyle(fontSize: 30.0,color:appcolor),)
            ]),
      ),
    );
  }

  launchMap(String url) async{
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      print( 'Could not launch $url');
    }
  }

  mainbodyWidget(){
    return Center(
      child: Form(
        key: _formKey,
        child: SafeArea(
            child: Column( children: <Widget>[
              SizedBox(height: 20.0),
              Text('Pricing',
                  style: new TextStyle(fontSize: 22.0, color: appcolor)),
              new Divider(color: Colors.black54,height: 1.5,),
              new Expanded(child: ListView(
                padding: EdgeInsets.symmetric(horizontal: 24.0),
                children: <Widget>[
                  SizedBox(height: 20.0,),
                  Center(child:Text("Advanced Web Panel",style: TextStyle(fontSize: 15.0),)),
                  SizedBox(height: 10.0,),
                  Center(child:Text("Attendance Reports(20+)",style: TextStyle(fontSize: 15.0,),)),
                  SizedBox(height: 10.0,),
                  Center(child:Text("Track Visits",style: TextStyle(fontSize: 15.0,),)),
                  SizedBox(height: 10.0,),
                  Center(child:Text("Monitor Sites",style: TextStyle(fontSize: 15.0,),)),
                  SizedBox(height: 10.0,),
                  Center(child:Text("Hourly Wages",style: TextStyle(fontSize: 15.0,),)),
                  SizedBox(height: 10.0,),
                Center(child:Text("Self Attendance",style: TextStyle(fontSize: 15.0),)),
                  SizedBox(height: 10.0,),
                Center(child:Text("Login by QR Code ",style: TextStyle(fontSize: 15.0),)),
                  SizedBox(height: 10.0,),
                  Center(child:Text("Biometric capture",style: TextStyle(fontSize: 15.0),)),
                  SizedBox(height: 10.0,),
                  Center(child:Text("Records Location",style: TextStyle(fontSize: 15.0),)),
                  SizedBox(height: 10.0,),
                Center(child:Text("Time off",style: TextStyle(fontSize: 15.0,),)),
                  SizedBox(height: 10.0,),
                Center(child:Text("Bulk attendance",style: TextStyle(fontSize: 15.0,),)),
                  SizedBox(height: 10.0,),
                  Center(child:Text("Advanced Filtering",style: TextStyle(fontSize: 15.0,),)),
                  SizedBox(height: 10.0,),
                  Center(child:Text("Export Data",style: TextStyle(fontSize: 15.0,),)),
                  SizedBox(height: 10.0,),
                  Center(child:Text("Geo Fencing",style: TextStyle(fontSize: 15.0,),)),
                  SizedBox(height: 10.0,),

                ],
              ),
              ),
              new Divider(color: Colors.black54,height: 1.5,),
              RaisedButton(
                child: Text("Buy"),
                color: buttoncolor,
                onPressed: (){

                  if(buystatus=="1" && trialstatus=="2") {
                    launchMap("https://ubiattendance.ubihrm.com/");
                  }
                  if(buystatus=="0") {
                    launchMap("http://buy.ubiattendance.com/index.php?id="+orgmail);
                  }
                },
                textColor: Colors.white,
              )
            ]
            )
        ),
      ),
    );
  }

  requesttimeoff(var timeoffdate,var starttime,var endtime,var reason, BuildContext context) async{
    final prefs = await SharedPreferences.getInstance();
    String empid = prefs.getString("empid");
    String orgid = prefs.getString("orgid");
    //var timeoff = TimeOffModal.TimeOff(Time timeoffdate, starttime, endtime, reason, empid, orgid);
    var timeoff = TimeOffModal.TimeOff(TimeofDate: timeoffdate,TimeFrom: starttime, TimeTo: endtime, Reason: reason, EmpId: empid, OrgId: orgid);
    RequestTimeOffService request =new RequestTimeOffService();
    var islogin = await request.requestTimeOff(timeoff);
    print("--->"+islogin);
    if(islogin=="success"){
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => TimeoffSummary()),
      );
      setState(() {
        _isButtonDisabled=false;
      });
    }else if(islogin=="No Connection"){
      showInSnackBar("Poor Network Connection");
      setState(() {
        _isButtonDisabled=false;
      });
    }else {
      showInSnackBar(islogin);
      setState(() {
        _isButtonDisabled=false;
      });
    }
  }
}