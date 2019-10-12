import 'package:flutter/foundation.dart';
import 'package:mi_primera_app/app/sign_in/email_sign_in_model.dart';
import 'package:mi_primera_app/app/sign_in/validators.dart';
import 'package:mi_primera_app/services/auth.dart';

class EmailSignInChangeModel with EmailAndPasswordValidators, ChangeNotifier {
  EmailSignInChangeModel(
      {@required this.auth,
      this.email = '',
      this.password = '',
      this.formType = EmailSignImFormType.signIn,
      this.isLoading = false,
      this.submitted = false});
  final AuthBase auth;
  String email;
  String password;
  EmailSignImFormType formType;
  bool isLoading;
  bool submitted;

  Future<void> submit() async {
    updateWith(submitted: true, isLoading: true);
    try {
      if (formType == EmailSignImFormType.signIn) {
        await auth.signInWithEmailAndPassword(email, password);
      } else {
        await auth.createUserWithEmailAndPassword(email, password);
      }
    } catch (e) {
      rethrow;
    } finally {
      updateWith(isLoading: false);
    }
  }

  String get primaryButtonText {
    return formType == EmailSignImFormType.signIn
        ? 'Inicia sesión'
        : 'Crear cuenta';
  }

  String get secondaryButtonText {
    return formType == EmailSignImFormType.signIn
        ? 'No tienes cuenta? Registrate'
        : 'Ya tienes una cuenta? Inicia sesión';
  }

  bool get canSubmit {
    return emailValidator.isValid(email) &&
        emailValidator.isValid(password) &&
        !isLoading;
  }

  String get passwordErrorText {
    bool showErrorText = submitted && !passwordValidator.isValid(password);
    return showErrorText ? invalidPasswordErrorText : null;
  }

  String get emailErrorText {
    bool showErrorText = submitted && !emailValidator.isValid(email);
    return showErrorText ? invalidEmailErrorText : null;
  }

  void toogleFormType() {
    final formType = this.formType == EmailSignImFormType.signIn
        ? EmailSignImFormType.register
        : EmailSignImFormType.signIn;
    updateWith(
      email: '',
      password: '',
      formType: formType,
      isLoading: false,
      submitted: false,
    );
  }

  void updateEmail(String email) => updateWith(email: email);

  void updatePassword(String password) => updateWith(password: password);

  void updateWith(
      {String email,
      String password,
      EmailSignImFormType formType,
      bool isLoading,
      bool submitted}) {
    this.email = email ?? this.email;
    this.password = password ?? this.password;
    this.formType = formType ?? this.formType;
    this.isLoading = isLoading ?? this.isLoading;
    this.submitted = submitted ?? this.submitted;
    notifyListeners();
  }
}
