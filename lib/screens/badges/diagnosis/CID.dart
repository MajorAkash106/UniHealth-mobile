import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:keyboard_actions/keyboard_actions.dart';
import 'package:medical_app/config/funcs/CheckConnectivity.dart';
import 'package:medical_app/config/cons/colors.dart';
import 'package:medical_app/config/cons/cons.dart';
import 'package:medical_app/config/widgets/buttons.dart';
import 'package:medical_app/contollers/diagnosis_controller/CIDsController.dart';
import 'package:medical_app/contollers/patient&hospital_controller/PatientListController.dart';
import 'package:medical_app/contollers/patient&hospital_controller/save_history_controller.dart';
import 'package:medical_app/contollers/sqflite/database/Helper.dart';
import 'package:medical_app/model/CIDModel.dart';
import 'package:medical_app/model/PatientListModel.dart';
import 'package:medical_app/model/patientDetailsModel.dart';
import 'package:medical_app/screens/home/hospitalization/new_hospitalization.dart';
import 'package:medical_app/screens/home/patients&hospitals/patients_info.dart';
import 'package:timeago/timeago.dart' as timeago;
class CIDs extends StatefulWidget {
  final PatientDetailsData patientDetailsData;
  CIDs({this.patientDetailsData});
  @override
  _CIDsState createState() => _CIDsState();
}

class _CIDsState extends State<CIDs> {
  final _key = GlobalKey();

  final CIDsController _controller = CIDsController();
  final HistoryController _historyController = HistoryController();
  FocusNode focusNode = FocusNode();
  @override
  void initState() {
    // TODO: implement initState
    getselectedData();
    // checkConnectivity().then((internet) {
    //   print('internet');
    //   if (internet != null && internet) {
    //     _controller.getListData().then((value){
    //
    //       for(var b=0;b<_controller.CIDList.length;b++){
    //         if(selctedOptionID.contains(_controller.CIDList[b].sId)){
    //           _controller.CIDList[b].isSelected = true;
    //         }
    //       }
    //
    //     });
    //     print('internet avialable');
    //   }
    // });
    getDataa();
    super.initState();
  }



  List selctedOptionID = [];
  String selectedCategory;

  getselectedData(){
    selctedOptionID.clear();

   if(widget.patientDetailsData.diagnosis.isNotEmpty) {
      print(widget.patientDetailsData.diagnosis[0].cidData.length);
      for (var a = 0;
          a < widget.patientDetailsData.diagnosis[0].cidData.length;
          a++) {
        setState(() {
          searchSelected.add(widget.patientDetailsData.diagnosis[0].cidData[a].sId);
        });
      }
    }
  }





  final FocusNode _nodeText1 = FocusNode();
  KeyboardActionsConfig _buildConfig(BuildContext context) {
    return KeyboardActionsConfig(
      keyboardActionsPlatform: KeyboardActionsPlatform.ALL,
      keyboardBarColor: Colors.grey[200],
      nextFocus: true,
      actions: [
        KeyboardActionsItem(
          focusNode: _nodeText1,
        ),
      ],
    );
  }

  //---------------------------------------------------------------------------
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

  List<CIDData> _cidData = [];
  getDataa() async {
    var dbHelper = Helper();
    await dbHelper.getAllUsers().then((value) {
      print('all Cids : ${value}');

      // List<User>userList =[];
      // userList.addAll(values)
      for (var a = 0; a < value.length; a++) {
        setState(() {
          _cidData.add(CIDData(
              cidname: value[a].name, sId: value[a].phone, isSelected: false));
        });
      }
    });
    sendPushToSelect();
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
    //   if(value.isNotEmpty) {
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
    //     setState(() {
    //       _isloading = false;
    //       searchStatus = 'empty';
    //     });
    //   }
    // });


    for(var a = 0; a<_cidData.length; a++){

      if(_cidData[a].cidname.replaceAll(' ', '').toLowerCase().contains(searchController)){

        _cidDataSearch.add(_cidData[a]);

      }

    }



    for(var a =0 ; a< _cidDataSearch.length; a++){

      if(searchSelected.contains(_cidDataSearch[a].sId)){

        setState(() {
          _cidDataSearch[a].isSelected = true;
        });

      }

    }

  }
  //----------------------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: _appbarwidget(),
        // bottomNavigationBar: CommonHomeButton(),
        body: Column(
          children: [

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

                    }):

