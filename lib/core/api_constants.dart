class ApiConstants {
  static const String baseUrl = "https://api.togtokh.dev";

  // Authentication Endpoints
  static const String loginEndpoint = "/main/auth/v1/user/login";
  static const String verifyTokenEndpoint = "/main/auth/v1/user/verify_token";

  // Signup Endpoints
  static const String signupStep1Endpoint = "/main/auth/v1/user/create/step1";
  static const String signupStep2Endpoint = "/main/auth/v1/user/create/step2";

  // Forgot Password Endpoints
  static const String forgotPasswordRequestEndpoint =
      "/main/auth/v1/user/forgot/mail";
  static const String verifyForgotPasswordEndpoint =
      "/main/auth/v1/user/forgot/code";
  static const String resetPasswordEndpoint =
      "/main/auth/v1/user/forgot/password";
}
