class APIUrls {
  static const String path = "https://api.unihealth.app/";
  // static const String path = "http://stage.alimentartn.com.br:4000/";

  static const String mainpath = path + "api/";
  static const String ImageUrl = path + "/uploads/profile/";

  static const String signup = mainpath + "user/signUp";
  static const String login = mainpath + "user/signin";
  static const String getUserdetails = mainpath + "user/getUserDetails";
  static const String getSchduleData = mainpath + "user/getSchedule";
  static const String updateSchduleData = mainpath + "user/editScheduleOption";
  static const String getPatientsdetails = mainpath + "user/getPatientDetails";
  static const String getSpictCategory = mainpath + "user/getCategory";
  static const String getSpictData = mainpath + "user/getsubCategory";
  static const String getAkpsData = mainpath + "user/getQuestion";
  static const String getOption = mainpath + "user/getOption";
  static const String EditPatientsdetails = mainpath + "user/eidtprofile";
  static const String getHospitaldetails = mainpath + "user/getAssignhospitalsList";
  static const String getWardList = mainpath + "user/getMultipalUserWards";
  static const String getWardList2 = mainpath + "user/getUserWards";
  static const String getPatients = mainpath + "user/getPatientList";
  static const String getBedList = mainpath + "user/getbedsList";
  static const String getMedicalDivisionList =
      mainpath + "user/getmedicalsList";
  static const String addNewPatient = mainpath + "user/signUp";
  static const String getPatientList = mainpath + "user/getusersList";
  static const String forgotpass = mainpath + "user/forgotPassword";
  static const String changePassword = mainpath + "user/changePassword";
  static const String editProfile = mainpath + "user/editProfile";
  static const String gethospitalsList = mainpath + "user/gethospitalsList";
  static const String notificationONOFF = mainpath + "user/notification";
  static const String getNotificationWard =
      mainpath + "user/getWardNotification";
  static const String wardNotificationOnOff = mainpath + "user/addNotification";
  static const String getHistory = mainpath + "user/getHistory";
  static const String getMultiplePatientHistory = mainpath + "user/getMultiplePatientHistory";
  static const String addHistory = mainpath + "user/addHistory";
  static const String getNutritionalScreen = mainpath + "user/getStatus";
  static const String getNRSQuestions = mainpath + "user/getStatusquestion";
  static const String getCidOption = mainpath + "user/getCid";
  static const String getSpict = mainpath + "user/getspict";
  static const String PostStatus = mainpath + "user/addresult";
  static const String getAnthroQuestion = mainpath + "user/getAuthropometory";
  static const String getGlim = mainpath + "user/getPhenotys";
  static const String addNTResult = mainpath + "user/addNtResult";
  static const String getNutritionParenteral =
      mainpath + "user/getNutritionParenteral";

  static const String addVigiLance = mainpath + "user/addvigilance";

  static const String getConditions = mainpath + "user/getNutritionCondition";

  static const String getDietCategory = mainpath + "user/getNutritionOraldiet";
  static const String getONSDATA = mainpath + "user/getNutritionOns";

  static const String getEnteralFormula = mainpath + "user/getNutritionEnteral";

  static const String getModuleFormula = mainpath + "user/getNutritionModules";

  static const String UpdateDAta = mainpath + "user/updateProfile";
  static const String UpdateDAtaMultiple = mainpath + "user/updateProfiles";

  static const String userRegister = mainpath + "user/signupUser";
  static const String otpVerification = mainpath + "user/verifyOtp";
  static const String createPassword = mainpath + "user/createPassword";
  static const String getAttribution = mainpath + "user/getAttribution";
  static const String updateUserProfile = mainpath + "user/UpdateUserProfile";
  static const String addRequest = mainpath + "user/addRequest";
  static const String editRequest = mainpath + "user/editRequests";
  static const String addEmployee = mainpath + "user/addEmployee";
  static const String verification = mainpath + "user/editUserRequests";

  static const String upDateRequest = mainpath + "user/updateRequest";

  static const String getRequests = mainpath + "user/getRequests";
  static const String getFormulas = mainpath + "user/getFormulas";

  static const String addIdentity = mainpath + "user/addIdentity";
  static const String editIdentity = mainpath + "user/editIdentity";

  static const String assignHosp = mainpath + "user/Assignhospital";

  static const String logout = mainpath + "user/logout";

  static const String saveLang = mainpath + "user/saveLang";
}
