import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:mi_primera_app/app/common_widgets/platform_alert_dialog.dart';

class PlatformExceptionAlertDialog extends PlatformAlertDialog {
  PlatformExceptionAlertDialog({
    @required String title,
    @required PlatformException exception,
  }) : super(title: title, content: _message(exception), defaultActionText: 'OK');

  static String _message(PlatformException exception){
    return _errors[exception.code] ?? exception.message;
  }

  static Map<String,String> _errors = {
  'ERROR_OPERATION_NOT_ALLOWED' : "Cuentas anónimas no habilitadas." ,
  'ERROR_WEAK_PASSWORD' : 'Contraseña no es lo suficientemente segura.' ,
  'ERROR_INVALID_EMAIL' : 'Correo electrónico está mal formada.',
  'ERROR_EMAIL_ALREADY_IN_USE' : 'Correo electrónico ya está en uso por una cuenta diferente.',
  'ERROR_INVALID_EMAIL' : 'Correo electrónico está mal formada',
  'ERROR_USER_NOT_FOUND' : 'Ningún usuario correspondiente a la dirección de correo electrónico dada.',
  'ERROR_NOT_ALLOWED' : 'Indica que el correo electrónico y las cuentas de enlace de inicio de sesión no están habilitadas.',
  'ERROR_DISABLED' : 'Cuenta de usuario está deshabilitada.',
  'ERROR_INVALID' :  'Correo electrónico no válido.',
  'ERROR_INVALID_EMAIL' :  'Dirección de correo electrónico está mal formada.',
  'ERROR_WRONG_PASSWORD' : 'La contraseña es incorrecta.',
  'ERROR_USER_NOT_FOUND' :  'Ningún usuario correspondiente a la dirección de correo electrónico especificada, o el usuario ha sido eliminado.',
  'ERROR_USER_DISABLED' : 'Usuario ha sido deshabilitado',
  'ERROR_TOO_MANY_REQUESTS' : 'Demasiados intentos para iniciar sesión con este usuario.',
  'ERROR_OPERATION_NOT_ALLOWED' : 'Cuenta de correo electrónico y contraseña no están habilitadas.',
  'ERROR_INVALID_CREDENTIAL' : 'Datos de credenciales están mal formados o han expirado.',
  'ERROR_USER_DISABLED' : 'El usuario ha sido deshabilitado.',
  };
}
