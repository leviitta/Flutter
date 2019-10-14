import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mi_primera_app/app/common_widgets/platform_alert_dialog.dart';
import 'package:mi_primera_app/app/common_widgets/platform_exception_alert_dialog.dart';
import 'package:mi_primera_app/app/home/jobs/edit_job_page.dart';
import 'package:mi_primera_app/app/home/jobs/jobs_list_tile.dart';
import 'package:mi_primera_app/app/home/jobs/list_items_buider.dart';
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

  Future<void> _delete(BuildContext context, Job job) async{
    try{
      final database = Provider.of<Database>(context);
      await database.deleteJob(job);
    }on PlatformException catch(e){
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
        onPressed: () => EditJobPage.show(context),
      ),
    );
  }

  Widget _buildContents(BuildContext context) {
    final database = Provider.of<Database>(context);
    return StreamBuilder<List<Job>>(
      stream: database.jobsStream(),
      builder: (context, snapshot) {
        return ListItemBuilder<Job>(
          snapshot: snapshot,
          itemBuilder: (context, job) => Dismissible(
            key: Key('job-${job.id}'),
            background: Container(color: Colors.red),
            direction: DismissDirection.endToStart,
            onDismissed: (direction) => _delete(context, job),
            child: JobListTile(
              job: job,
              ontap: () => EditJobPage.show(context, job: job),
            ),
          ),
        );
      },
    );
  }
}
