import 'package:flutter/material.dart';
import 'screens/Services/fotgotpassword.dart';
import 'screens/login.dart';
import 'screens/register.dart';
import 'screens/Passenger/passengernavigation.dart';
import 'screens/Verifier/verifiernavigation.dart';

class AppRoutes{
  AppRoutes._();

  static const String authLogin = '/auth-login';
  static const String authRegister = '/auth-Register';
  static const String authVerifier = '/auth-Verifier';
  static const String authPassenger = '/auth-Passenger';
   static const String authForgetPassword = '/auth-ForgetPassword';

  static Map<String, WidgetBuilder> define(){
    return{
      authLogin: (context) => LoginScreen(),
      authRegister: (context) => RegisterScreen(),
      authVerifier: (context) => VerifierNav(),
      authPassenger: (context) => Passenger(),
      authForgetPassword: (context) => ForgetPasswordScreen(),
    };
  }
}