                ListView.builder(
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
            ),
            SizedBox(height: 10.0,),
            Padding(
              padding: const EdgeInsets.only(left:25.0,right: 25.0),
              child: Row(
                children: [
                  Expanded(
                    child: CustomButton(text:'confirm'.tr,
                      myFunc: ()async{
                        FocusScope.of(context).requestFocus(FocusNode());

                        List<CIDData> selectedData = [];
                        selectedData.clear();

                      await  sendPushToSelect();

                        for(var a=0;a<_cidData.length;a++){

                          if(_cidData[a].isSelected==true){
                            selectedData.add(_cidData[a]);
                          }

                        }


                        Map data = {
                          'lastUpdate': '${DateTime.now()}',
                          'cidData': selectedData

                        };

                        print(jsonEncode(data));

                        checkConnectivityWithToggle(widget.patientDetailsData.hospital[0].sId).then((internet) {
                          if (internet != null && internet) {

                            _controller.saveData(widget.patientDetailsData, data).then((value){
                              _historyController.saveMultipleMsgHistory(
                                  widget.patientDetailsData.sId,
                                  ConstConfig.diagnosisHistoryMultiple, selectedData);
                            });

                          }else{
                            _controller.saveDataOffline(widget.patientDetailsData, selectedData);
                          }
                        });





                        // Get.back();
                      },
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 30.0,),
          ],
        ),
        );
  }

  Widget _appbarwidget() {
    return AppBar(
        title: Text(
          "diagnosis".tr,
          style: TextStyle(color: card_color),
        ),
        centerTitle: true,
        elevation: 1,
        backgroundColor: primary_color,
        iconTheme: IconThemeData(color: card_color),
        bottom: PreferredSize(
          //Here is the preferred height.
            preferredSize: Size.fromHeight(70.0),
            child: SafeArea(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(child: _buildSearchField()),
                        SizedBox(
                          width: 10,
                        ),
                        Row(
                          // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Text(
                              'sort_by'.tr,
                              style: TextStyle(color: card_color, fontSize: 15),
                            ),
                            PopupMenuButton<String>(
                              key: _key,
                              icon: Icon(
                                Icons.arrow_drop_down,
                                color: card_color,
                                size: 30,
                              ),
                              itemBuilder: (context) {
                                return <PopupMenuEntry<String>>[
                                  PopupMenuItem(
                                    child: Text('A to Z'),
                                    value: 'A to Z',
                                  ),
                                  PopupMenuItem(
                                    child: Text('Z to A'),
                                    value: 'Z to A',
                                  ),
                                ];
                              },
                              onSelected: (value) {
                                print(value);
                               setState(() {
                                 if(value=='A to Z'){
                                   print('abc format');
                                   // _controller.patientslList
                                   _cidData.sort((a, b) {
                                     return a.cidname.toString().toLowerCase().compareTo(b.cidname.toString().toLowerCase());
                                   });
                                 }else{
                                   _cidData.sort((b, a) {
                                     return a.cidname.toString().toLowerCase().compareTo(b.cidname.toString().toLowerCase());
                                   });
                                   // _controller.patientslList.sort((a, b) => a.compareTo(b));
                                 }
                               });
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                ],
              ),
            )));
  }



  String searchController = '';
  Widget _buildSearchField() {
    return
      Container(
        height: 40,
        decoration: BoxDecoration(
          color: card_color,
          borderRadius: new BorderRadius.circular(10.0),
        ),
        child: Row(
          children: [
        Flexible(child:   Padding(
            padding: EdgeInsets.only(left: 30, right: 10, top: 0),
            child: TextFormField(
              textInputAction: TextInputAction.done,
              onFieldSubmitted: (value){
                FocusScope.of(context).requestFocus(FocusNode());},
              autofocus: false,
              focusNode: focusNode,
              // controller: searchController,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: 'search'.tr,
                // suffixIcon: Icon(Icons.search),
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
            )),flex: 6,),
            Padding(padding: EdgeInsetsDirectional.only(top: 2,bottom: 2),child: VerticalDivider(color: Colors.black, width: 20,),),
            Flexible(child: GestureDetector(child: Icon(Icons.search),onTap: (){
              getsearch();
            },),flex: 1,)
        ],));
  }






}
