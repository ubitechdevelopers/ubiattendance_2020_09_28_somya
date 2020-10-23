// Copyright 2017 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:Shrine/model/model.dart' as TimeOffModal;
import 'package:Shrine/services/gethome.dart';
import 'package:Shrine/services/newservices.dart';
import 'package:Shrine/services/services.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import 'drawer.dart';
import 'globals.dart';
import 'login.dart';
import 'timeoff_summary.dart';
// This app is a stateful, it tracks the user's current choice.
class TimeOffPage extends StatefulWidget {
  @override
  _TimeOffPageState createState() => _TimeOffPageState();
}

class _TimeOffPageState extends State<TimeOffPage> {
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
  String admin_sts='0';
  String act="";
  String act1="";
  int response;
  String fname="", lname="", empid="", email="", status="", orgid="", orgdir="", sstatus="", org_name="", desination="", profile,latit="",longi="";
  String aid="";
  String shiftId="";
  DateTime caldate = DateTime.now();
  @override
  void initState() {
    super.initState();
    checkNetForOfflineMode(context);

    initPlatformState();
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
  // Platform messages are asynchronous, so we initialize in an async method.
  initPlatformState() async {
    appResumedPausedLogic(context);
    final prefs = await SharedPreferences.getInstance();
    empid = prefs.getString('empid') ?? '';
    orgdir = prefs.getString('orgdir') ?? '';
    admin_sts = prefs.getString('sstatus') ?? '0';
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
        profileimage = new NetworkImage(profile);
        print("1-"+profile);
        _checkLoaded = false;
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

  Future<bool> sendToHome() async{
    print("-------> back button pressed");
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => TimeoffSummary()), (Route<dynamic> route) => false,
    );
    return false;
  }

  getmainhomewidget(){
    return new WillPopScope(
      onWillPop: ()=> sendToHome(),
      child: Scaffold(
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
            Navigator.of(context).pop();
          },),
          backgroundColor: appcolor,
        ),

