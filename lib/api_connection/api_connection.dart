class API {
  static const hostConnect = "http://192.168.1.61/api_attendance_app";

  static const hostConnectUser = "$hostConnect/user";

  static const login = "$hostConnect/user/login.php";
  static const updateProfile = "$hostConnect/user/update_profile.php";
  static const getData = "$hostConnect/user/get_Data.php";
  static const forgotPassword = "$hostConnect/user/forgot_password.php";
  static const verifyCode = "$hostConnect/user/verify_code.php";
  static const resetPassword = "$hostConnect/user/reset_password.php";
  static const sendEmailCode = "$hostConnect/user/email_code.php";
  static const changeEmail = "$hostConnect/user/change_email.php";
  static const getRecord = "$hostConnect/user/get_record.php";
  static const getTop5Record = "$hostConnect/user/get_top_five_records.php";
  static const getCountTotalRecords =
      "$hostConnect/user/count_total_records.php";
  static const getCountMonthRecords =
      "$hostConnect/user/count_month_records.php";
}
