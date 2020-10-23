import 'package:Shrine/globals.dart';
import 'package:Shrine/services/services.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'drawer.dart';
import 'geofenceList.dart';
import 'home.dart';
import 'settings.dart';
import 'reports.dart';
import 'attendance_summary.dart';


class bulkEmplGeo extends StatefulWidget {
  String id;  String geoname;

  @override
  bulkEmplGeo(BuildContext context, orgid, geoname1){
    id = orgid;
    geoname = geoname1;
  }

  @override
  _bulkEmplGeoState createState() => _bulkEmplGeoState(id,geoname);
}

class _bulkEmplGeoState extends State<bulkEmplGeo> {

  String id;  String geoname;

  @override
  _bulkEmplGeoState( orgid,geoname1){
    id = orgid;
    geoname = geoname1;
    print(geoname);
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

//  List<Map<String,String>> _categories=
//  [{"display": "somya" , "value": "7569"},
//    {"display": "raj" , "value": "7569"},
//    {"display": "priya" , "value": "7569"},
//    {"display": "keshav" , "value": "7569"},
//  ];

  List _selecteCategorys = List();
  String fname="";
  String lname="";
  String desination="";
  //String today = '';
  String profile="";
  String Name="";
  String org_name="";
  int _currentIndex = 1;
  String admin_sts='0';
  bool _checkLoadedprofile = true;
  var profileimage;
  bool showtabbar ;
  String _orgName="";
  bool res = true;
  bool tap = true;
  String date = '-';
  List<Map> empList = [];
  int length = 0;


  @override
  void initState() {
    super.initState();
    getEmployeesList(2).then((data){
      setState(() {
        empList=data;
      });
      print(empList);
    });
    getOrgName();
  }

  getOrgName() async{
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _orgName= prefs.getString('org_name') ?? '';
      /* print("organization name is");
      print(_orgName);*/
      admin_sts= prefs.getString('sstatus') ?? '';
    });
  }

  void _onCategorySelected(bool selected, category_id) {
    if (selected == true) {
      setState(() {
        _selecteCategorys.add(category_id);
        length = _selecteCategorys.length;
        print(_selecteCategorys);
        print("list is");
      });
    } else {
      setState(() {
        _selecteCategorys.remove(category_id);
        length = _selecteCategorys.length;
      });
    }
    print(_selecteCategorys);
    print("after");
  }

  @override
  Widget build(BuildContext context) {
    return new WillPopScope(
      //onWillPop: ()=> sendToHome(),
        child: new Scaffold(
          //backgroundColor:scaffoldBackColor(),
            endDrawer: new AppDrawer(),
            appBar: AppBar(
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[

                  new Text(_orgName, style: new TextStyle(fontSize: 20.0)),

                  /*  Image.asset(
                      'assets/logo.png', height: 40.0, width: 40.0),*/
                ],
              ),
              leading: IconButton(icon:Icon(Icons.arrow_back),onPressed:() {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => geofencelist()),
                );
              },),
              backgroundColor: appcolor,
            ),
            bottomNavigationBar: BottomNavigationBar(
              currentIndex: _currentIndex,
              onTap: (newIndex) {
                if (newIndex == 2) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Settings()),
                  );
                  return;
                } else if (newIndex == 1) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => HomePage()),
                  );
                  return;
                } else if (newIndex == 0) {
                  (admin_sts == '1'||admin_sts == '2')
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
                setState(() {
                  _currentIndex = newIndex;
                });
              }, // this will be set when a new tab is tapped
              items: [
                (admin_sts == '1'||admin_sts == '2')
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
                  icon: new Icon(
                    Icons.home,
                    color: Colors.orangeAccent,
                  ),
                  title: new Text(
                    'Home',
                    style: TextStyle(color: Colors.orangeAccent),
                  ),
                ),
                BottomNavigationBarItem(
                    icon: Icon(
                      Icons.settings,
                      color: Colors.black54,
                    ),
                    title: Text(
                      'Settings',
                      style: TextStyle(color: Colors.black54),
                    ))
              ],
            ),

            body:  new Container(
              child: Column(
                  children: <Widget>[
                    SizedBox(height: 15.0,),
                    new Center(
                        child: new Text("Select the Employee(s) to assign\n"+"'"+geoname+"'"+" geo center.",style: TextStyle(fontSize: 20.0, color:appcolor),textAlign: TextAlign.center,)
                    ),

                    Expanded(
                        child: Container(
                            child: ListView.builder(
                                scrollDirection: Axis.vertical,
                                shrinkWrap: true,
                                itemCount: empList.length,
                                itemBuilder: (BuildContext context, int index) {
                                  //print(_categories[index]['display']);
                                  return CheckboxListTile(
                                    value:_selecteCategorys
                                        .contains(empList[index]['Id']),
                                    onChanged: (bool selected) {
                                      print(selected);
                                      print("selected");
                                      _onCategorySelected(selected, empList[index]['Id']);
                                    },
                                    title: Text(empList[index]['Name']),
                                  );
                                })
                        )),
                    SizedBox(height: 2.0,),

                    ButtonBar(
                        alignment: MainAxisAlignment.spaceEvenly,
                        mainAxisSize: MainAxisSize.max,
                        children: <Widget>[
                          FlatButton(
                            shape: Border.all(color: Colors.grey),
                            child: Text('CANCEL'),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          ),
                          RaisedButton(
                            child: Text(' ASSIGN ' ,style: TextStyle(color: Colors.white),),
                            color: Colors.orangeAccent,
                            onPressed: () {
                              length != 0?saveGeoAllocation(id,_selecteCategorys).then((res){
                                if(res==1) {
                                  showDialog(
                                      context: context,
                                      builder: (context) {
                                        Future.delayed(Duration(seconds: 2), () {
                                          Navigator.of(context).pop(true);
                                        });
                                        return AlertDialog(
                                          content: Text('Geofence assigned successfully'),
                                        );
                                      });

                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => geofencelist()),
                                  );
                                }
                                /* else if(res == 0) {
                                  showDialog(
                                      context: context,
                                      // ignore: deprecated_member_use
                                      child: new AlertDialog(
                                        content: new Text(
                                            "Please select the employees to assign this designation"),
                                      ));
                                }*/
                              }).catchError((onError) {
                                print('Unable to call service. Please try later');
                                print(onError);
                              }) : showDialog(
                                  context: context,
                                  builder: (context) {
                                    Future.delayed(Duration(seconds: 2),() {
                                      Navigator.of(context).pop(true);
                                    });
                                    return AlertDialog(
                                      content: Text('Please select the Employees to assign geofence'),
                                    );
                                  });

                            },
                          )
                        ]),


                  ]
              ),

            )));
  }

}