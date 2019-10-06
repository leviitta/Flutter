import 'package:flutter/material.dart';
import 'package:mi_primera_app/app/common_widgets/form_submit_button.dart';
import 'package:mi_primera_app/app/sign_in/validators.dart';
import 'package:mi_primera_app/services/auth.dart';

enum EmailSignImFormType { signIn, register }

class EmailSignInForm extends StatefulWidget with EmailAndPasswordValidators{
  EmailSignInForm({@required this.auth});
  final AuthBase auth;
  @override
  _EmailSignInFormState createState() => _EmailSignInFormState();
}

class _EmailSignInFormState extends State<EmailSignInForm> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();
  String get _email => _emailController.text;
  String get _password => _passwordController.text;
  EmailSignImFormType _formType = EmailSignImFormType.signIn;
  bool _submitted = false;
  bool _isLoading = false;

  void _submit() async {
    setState(() {
     _submitted = true;
     _isLoading = true;
    });
    try{
      if(_formType == EmailSignImFormType.signIn){
        await widget.auth.signInWithEmailAndPassword(_email, _password);
      }else{
        await widget.auth.createUserWithEmailAndPassword(_email, _password);
      }
      Navigator.of(context).pop();
    }catch(e){
      print(e.toString());
    } finally{
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _emailEditingComplete(){
    final newFocus = widget.emailValidator.isValid(_email) ? _passwordFocusNode : _emailFocusNode;
    FocusScope.of(context).requestFocus(newFocus);
  }

  void _toggleFormType() {
    setState(() {
      _submitted = false;
      _formType = _formType == EmailSignImFormType.signIn
          ? EmailSignImFormType.register
          : EmailSignImFormType.signIn;
    });
    _emailController.clear();
    _passwordController.clear();
  }

  List<Widget> _buildChildren() {
    final primaryText = _formType == EmailSignImFormType.signIn
        ? 'Inicia sesión'
        : 'Crear cuenta';
    final secondaryText = _formType == EmailSignImFormType.signIn
        ? 'No tienes cuenta? Registrate'
        : 'Ya tienes una cuenta? Inicia sesión';

    bool submitEnabled = widget.emailValidator.isValid(_email) && widget.emailValidator.isValid(_password) && !_isLoading;

    return [
       _buildEmailTextField(),
      SizedBox(height: 8.0),
      _buildPasswordTextField(),
      SizedBox(height: 8.0),
      FormSubmitButton(
        text: primaryText,
        onPressed: submitEnabled ? _submit : null,
      ),
      SizedBox(height: 8.0),
      FlatButton(
        child: Text(secondaryText),
        onPressed: !_isLoading ? _toggleFormType : null,
      ),
    ];
  }

  TextField _buildEmailTextField(){
    bool showErrorText = _submitted && !widget.emailValidator.isValid(_email);
    return TextField(
        controller: _emailController,
        focusNode: _emailFocusNode,
        decoration: InputDecoration(
          labelText: 'Email',
          hintText: 'test@test.com',
          errorText: showErrorText ? widget.invalidEmailErrorText: null,
          enabled: _isLoading == false,
        ),
        autocorrect: false,
        keyboardType: TextInputType.emailAddress,
        textInputAction: TextInputAction.next,
        onChanged: (email) => _updateState(),
        onEditingComplete: _emailEditingComplete,
      );
  }

  TextField _buildPasswordTextField(){
    bool showErrorText = _submitted && !widget.passwordValidator.isValid(_password);
    return TextField(
        controller: _passwordController,
        focusNode: _passwordFocusNode,
        decoration: InputDecoration(
          labelText: 'Contraseña',
          errorText: showErrorText ? widget.invalidPasswordErrorText: null,
          enabled: _isLoading == false,
        ),
        obscureText: true,
        textInputAction: TextInputAction.done,
        onChanged: (password) => _updateState(),
        onEditingComplete: _submit,
      );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: _buildChildren(),
      ),
    );
  }

  void _updateState() {
    setState(() {});
  }
}
