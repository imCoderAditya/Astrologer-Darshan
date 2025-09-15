class EndPoint {
  //Base url
  static const baseurl = "https://astroapi.veteransoftwares.com/api";
  // auth

  static const getConsultationSessions =
      "$baseurl/GetConsultations/get_consultation_sessions";
  static const statusUpdate = "$baseurl/Consultation/update_Status";
  static const sendOTP = "$baseurl/Login/SendOtp";
  static const otpVerify = "$baseurl/Login/LoginUser";
  static const fetchProfile = "$baseurl/Profile/UserProfile";
  static const goLive = "$baseurl/LiveSession/Create";

  //Wallet Astrologer
  static const astrologerWallet = "$baseurl/Wallet/Astrologer_Wallet";
  // Notification
  static const notifiaction = "$baseurl/Notification/GetUnread";
  static const readNotification = "$baseurl/Notification/MarkAsRead";
  //LiveSession/UpdateStatus
  static const liveSessionUpdateStatus = "$baseurl/LiveSession/UpdateStatus";

  // Register Astrologer

  static const registerAstrologer = "$baseurl/AstroReg/RegisterAstrologer1";
}
