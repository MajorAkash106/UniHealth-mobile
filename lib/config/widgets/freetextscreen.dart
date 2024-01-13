import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:medical_app/config/cons/colors.dart';
import 'package:medical_app/config/widgets/buttons.dart';
import 'package:medical_app/config/widgets/common_appbar.dart';
import 'package:medical_app/config/widgets/multi_text_fields.dart';

class FreeTextScreen extends StatefulWidget {
  final String text;
  final String fillValue;
  final Function function;
  final TextEditingController controller;

  FreeTextScreen({this.text, this.fillValue, this.function, this.controller});

  @override
  _FreeTextScreenState createState() => _FreeTextScreenState();
}

class _FreeTextScreenState extends State<FreeTextScreen> {
  @override
  void initState() {
    // TODO: implement initState
    setState(() {
      widget.controller.text = widget.fillValue ?? '';
    });
    super.initState();
  }

  FocusNode _focus = new FocusNode();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BaseAppbar("${widget.text}", null),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          child: ListView(
            children: [
              SizedBox(
                height: 20,
              ),
              Center(
                child: Text(
                  "please_describe".tr.toUpperCase(),
                  style: TextStyle(fontSize: 16, color: appbar_icon_color),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              _widget()
            ],
          ),
        ),
      ),
    );
  }

  Widget _widget() {
    return Column(
      children: [
        // Container(
        //   // width: Get.width/1.3,
        //   child: Card(
        //     color: card_color,
        //     shape: RoundedRectangleBorder(
        //         borderRadius: BorderRadius.all(Radius.circular(15)),
        //         side: BorderSide(width: 1, color: primary_color)
        //     ),
        //     child: Column(
        //       mainAxisAlignment: MainAxisAlignment.start,
        //       crossAxisAlignment: CrossAxisAlignment.start,
        //       children: [
        //         Container(
        //           decoration: BoxDecoration(
        //               color: primary_color,
        //               borderRadius: BorderRadius.only(
        //                   topLeft: Radius.circular(15.0),
        //                   topRight: Radius.circular(15.0))),
        //           child: Padding(
        //             padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
        //             child: Row(
        //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //               children: [
        //                 Text(
        //                   '${widget.text}',
        //                   style: TextStyle(
        //                     color: card_color,
        //                     fontSize: 16,
        //                     fontWeight: FontWeight.normal,
        //                   ),
        //                 ),
        //               ],
        //             ),
        //           ),
        //         ),
        //         _textarea()
        //       ],
        //     ),
        //   ),
        // ),
        _textarea(),
        SizedBox(
          height: 50,
        ),
        Container(
            width: Get.width,
            child: CustomButton(
                text: "save".tr,
                myFunc: () {
                  _focus.unfocus();
                  widget.function();
                }))
      ],
    );
  }

  Widget _textarea() {
    return TextField(
      autofocus: false,
      focusNode: _focus,
      style: TextStyle(
        color: Colors.black87,
      ),
      decoration: InputDecoration(
          hintText: 'type_here'.tr,
          border: OutlineInputBorder(
              borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(15.0),
            bottomRight: Radius.circular(15.0),
            topLeft: Radius.circular(15.0),
            topRight: Radius.circular(15.0),
          )),
          // filled: true,
          fillColor: Colors.grey),
      maxLines: 7,
      controller: widget.controller,
    );
  }
}