        bottomNavigationBar: Container(

          height: 70.0,
          decoration: new BoxDecoration(
              color: Colors.white,
              boxShadow: [new BoxShadow(
                color: Colors.grey,
                blurRadius: 3.0,
              ),]
          ),
          child: Row(
            children: <Widget>[
              Container(
                margin: const EdgeInsets.only(left: 50.0),
                child: ButtonBar(

                  children: <Widget>[
                    FlatButton(
                      highlightColor: Colors.transparent,
                      focusColor: Colors.transparent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                        side: BorderSide( color: Colors.grey.withOpacity(0.5), width: 1,),
                      ),
                      child: Text('CANCEL'),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => TimeoffSummary()),
                        );
                      },
                    ),
                    SizedBox(width: 10.0),
                    RaisedButton(
                      elevation: 2.0,
                      highlightElevation: 5.0,
                      highlightColor: Colors.transparent,
                      disabledElevation: 0.0,
                      focusColor: Colors.transparent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                      /* child: _isButtonDisabled?Row(children: <Widget>[Text('Processing ',style: TextStyle(color: Colors.white),),SizedBox(width: 10.0,), SizedBox(child:CircularProgressIndicator(),height: 20.0,width: 20.0,),],):Text('SAVE',style: TextStyle(color: Colors.white),),*/
                      child: _isButtonDisabled?Text('Processing..',style: TextStyle(color: Colors.white),):Text('SAVE',style: TextStyle(color: Colors.white),),
                      color: buttoncolor,
                      onPressed: () {

                        if (_formKey.currentState.validate()) {
                          if(_isButtonDisabled)
                            return null;
                          var arr=_starttimeController.text.split(':');
                          var arr1=_endtimeController.text.split(':');
                          final startTime = DateTime(2018, 6, 23,int.parse(arr[0]),int.parse(arr[1]),00,00);
                          final endTime = DateTime(2018, 6, 23,int.parse(arr1[0]),int.parse(arr1[1]),00,00);
                          if(endTime.isBefore(startTime)){

                            showInSnackBar('\"To Time\" can\'t be smaller.');
                            return null ;
                          }
                          setState(() {
                            _isButtonDisabled=true;
                          });

                          requesttimeoff(_dateController.text ,_starttimeController.text,_endtimeController.text,_reasonController.text, context);
                        }
                      },
                    ),
                  ],
                ),
              ),

            ],
          ),
        ),
        endDrawer: new AppDrawer(),
        body: (act1=='') ? Center(child : loader()) : checkalreadylogin(),
      ),
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
              Icon(Icons.android,color: appcolor,),Text("Under development",style: new TextStyle(fontSize: 30.0,color: appcolor),)
            ]),
      ),
    );
  }

  mainbodyWidget(){
    return Center(
      child: Form(
        key: _formKey,
        child: SafeArea(
            child: Column( children: <Widget>[
              SizedBox(height: 20.0),
              Text('Mark Time Off',
                  style: new TextStyle(fontSize: 22.0, color: appcolor)),

              new Expanded(child: ListView(
                padding: EdgeInsets.symmetric(horizontal: 24.0),
                children: <Widget>[
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      SizedBox(height: 20.0),
                      DateTimeField(
                        //firstDate: new DateTime.now(),
                        //initialDate: new DateTime.now(),
                        //dateOnly: true,
                        format: dateFormat,
                        controller: _dateController,
                        onShowPicker: (context, currentValue) {
                          return showDatePicker(
                              context: context,
                              firstDate: DateTime.now().subtract(Duration(days: 1)),
                              initialDate: currentValue ?? DateTime.now(),
                              lastDate: DateTime(2100));

                        },
                        readOnly: true,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide( color: Colors.grey.withOpacity(0.0), width: 1,),
                          ),
                          labelText: 'Date',
                        ),
                        validator: (date) {
                          if (date==null){
                            return 'Please enter Timeoff date';
                          }
                        },
                      ),
                      SizedBox(height: 20.0),//Enter date
                      Row(
                        children: <Widget>[
                          Expanded(
                            child:DateTimeField(
                              //initialTime: new TimeOfDay.now(),
                                format: timeFormat,
                                controller: _starttimeController,
                                onShowPicker: (context, currentValue) async {
                                  final time = await showTimePicker(
                                    context: context,
                                    initialTime: TimeOfDay.fromDateTime(currentValue ?? DateTime.now()),
                                  );
                                  return DateTimeField.convert(time);
                                },
                                readOnly: true,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    borderSide: BorderSide( color: Colors.grey.withOpacity(0.0), width: 1,),
                                  ),
                                  labelText: 'From',
                                ),
                                validator: (time) {
                                  if (time==null) {
                                    return 'Please enter start time';
                                  }
                                },
                                onChanged: (dt) {
                                  setState(() {
                                    starttime = TimeOfDay.fromDateTime(dt);
                                  });
                                  print("----->Changed Time------> "+starttime.toString());
                                }
                            ),
                          ),
                          SizedBox(width: 10.0),
                          Expanded(
                            child:DateTimeField(
                              //initialTime: new TimeOfDay.now(),
                              format: timeFormat,
                              controller: _endtimeController,
                              onShowPicker: (context, currentValue) async {
                                final time = await showTimePicker(
                                  context: context,
                                  initialTime: TimeOfDay.fromDateTime(currentValue ?? DateTime.now()),
                                );
                                return DateTimeField.convert(time);
                              },
                              readOnly: true,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: BorderSide( color: Colors.grey.withOpacity(0.0), width: 1,),
                                ),
                                labelText: 'To',
                              ),
                              onChanged: (dt) {
                                setState(() {
                                  endtime = TimeOfDay.fromDateTime(dt);
                                });

                                print("------> End Time"+_endtimeController.text);
                              },
                              validator: (time) {
                                if (time==null) {
                                  return 'Please enter end time';
                                }

                              },
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 20.0),
                      TextFormField(
                        controller: _reasonController,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide( color: Colors.grey.withOpacity(0.0), width: 1,),
                          ),
                          labelText: 'Reason',
                        ),
                        validator: (value) {
                          if (value.trim().isEmpty) {
                            return 'Please enter reason';
                          }
                        },
                        onFieldSubmitted: (String value) {
                          if (_formKey.currentState.validate()) {
                            requesttimeoff(_dateController.text ,_starttimeController.text,_endtimeController.text,_reasonController.text, context);
                          }
                        },
                        maxLines: 2,
                      ),
                    ],
                  ),

                ],
              ),
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