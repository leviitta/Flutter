import 'package:flutter/material.dart';
import 'package:mi_primera_app/app/common_widgets/custom_raised_button.dart';

class SignInPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var scaffold = Scaffold(
      appBar: AppBar(
        title: Text('time Tracker'),
        elevation: 10.0,
      ),
      body: _buildContent(),
      backgroundColor: Colors.grey[200],
    );
    return scaffold;
  }

  Widget _buildContent() {
    return Padding(
      padding: EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Text(
            'Ingreso',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 32.0,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 8.0),
          CustomRaisedButton(
            child: Text(
              'Ingresa con Google',
              style: TextStyle(
                color: Colors.black87,
                fontSize: 15.0
              ),
            ),
            color: Colors.white,
            borderRadius: 4.0,
            onPressed: (){},
          ),
        ],
      ),
    );
  }
}
