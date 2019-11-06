import 'package:flutter/material.dart';
import 'package:mi_primera_app/app/common_widgets/avatar.dart';
import 'package:mi_primera_app/app/common_widgets/platform_alert_dialog.dart';
import 'package:mi_primera_app/services/auth.dart';
import 'package:provider/provider.dart';

class AccountPage extends StatelessWidget {
  Future<void> _signOut(BuildContext context) async {
    try {
      final auth = Provider.of<AuthBase>(context);
      await auth.signOut();
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> _confirmSignOut(BuildContext context) async {
    final didRequestSignOut = await PlatformAlertDialog(
      title: 'Cerrar sesión',
      content: 'Seguro que quieres cerrar sesion?',
      cancelActionText: 'Cancelar',
      defaultActionText: 'Cerrar sesión',
    ).show(context);
    if (didRequestSignOut == true) {
      _signOut(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Account'),
        actions: <Widget>[
          FlatButton(
            child: Text(
              'Cerrar Sesión',
              style: TextStyle(fontSize: 18.0, color: Colors.white),
            ),
            onPressed: () => _confirmSignOut(context),
          )
        ],
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(130),
          child: _buildUserInfo(user),
        ),
      ),
    );
  }

  Widget _buildUserInfo(User user) {
    return Column(
      children: <Widget>[
        Avatar(
          photoUrl: user.photoUrl,
          radius: 50,
        ),
        SizedBox(height: 8),
        if (user.runtimeType != null)
          Text(user.displayName, style: TextStyle(color: Colors.white)),
        SizedBox(height: 8),
      ],
    );
  }
}
