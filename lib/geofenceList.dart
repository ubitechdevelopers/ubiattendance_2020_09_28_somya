import 'package:flutter/material.dart';
import 'addGeofence.dart';
import 'bulkEmployeeGeoAssign.dart';
import 'drawer.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'globals.dart';
import 'home.dart';
import 'services/services.dart';
import 'settings.dart';
import 'reports.dart';
import 'attendance_summary.dart';

class geofencelist extends StatefulWidget {
  @override
  _geofencelist createState() => _geofencelist();
}
TextEditingController dept;
//FocusNode f_dept ;
class _geofencelist extends State<geofencelist> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  int _currentIndex = 2;
  String _sts = 'Active';
  String _sts1 = 'Active';
  String emp='0';
  bool res = true;
  String _orgName="";
  String admin_sts='0';
  bool _isButtonDisabled= false;
  //List<Map<String,String>> empList;

  @override
  void initState() {
    super.initState();
    // checkConnectionToServer(context);

//    getEmployeesWithIdName().then((data){
//      setState(() {
//        empList=data;
//      });
//      print(empList);
//      print("empList");
//    });
    dept = new TextEditingController();
    // f_dept = FocusNode();
    getOrgName();
  }


  getOrgName() async{
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _orgName= prefs.getString('org_name') ?? '';
      admin_sts= prefs.getString('sstatus') ?? '';
    });
  }
  @override
  Widget build(BuildContext context) {
    return getmainhomewidget();
  }

  void showInSnackBar(String value) {
    final snackBar = SnackBar(
        content: Text(value, textAlign: TextAlign.center,));
    _scaffoldKey.currentState.showSnackBar(snackBar);
  }

  getmainhomewidget() {
    return new Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[

            new Text(_orgName, style: new TextStyle(fontSize: 20.0)),

            /*  Image.asset(
                    'assets/logo.png', height: 40.0, width: 40.0),*/
          ],
        ),
        leading: IconButton(icon:Icon(Icons.arrow_back),
            onPressed:() {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Settings()),
              );
            }),
        backgroundColor: appcolor,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (newIndex) {
          if(newIndex==1){
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => HomePage()),
            );
            return;
          }
          if(newIndex==2){
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => Settings()),
            );
            return;
          }else if (newIndex == 0) {
            (admin_sts == '1'||admin_sts=='2')
                ? Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => Reports()),
            )
                : Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => MyApp()),
            );
            return;
          }
          setState((){_currentIndex = newIndex;});

        }, // this will be set when a new tab is tapped
        items: [
          (admin_sts == '1'||admin_sts=='2')
              ? BottomNavigationBarItem(
            icon: new Icon(
              Icons.library_books,
            ),
            title: new Text('Reports'),
          )
              : BottomNavigationBarItem(
            icon: new Icon(
              Icons.calendar_today,
            ),
            title: new Text('Log'),
          ),
          BottomNavigationBarItem(
            icon: new Icon(Icons.home),
            title: new Text('Home'),
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.settings,color: Colors.black54,),
              title: Text('Settings',style: TextStyle(color: Colors.black54),)
          )
        ],
      ),

      endDrawer: new AppDrawer(),
      body:
      Container(
        padding: EdgeInsets.only(left: 2.0, right: 2.0),
        child: Column(
          children: <Widget>[
            SizedBox(height: 8.0),
            Center(
              child: Text('Manage Geofence',
                style: new TextStyle(fontSize: 22.0, color:appcolor,),),
            ),
            Divider(height: 10.0,),
            SizedBox(height: 2.0),
            Container(
              padding: EdgeInsets.only(left: 30.0,right: 30.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text('Geo Center \n    Name', style: TextStyle(
                      color: appcolor,fontWeight: FontWeight.bold),),
                  Text('Radius(Km)', style: TextStyle(
                      color: appcolor,fontWeight: FontWeight.bold),),
                  Text('Action', style: TextStyle(
                      color:appcolor,fontWeight: FontWeight.bold),),
                ],
              ),
            ),
            Divider(),
            SizedBox(height: 5.0),
            new Expanded(
              child: getDeptWidget(),

            ),

          ],
        ),

      ),
      floatingActionButton: new FloatingActionButton(
        mini: false,
        backgroundColor: Colors.orangeAccent,
        onPressed: (){
          setState(() {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => Map1()),
            );
            _isButtonDisabled=false;
          });
          // _showDialog(context);
        },
        tooltip: 'Add Geofence',
        child: new Icon(Icons.add),
      ),
    );
  }



  loader() {
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

  getDeptWidget() {
    return new FutureBuilder<List<geofence1>>(
        future: getGeofence(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return new ListView.builder(
                itemCount: snapshot.data.length,
                padding: EdgeInsets.only(left: 15.0,right: 15.0),
                itemBuilder: (BuildContext context, int index) {
                  return  new Column(
                      children: <Widget>[
                        new FlatButton(
                          child : new Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              new Container(
                                // color: Colors.amber.shade400,
                                padding: EdgeInsets.only(top:5.0,bottom: 5.0),
                                margin: EdgeInsets.only(top:5.0,bottom: 5.0),
                                //alignment: FractionalOffset.center,
                                width: MediaQuery.of(context).size.width * 0.30,
                                child: new Text(snapshot.data[index].name.toString()),
                              ),
                              new Container(
                                // color: Colors.amber.shade400,
                                padding: EdgeInsets.only(top:15.0,bottom: 15.0),
                                alignment: FractionalOffset.centerLeft,
                                width: MediaQuery.of(context).size.width * 0.15,
                                child: new Text(snapshot.data[index].radius.toString(),),
                              ),

                              new IconButton(
                                icon: Icon(Icons.group_add,
                                  size: 29.0,
                                ),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => bulkEmplGeo(context,snapshot.data[index].id.toString(),snapshot.data[index].name.toString())),
                                  );
                                },
                                tooltip: "Assign Geofence",)
                            ],
                          ),
                          onPressed: () {
                            // null;
                            //editDept(context,snapshot.data[index].name.toString(),snapshot.data[index].location.toString(),snapshot.data[index].radius.toString());
                          },
                        ),

                        Divider(color: Colors.blueGrey.withOpacity(0.25),height: 0.9,),
                        SizedBox(height: 15.0),
                      ]
                  );
                }
            );
          }
          return loader();
        }
    );
  }

}/////////mail class close
