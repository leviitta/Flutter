import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mi_primera_app/app/common_widgets/platform_alert_dialog.dart';
import 'package:mi_primera_app/app/common_widgets/platform_exception_alert_dialog.dart';
import 'package:mi_primera_app/app/home/models/job.dart';
import 'package:mi_primera_app/services/auth.dart';
import 'package:mi_primera_app/services/database.dart';
import 'package:provider/provider.dart';

class JobsPage extends StatelessWidget {
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

  Future<void> _createJob(BuildContext context) async {
    try {
      final database = Provider.of<Database>(context);
      await database.createJob(Job(name: 'Blogging', ratePerHour: 12));
    } on PlatformException catch (e) {
      PlatformExceptionAlertDialog(
        title: 'Operation failed',
        exception: e,
      ).show(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Matronas'),
        actions: <Widget>[
          FlatButton(
            child: Text(
              'Cerrar Sesión',
              style: TextStyle(fontSize: 18.0, color: Colors.white),
            ),
            onPressed: () => _confirmSignOut(context),
          )
        ],
      ),
      body: _buildContents(context),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () => _createJob(context),
      ),
    );
  }

  Widget _buildContents(BuildContext context) {
    final database = Provider.of<Database>(context);
    return StreamBuilder<List<Job>>(
      stream: database.jobsStream(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final jobs = snapshot.data;
          final children = jobs.map((job) => Text(job.name)).toList();
          return ListView(children: children);
        }
        if(snapshot.hasError){
          return Center(child: Text('Error'));
        }
        return Center(child: CircularProgressIndicator());
      },
    );
  }
}
