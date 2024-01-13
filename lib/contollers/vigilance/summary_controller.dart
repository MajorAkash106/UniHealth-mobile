import 'package:get/get.dart';
import 'package:medical_app/config/funcs/vigilanceFunc.dart';
import 'package:medical_app/contollers/vigilance/pressure_controller.dart';
import 'package:medical_app/model/patientDetailsModel.dart';
import 'package:medical_app/model/vigilance/vigilance_model.dart';
import 'package:medical_app/screens/badges/Vigilance/boxes/temp&Glycemia/temp_GlycemiaController.dart';

class Summary extends GetxController {
  final Temp_GlycemiaController temp_glycemiaController =
      Temp_GlycemiaController();
  final PressureController _pressureController = PressureController();

  Future<List<String>> getData(PatientDetailsData data) async {
    List<int> _fluidData = [];
    _fluidData = await getFluidBalanceData(data);

    List<String> output = [];
    if (!_fluidData.isNullOrBlank) {
      String current =
          '${'current_work_day'.tr}: ${_fluidData[1].isNegative ? '' : "+"}${_fluidData[1]} mL';

      String last =
          '${'last_work_day'.tr}: ${_fluidData[0].isNegative ? '' : "+"}${_fluidData[0]} mL';

      output.add(current);
      output.add(last);
    }

    return output;
  }

  Future<String> getPressureStatus(PatientDetailsData data) async {
    Vigilance vigilance = await _pressureController.getPressureUlcer(data)??null;

    if(vigilance != null){


    }

  }
}
