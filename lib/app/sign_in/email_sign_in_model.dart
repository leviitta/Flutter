import 'package:mi_primera_app/app/sign_in/validators.dart';

enum EmailSignImFormType { signIn, register }

class EmailSignInModel with EmailAndPasswordValidators {
  EmailSignInModel(
      {this.email = '',
      this.password = '',
      this.formType = EmailSignImFormType.signIn,
      this.isLoading = false,
      this.submitted = false});
  final String email;
  final String password;
  final EmailSignImFormType formType;
  final bool isLoading;
  final bool submitted;

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

  EmailSignInModel copyWith(
      {String email,
      String password,
      EmailSignImFormType formType,
      bool isLoading,
      bool submitted}) {
    return EmailSignInModel(
      email: email ?? this.email,
      password: password ?? this.password,
      formType: formType ?? this.formType,
      isLoading: isLoading ?? this.isLoading,
      submitted: submitted ?? this.submitted,
    );
  }
}
