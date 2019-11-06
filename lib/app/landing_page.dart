import 'package:flutter/material.dart';
import 'package:mi_primera_app/app/home/home_page.dart';
import 'package:mi_primera_app/app/sign_in/sign_in_page.dart';
import 'package:mi_primera_app/services/auth.dart';
import 'package:mi_primera_app/services/database.dart';
import 'package:provider/provider.dart';

class LandingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthBase>(context, listen: false);
    return StreamBuilder<User>(
        stream: auth.onAuthStateChanged,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.active) {
            User user = snapshot.data;
            if (user == null) {
              return SignInPage.create(context);
            }
            return Provider<User>.value(
              value: user,
              child: Provider<Database>(
                  builder: (_) => FirestoreDatabase(uid: user.uid),
                  child: HomePage()),
            );
          } else {
            return Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }
        });
  }
}
