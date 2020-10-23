import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import 'drawer.dart';
import 'globals.dart';
import 'home.dart';
void main() => runApp(new MyAppAbout());

class MyAppAbout extends StatefulWidget {
  @override
  _MyAppAbout createState() => _MyAppAbout();
}

class _MyAppAbout extends State<MyAppAbout> {
  String fname="";
  String lname="";
  String desination="";
  String profile="";
  String org_name="";
  String admin_sts = '0';
  @override
  void initState() {
    super.initState();
    initPlatformState();
  }
  // Platform messages are asynchronous, so we initialize in an async method.
  initPlatformState() async {
    final prefs = await SharedPreferences.getInstance();

    setState(() {
      fname = prefs.getString('fname') ?? '';
      lname = prefs.getString('lname') ?? '';
      desination = prefs.getString('desination') ?? '';
      profile = prefs.getString('profile') ?? '';
      org_name = prefs.getString('org_name') ?? '';
      admin_sts = prefs.getString('sstatus').toString() ?? '0';
    });
  }
  @override
  Widget build(BuildContext context) {
    String html = '<h3 style="color:red">About ubiAttendance</h3><p style="color:green">Track attendance anywhere - 24/7</p><p>ubiAttendanceApp offers the easiest and fastest way to track employee attendance. Convert your phone to a Bio-metric Time Machine. Check Attendance with 100% accuracy for employees, onsite workforce or students with equal ease through our attendance app. Spot late comers and find early leavers.</p><p><b>4 way secure </b><br/>- <span style="color:blue">Login/QR Code</span>+<span style="color:blue">Time</span>+<span style="color:blue">Photo </span>+<span style="color:blue"> Location</span>.</p><p>Keep a check on employee hours with <b>100% </b>accuracy. No more proxy!</p><h4 style="color:red">Why our Attendance App is superior to Biometric Time Clocks?</h4><p><b>1. Quick Start:</b> No hardware installation. No Software required. Start tracking time of employees immediately.</p><p><b>2. Free Upgrades:</b>Unpke biometric machines, bug fixes& updates are free! Attendance can be marked anytime, anywhere - every time. No office space required.</p><p><b>3. Login with QR Code/Email:</b> Device identifies employees by Login ID/QR code scans. Helps employees at all levels punch Time in & Time out!</p><p><b>4. Highly Affordable:</b> Budget friendly App. No installation cost required. Our App is subscription based. Nominally priced – per Employee/Month</p><p><b>5. One Stop Solution:</b> Can be extended to manage leave & Payroll. Integrates easily with our HR management software.</p><p><b>6. For Every Industry:</b> Our Time Attendance App caters to all Industry sectors - Start-ups, SMEs & Large Organizations</p><p><b>7. On Cloud: </b>Data is fully locked& Backed Up on our cloud based Attendance Management App&secured servers</p><p><b> 8. Insightful Reports & Graphs: </b>Track latecomers, early leavers, absentees, and employee’s overtime & under time with powerful reports.</p><p><b> 9. Scalable:</b> The App grows with your organization. Create only the required employee accounts on App.</p><p><b>10. Configurable:</b> Add/Edit departments, designations, shift timings & hopdays.</p><h4 style="color:red">Here’s how our App works</h4><p>The device identifies the Employee through <b>Login or QR code</b>.</p><p>The <b>location</b> is captured from the mobile device</p><p>Employee’s <b>photo</b> is captured</p><p>After the above steps the attendance is marked – with record of <b>location, photo, time & identity</b></p><p><b>Remote employees</b> can now mark their attendance in <b>seconds</b>.</p><p>The Time tracking software also <b>generates powerful reports</b> for the management – they can now easily <b>identify defaulters</b>.</p><h4 style="color:red">Our App is backed by a secure SAAS cloud platform that gives the following additional features:</h4><p>Administrator login</p><p><b>Configure</b> Hopdays/ Week Offs/ Half Days</p><p>Add/Edit/Delete/Deactivate <b>Departments</b></p><p>Add/Edit/Delete/Deactivate <b>Designations</b></p><p>Create/ Edit/ Delete <b>Shifts</b></p><p>Generate <b>QR codes</b> for employees</p><h5 style="color:black">Employees</h5><p>Employee <b>registration</b> with login ID/ QR code</p><p>Add/ Edit/ <b>Deactivate Employees</b></p><h5 style="color:black">Self Service</h5><p>Login/ QR Scan</p><p>Mark/ Check Attendance</p><p>Take Picture</p><p>Capture Location</p><p>Request Time Off</p><p>Check self Attendance Reports</p><h5 style="color:black">Standard Graphs</h5><p>Last 7 Day’s Absentees</p><p>Current Month Absentees</p><p>Last 7 Day’s Late Comers</p><p>Today’s Employees Attendance</p><p>Last Month’s Employees Attendance</p><h5 style="color:black">Reports</h5><p>Today’s Attendance Report</p><p>Last 7 day’s Attendance Report</p><p>Current month’s Attendance Report</p><p>Specific day’s Attendance Report</p><p>Late Comers pst</p><p>Early Leavers pst</p><p>Absent Employees pst</p><p>Late Comers pst</p><p>Employees Overtime Report</p><p>Employees Under time Report</p><p>Got questions? Write to us at support@ubitechsolutions.com</p><p>Developer – www.ubitechsolutions.com</p>';
    return new Scaffold(
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
        body: new SingleChildScrollView(
          child: new Center(
         //   child: new HtmlView(data: html,),
          ),
        ),
      );

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
}