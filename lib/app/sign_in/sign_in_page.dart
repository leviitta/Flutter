import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mi_primera_app/app/common_widgets/platform_exception_alert_dialog.dart';
import 'package:mi_primera_app/app/sign_in/email_sign_in_page.dart';
import 'package:mi_primera_app/app/sign_in/sign_in_manager.dart';
import 'package:mi_primera_app/app/sign_in/sign_in_button.dart';
import 'package:mi_primera_app/app/sign_in/social_sign_in_button.dart';
import 'package:mi_primera_app/services/auth.dart';
import 'package:provider/provider.dart';

class SignInPage extends StatelessWidget {
  const SignInPage({Key key, @required this.manager, @required this.isLoading})
      : super(key: key);
  final SignInManager manager;
  final bool isLoading;

  static Widget create(BuildContext context) {
    final auth = Provider.of<AuthBase>(context);
    return Provider<ValueNotifier<bool>>(
      builder: (context) => ValueNotifier<bool>(false),
      dispose: (context, valueNotifier) => valueNotifier.dispose(),
      child: Consumer<ValueNotifier<bool>>(
        builder: (context, valueNotifier, _) => Provider<SignInManager>(
          builder: (_) => SignInManager(auth: auth, isLoading: valueNotifier),
          child: Consumer<SignInManager>(
            builder: (context, manager, _) => ValueListenableBuilder<bool>(
              valueListenable: valueNotifier,
              builder: (context, isLoading, _) => SignInPage(
                manager: manager,
                isLoading: isLoading,
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _showSignInError(BuildContext context, PlatformException exception) {
    PlatformExceptionAlertDialog(
      title: 'Sign in failed',
      exception: exception,
    ).show(context);
  }

  Future<void> _signInAnonymously(BuildContext context) async {
    try {
      await manager.signInAnonymously();
    } on PlatformException catch (e) {
      print(e.toString());
    }
  }

  Future<void> _signInWithGoogle(BuildContext context) async {
    try {
      await manager.signInWithGoogle();
    } on PlatformException catch (e) {
      if (e.message != 'ERROR_ABORTED_BY_USER') {
        _showSignInError(context, e);
      }
    }
  }

  Future<void> _signInWithFacebook(BuildContext context) async {
    try {
      await manager.signInWithFacebook();
    } on PlatformException catch (e) {
      if (e.message != 'ERROR_ABORTED_BY_USER') {
        _showSignInError(context, e);
      }
    }
  }

  void _signInWithEmail(BuildContext context) async {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        fullscreenDialog: true,
        builder: (context) => EmailSignInPage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Matroneria'),
        elevation: 10.0,
      ),
      body: _buildContent(context),
      backgroundColor: Colors.grey[200],
    );
  }

  Widget _buildContent(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          SizedBox(
            height: 50.0,
            child: _buidHeader(),
          ),
          SizedBox(height: 48.0),
          SocialSignInButton(
            assetName: 'images/google-logo.png',
            text: 'Ingresa con Google',
            textColor: Colors.black87,
            color: Colors.white,
            onPressed: isLoading ? null : () => _signInWithGoogle(context),
          ),
          SizedBox(height: 8.0),
          SocialSignInButton(
            assetName: 'images/facebook-logo.png',
            text: 'Ingresa con FaceBook',
            textColor: Colors.white,
            color: Color(0xFF334D92),
            onPressed: isLoading ? null : () => _signInWithFacebook(context),
          ),
          SizedBox(height: 8.0),
          SignInButton(
            text: 'Ingresa con Email',
            textColor: Colors.white,
            color: Colors.teal[700],
            onPressed: isLoading ? null : () => _signInWithEmail(context),
          ),
          SizedBox(height: 8.0),
          Text(
            'or',
            style: TextStyle(fontSize: 14.0, color: Colors.black87),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 8.0),
          SignInButton(
            text: 'Ingreso anonimo',
            textColor: Colors.white,
            color: Colors.teal[700],
            onPressed: () => _signInAnonymously(context),
          ),
        ],
      ),
    );
  }

  Widget _buidHeader() {
    if (isLoading) {
      return Center(
        child: CircularProgressIndicator(),
      );
    }
    return Text(
      'Inicio sesión',
      textAlign: TextAlign.center,
      style: TextStyle(
        fontSize: 32.0,
        fontWeight: FontWeight.w600,
      ),
    );
  }
}
