import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:medical_app/config/funcs/CheckConnectivity.dart';
import 'package:medical_app/config/cons/colors.dart';
import 'package:medical_app/contollers/diagnosis_controller/CIDsController.dart';
import 'package:medical_app/contollers/sqflite/database/Helper.dart';
import 'package:medical_app/contollers/sqflite/model/User.dart';
import 'package:medical_app/contollers/sqflite/utils/Utils.dart';
import 'package:medical_app/model/CIDModel.dart';

class TestSQFLITE extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
          primaryColor: Color(0xff00bfa5),
          appBarTheme: AppBarTheme(
              textTheme: TextTheme(
                  subtitle1: TextStyle(
            color: Colors.white,
            fontSize: 20,
          )))),
      home: MyHomePage(title: 'SQFlite'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool flag = false;
  bool insertItem = false;
  final teNameController = TextEditingController();
  final tePhoneController = TextEditingController();
  final teEmailController = TextEditingController();
  List<User> items = new List();
  List<User> values;
  final GlobalKey<AnimatedListState> _listKey = GlobalKey();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _autoValidate = false;
  ScrollController _scrollController;

  String searchController = '';



  List searchSelected = [];
  sendPushToSelect(){
    print('receive push from search data');

    for(var a =0 ; a< _cidData.length; a++){

     if(searchSelected.contains(_cidData[a].sId)){

       setState(() {
         _cidData[a].isSelected = true;
       });

     }

    }

    print('selected: ${searchSelected}');


  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Column(
        children: [
          Padding(
              padding: EdgeInsets.only(left: 30, right: 10, top: 0),
              child: TextFormField(
                autofocus: false,
                // focusNode: focusNode,
                // controller: searchController,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Search',
                  suffixIcon: Icon(Icons.search),
                ),
                onChanged: (val) {
                  setState(() {
                    searchController = val;
                  });
                  if (val.isNotEmpty) {
                    print('searching');
                    getsearch();
                  } else {
                    print('search field empty');
                    // focusNode.unfocus();
                    setState(() {
                      searchStatus = '';
                    });
                    sendPushToSelect();
                  }
                  print(searchController);
                },
                onEditingComplete: () {
                  print('complete');
                  getsearch();
                },
              )),
          Expanded(
              child: searchStatus=='' ? ListView.builder(
                      itemCount: _cidData.length,
                      itemBuilder: (context, index) {
                        // return Text(_cidData[index].cidname);

                      return  Padding(
                          padding: const EdgeInsets.only(left:20.0,top: 12.0,bottom: 12.0,right: 20.0),
                          child:  Row(crossAxisAlignment:CrossAxisAlignment.start,children: [

                            Column(mainAxisAlignment: MainAxisAlignment.start,

                              children: [
                                InkWell(

                                  child: Card(
                                    child: Container(decoration:BoxDecoration(border: Border.all(color: _cidData[index].isSelected? Colors.green:Colors.black.withAlpha(100)),
                                        borderRadius: BorderRadius.circular(5.0)
                                    ),
                                        child:_cidData[index].isSelected? Icon(Icons.check,size: 20.0,color:Colors.green):Icon(Icons.check,size: 18.0,color: Colors.transparent,)),
                                    elevation: 4.0,
                                  ),
                                  onTap: (){
                                    setState(() {

                                      // for(var i = 0;i<_controller.CIDList.length;i++){
                                      //   _controller.CIDList[i].isSelected = false;
                                      // }

                                      _cidData[index].isSelected =!_cidData[index].isSelected;


                                      if(searchSelected.contains(_cidData[index].sId)){
                                        searchSelected.remove(_cidData[index].sId);
                                      }else{
                                        searchSelected.add(_cidData[index].sId);
                                      }
                                      print(searchSelected);
                                    });
                                  },
                                ),
                                // SizedBox(height:15.0,)
                              ],
                            ),
                            SizedBox(width: 5.0,),

                            Expanded(
                              child: Column(mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Container(width: MediaQuery.of(context).size.width,child: Padding(
                                    padding: const EdgeInsets.only(top:4.0),
                                    child: Text(_cidData[index].cidname.toUpperCase(),
                                      style: TextStyle(fontWeight: FontWeight.w500,color:black40_color ),
                                    ),
                                  ),

                                  ),
                                ],
                              ),
                            )],),
                        );

                      })


                  : _isloading
                      ? Text('searching...')
                      :
    searchStatus=='empty'?Text('Not found')
 :             ListView.builder(
                          itemCount: _cidDataSearch.length,
                          itemBuilder: (context, index) {
                            // return Text(_cidDataSearch[index].cidname);
                            return  Padding(
                              padding: const EdgeInsets.only(left:20.0,top: 12.0,bottom: 12.0,right: 20.0),
                              child:  Row(crossAxisAlignment:CrossAxisAlignment.start,children: [

                                Column(mainAxisAlignment: MainAxisAlignment.start,

                                  children: [
                                    InkWell(

                                      child: Card(
                                        child: Container(decoration:BoxDecoration(border: Border.all(color: _cidDataSearch[index].isSelected? Colors.green:Colors.black.withAlpha(100)),
                                            borderRadius: BorderRadius.circular(5.0)
                                        ),
                                            child:_cidDataSearch[index].isSelected? Icon(Icons.check,size: 20.0,color:Colors.green):Icon(Icons.check,size: 18.0,color: Colors.transparent,)),
                                        elevation: 4.0,
                                      ),
                                      onTap: (){
                                        setState(() {

                                          // for(var i = 0;i<_controller.CIDList.length;i++){
                                          //   _controller.CIDList[i].isSelected = false;
                                          // }

                                          _cidDataSearch[index].isSelected = !_cidDataSearch[index].isSelected;



                                          if(searchSelected.contains(_cidDataSearch[index].sId)){
                                            searchSelected.remove(_cidDataSearch[index].sId);
                                          }else{
                                            searchSelected.add(_cidDataSearch[index].sId);
                                          }

                                          print(searchSelected);
                                          // sendPushToSelect(_cidData[index]);

                                        });
                                      },
                                    ),
                                    // SizedBox(height:15.0,)
                                  ],
                                ),
                                SizedBox(width: 5.0,),

                                Expanded(
                                  child: Column(mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Container(width: MediaQuery.of(context).size.width,child: Padding(
                                        padding: const EdgeInsets.only(top:4.0),
                                        child: Text(_cidDataSearch[index].cidname.toUpperCase(),
                                          style: TextStyle(fontWeight: FontWeight.w500,color:black40_color ),
                                        ),
                                      ),

                                      ),
                                    ],
                                  ),
                                )],),
                            );


                          })
              // Text('searching...'),
              )
        ],
      ),
      floatingActionButton: _buildFab(),
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  final CIDsController _ciDsController = CIDsController();

  @override
  void initState() {
    super.initState();
    print("INIT");
    _scrollController = new ScrollController();
    _scrollController.addListener(() => setState(() {}));

    // checkConnectivity().then((internet) {
    //   print('internet');
    //   if (internet != null && internet) {
    //     _ciDsController.getListData().then((value){
    //
    //
    //     });
    //     print('internet avialable');
    //   }
    // });
    getDataa();
  }

  List<CIDData> _cidData = [];
  getDataa() async {
    var dbHelper = Helper();
    await dbHelper.getAllUsers().then((value) {
      print('all Cids : ${value.length}');

      // List<User>userList =[];
      // userList.addAll(values)
      for (var a = 0; a < value.length; a++) {
        setState(() {
          _cidData.add(CIDData(
              cidname: value[a].name, sId: value[a].phone, isSelected: false));
        });
      }
    });
  }

  List<CIDData> _cidDataSearch = [];
  bool _isloading = false;
  String searchStatus = '';
  getsearch() async {
    setState(() {
      _isloading = true;
      searchStatus = 'searching';
    });
    _cidDataSearch.clear();
    // var dbHelper = Helper();
    // await dbHelper.searching(searchController).then((value) {
    //   print('all searched Cids : ${value}');
    //
    //   // List<User>userList =[];
    //   // userList.addAll(values)
    //      if(value.isNotEmpty) {
    //     for (var a = 0; a < value.length; a++) {
    //       setState(() {
    //         _cidDataSearch.add(CIDData(
    //             cidname: value[a].name,
    //             sId: value[a].phone,
    //             isSelected: false));
    //       });
    //       if (a + 1 == value.length) {
    //         print('complete here len');
    //         setState(() {
    //           _isloading = false;
    //           searchStatus = 'stop';
    //         });
    //       }
    //
    //
    //
    //     }
    //   }else{
    //        setState(() {
    //          _isloading = false;
    //          searchStatus = 'empty';
    //        });
    //      }
    // });

    for(var a = 0; a<_cidData.length; a++){

      if(_cidData[a].cidname.replaceAll(' ', '').toLowerCase().contains(searchController)){

        _cidDataSearch.add(_cidData[a]);

      }

    }

    setState(() {
                _isloading = false;
                searchStatus = 'stop';
              });

    for(var a =0 ; a< _cidDataSearch.length; a++){

      if(searchSelected.contains(_cidDataSearch[a].sId)){

        setState(() {
          _cidDataSearch[a].isSelected = true;
        });

      }

    }

  }

  Widget _buildFab() {
    bool visibilityFlag = true;
    double max;
    double currentScroll;

    if (_scrollController.hasClients) {
      //visibilityFlag = true;

      max = _scrollController.position.maxScrollExtent;
      double min = _scrollController.position.minScrollExtent;
      currentScroll = _scrollController.position.pixels;

      if ((min == currentScroll) &&
          (_scrollController.position.userScrollDirection ==
              ScrollDirection.idle)) {
        visibilityFlag = true;
      } else if (max == currentScroll) {
        visibilityFlag = false;
      }
    }

    return new Visibility(
      visible: visibilityFlag,
      child: new FloatingActionButton(
        onPressed: () => addToOfffline(),
        tooltip: 'Increment',
        backgroundColor: Color(0xff00bfa5),
        child: Icon(Icons.add),
      ),
    );
  }

  ///edit User
  editUser(int id) {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      var user = User();
      user.id = id;
      user.name = teNameController.text;
      user.phone = tePhoneController.text;
      user.email = teEmailController.text;
      var dbHelper = Helper();
      dbHelper.update(user).then((update) {
        teNameController.text = "";
        tePhoneController.text = "";
        teEmailController.text = "";
        Navigator.of(context).pop();
        showtoast("Data Saved successfully");
        setState(() {
          flag = false;
        });
      });
    } else {
//    If all data are not valid then start auto validation.
      setState(() {
        _autoValidate = true;
      });
    }
  }

  addToOfffline() {
    print('cids: ${_ciDsController.CIDList.length}');

    for (var a = 0; a < _ciDsController.CIDList.length; a++) {
      var user = User();
      user.name = _ciDsController.CIDList[a].cidname;
      user.phone = _ciDsController.CIDList[a].sId;
      user.email = 'teEmailController.text';
      var dbHelper = Helper();
      dbHelper.insert(user).then((value) {
        teNameController.text = "";
        tePhoneController.text = "";
        teEmailController.text = "";
        Navigator.of(context).pop();
        // showtoast("Successfully Added Data");
        setState(() {
          insertItem = true;
        });
      });
    }
  }

  ///add User Method
  addUser() {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      var user = User();
      user.name = teNameController.text;
      user.phone = tePhoneController.text;
      user.email = teEmailController.text;
      var dbHelper = Helper();
      dbHelper.insert(user).then((value) {
        teNameController.text = "";
        tePhoneController.text = "";
        teEmailController.text = "";
        Navigator.of(context).pop();
        showtoast("Successfully Added Data");
        setState(() {
          insertItem = true;
        });
      });
    } else {
//    If all data are not valid then start auto validation.
      setState(() {
        _autoValidate = true;
      });
    }
  }

  /// openAlertBox to add/edit user
  openAlertBox(User user) {
    if (user != null) {
      teNameController.text = user.name;
      tePhoneController.text = user.phone;
      teEmailController.text = user.email;
      flag = true;
    } else {
      flag = false;
      teNameController.text = "";
      tePhoneController.text = "";
      teEmailController.text = "";
    }

    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(25.0))),
            contentPadding: EdgeInsets.only(top: 10.0),
            content: Container(
              width: 300.0,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Text(
                        flag ? "Edit User" : "Add User",
                        style: TextStyle(fontSize: 28.0),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 5.0,
                  ),
                  Divider(
                    color: Colors.grey,
                    height: 4.0,
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 30.0, right: 30.0),
                    child: Form(
                      key: _formKey,
                      // autovalidate: _autoValidate,
                      child: Column(
                        children: <Widget>[
                          TextFormField(
                            controller: teNameController,
                            keyboardType: TextInputType.text,
                            decoration: InputDecoration(
                              hintText: "Add Name",
                              fillColor: Colors.grey[300],
                              border: InputBorder.none,
                            ),
                            validator: validateName,
                            onSaved: (String val) {
                              teNameController.text = val;
                            },
                          ),
                          TextFormField(
                            keyboardType: TextInputType.phone,
                            controller: tePhoneController,
                            decoration: InputDecoration(
                              hintText: "Add Phone",
                              fillColor: Colors.grey[300],
                              border: InputBorder.none,
                            ),
                            maxLines: 1,
                            validator: validateMobile,
                            onSaved: (String val) {
                              tePhoneController.text = val;
                            },
                          ),
                          TextFormField(
                            keyboardType: TextInputType.emailAddress,
                            controller: teEmailController,
                            decoration: InputDecoration(
                              hintText: "Add Email",
                              fillColor: Colors.grey[300],
                              border: InputBorder.none,
                            ),
                            maxLines: 1,
                            validator: validateEmail,
                            onSaved: (String val) {
                              teEmailController.text = val;
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () => flag ? editUser(user.id) : addUser(),
                    child: Container(
                      padding: EdgeInsets.only(top: 20.0, bottom: 20.0),
                      decoration: BoxDecoration(
                        color: Color(0xff00bfa5),
                        borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(25.0),
                            bottomRight: Radius.circular(25.0)),
                      ),
                      child: Text(
                        flag ? "Edit User" : "Add User",
                        style: TextStyle(color: Colors.white),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }

  /// Validation Check
  String validateName(String value) {
    if (value.length < 3)
      return 'Name must be more than 2 charater';
    else if (value.length > 30) {
      return 'Name must be less than 30 charater';
    } else
      return null;
  }

  String validateMobile(String value) {
    Pattern pattern = r'^[0-9]*$';
    RegExp regex = new RegExp(pattern);
    if (value.trim().length != 10)
      return 'Mobile Number must be of 10 digit';
    else if (value.startsWith('+', 0)) {
      return 'Mobile Number should not contain +91';
    } else if (value.trim().contains(" ")) {
      return 'Blank space is not allowed';
    } else if (!regex.hasMatch(value)) {
      return 'Characters are not allowed';
    } else
      return null;
  }

  String validateEmail(String value) {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);
    if (!regex.hasMatch(value))
      return 'Enter Valid Email';
    else if (value.length > 30) {
      return 'Email length exceeds';
    } else
      return null;
  }

  /// Get all users data
  getAllUser() {
    return FutureBuilder(
        future: _getData(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          return createListView(context, snapshot);
        });
  }

  ///Fetch data from database
  Future<List<User>> _getData() async {
    var dbHelper = Helper();
    await dbHelper.getAllUsers().then((value) {
      items = value;
      if (insertItem) {
        _listKey.currentState.insertItem(values.length);
        insertItem = false;
      }
    });

    return items;
  }

  ///create List View with Animation
  Widget createListView(BuildContext context, AsyncSnapshot snapshot) {
    values = snapshot.data;
    print('valuess len: ${values.length}');
    if (values != null) {
      showProgress();
      return new AnimatedList(
          key: _listKey,
          controller: _scrollController,
          shrinkWrap: true,
          initialItemCount: values.length,
          itemBuilder: (BuildContext context, int index, animation) {
            return _buildItem(values[index], animation, index);
          });
    } else
      return Container();
  }

  ///Construct cell for List View
  Widget _buildItem(User values, Animation<double> animation, int index) {
    if (values.name.toLowerCase().contains(searchController.toLowerCase())) {
      return SizeTransition(
        sizeFactor: animation,
        child: Card(
          child: ListTile(
            onTap: () => onItemClick(values),
            title: Text(
              values.name,
              style: TextStyle(
                  fontSize: 18.0,
                  fontStyle: FontStyle.normal,
                  color: Colors.black),
              maxLines: 2,
              softWrap: true,
            ),
          ),
        ),
      );
    } else if (searchController.isEmpty) {
      return SizeTransition(
        sizeFactor: animation,
        child: Card(
          child: ListTile(
            onTap: () => onItemClick(values),
            title: Text(
              values.name,
              style: TextStyle(
                  fontSize: 18.0,
                  fontStyle: FontStyle.normal,
                  color: Colors.black),
              maxLines: 2,
              softWrap: true,
            ),
          ),
        ),
      );
    } else {
      return SizeTransition(
        sizeFactor: animation,
        child: Card(
          child: ListTile(
            onTap: () => onItemClick(values),
            title: Text(
              values.name,
              style: TextStyle(
                  fontSize: 18.0,
                  fontStyle: FontStyle.normal,
                  color: Colors.black),
              maxLines: 2,
              softWrap: true,
            ),
          ),
        ),
      );
    }
  }

  ///On Item Click
  onItemClick(User values) {
    print("Clicked position is ${values.name}");
  }

  /// Delete Click and delete item
  onDelete(User values, int index) {
    var id = values.id;
    var dbHelper = Helper();
    dbHelper.delete(id).then((value) {
      User removedItem = items.removeAt(index);

      AnimatedListRemovedItemBuilder builder = (context, animation) {
        return _buildItem(removedItem, animation, index);
      };
      _listKey.currentState.removeItem(index, builder);
    });
  }

  /// Edit Click
  onEdit(User user, int index) {
    openAlertBox(user);
  }
}
