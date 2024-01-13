import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/state_manager.dart';
import 'package:medical_app/config/cons/colors.dart';
import 'package:get/get.dart';
import 'package:medical_app/config/widgets/common_appbar.dart';
import 'package:medical_app/config/widgets/reference_screen.dart';
import 'package:medical_app/config/widgets/unihealth_button.dart';
import 'package:medical_app/contollers/AnthropometryQuestionModel.dart';
import 'package:medical_app/contollers/other_controller/Refference_notes_Controller.dart';



class EDEMAScreen extends StatefulWidget {
  final List<QuestionsData> list;
  final String title;
  final String selected;
  EDEMAScreen({this.list, this.title, this.selected});
  @override
  _EDEMAScreenState createState() => _EDEMAScreenState();
}

class _EDEMAScreenState extends State<EDEMAScreen> {
  Refference_Notes_Controller ref_Controller = Refference_Notes_Controller();
  @override
  void initState() {
    // TODO: implement initState
    print('get list: ${widget.list.length}');
    print('${widget.selected}');
    getSelected();
    super.initState();
  }

  getSelected() {
    for (var a = 0; a < widget.list.length; a++) {
      if (widget.list[a].weight == widget.selected) {
        widget.list[a].selected = true;
        break;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BaseAppbar(
          "${widget.title}",
          widget.title == "edema".tr
              ? null
              : IconButton(
                  icon: Icon(
                    Icons.info_outline,
                    color: card_color,
                  ),
                  onPressed: () {
                    Get.to(ReferenceScreen(
                      Ref_list: widget.title == 'ascites'.tr
                          ? ref_Controller.ASCITES_Ref_list
                          : [],
                    ));
                  },
                )),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 20,
          ),
          Expanded(
            child: ListView.builder(
                shrinkWrap: true,
                itemCount: widget.list.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(
                        left: 20.0, top: 12.0, bottom: 12.0, right: 20.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            InkWell(
                              child: Card(
                                child: Container(
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                            color: widget.list[index].selected
                                                ? Colors.green
                                                : Colors.black.withAlpha(100)),
                                        borderRadius:
                                            BorderRadius.circular(5.0)),
                                    child: widget.list[index].selected
                                        ? Icon(Icons.check,
                                            size: 20.0, color: Colors.green)
                                        : Icon(
                                            Icons.check,
                                            size: 18.0,
                                            color: Colors.transparent,
                                          )),
                                elevation: 4.0,
                              ),
                              onTap: () {
                                print('tap');
                                setState(() {
                                  // for(var a= 0; a<widget.list.length;a++){
                                  //   widget.list[a].selected = false;
                                  // }
                                  widget.list[index].selected =
                                      !widget.list[index].selected;

                                  for (var a = 0; a < widget.list.length; a++) {
                                    if (widget.list[a].sId ==
                                        widget.list[index].sId) {
                                      widget.list[a].selected =
                                          widget.list[index].selected;
                                    } else {
                                      widget.list[a].selected = false;
                                    }
                                  }
                                });
                              },
                            ),
                            // SizedBox(height:15.0,)
                          ],
                        ),
                        SizedBox(
                          width: 5.0,
                        ),
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Container(
                                width: MediaQuery.of(context).size.width,
                                child: Padding(
                                  padding: const EdgeInsets.only(top: 4.0),
                                  child: Text(
                                    widget.list[index].title,
                                    style: TextStyle(
                                        fontWeight: FontWeight.normal,
                                        color: Colors.black54,
                                        fontSize: 14),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  );
                }),
          ),
          //Spacer(),
          SizedBox(
            height: 30.0,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 25.0, right: 25.0),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    height: 50.0,
                    width: MediaQuery.of(context).size.width,
                    child: RaisedButton(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0)),
                      color: primary_color,
                      child: Center(
                        child: Text(
                          'save'.tr,
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      onPressed: () {
                        bool selected = false;

                        for (var b = 0; b < widget.list.length; b++) {
                          if (widget.list[b].selected) {
                            print(widget.list[b].weight);
                            selected =true;
                            // Get.back(result: widget.list[b].weight);
                            break;
                          }else{
                            selected =false;
                          }
                        }

                        print('selected: $selected');

                        if(selected){
                          for(var a=0;a<widget.list.length;a++){

                            if(widget.list[a].selected){

                              print(widget.list[a].weight);
                              Get.back(result: widget.list[a].weight);
                              break;
                            }

                          }
                        }else{
                          Get.back(result: '');
                        }


                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 30.0,
          ),
        ],
      ),
    );
  }
}

class Edema {
  String Agreement_desc;
  bool selected;
  Edema(this.selected, this.Agreement_desc);
}
