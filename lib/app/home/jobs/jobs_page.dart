import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mi_primera_app/app/common_widgets/platform_exception_alert_dialog.dart';
import 'package:mi_primera_app/app/home/job_entries/job_entries_page.dart';
import 'package:mi_primera_app/app/home/jobs/edit_job_page.dart';
import 'package:mi_primera_app/app/home/jobs/jobs_list_tile.dart';
import 'package:mi_primera_app/app/home/jobs/list_items_buider.dart';
import 'package:mi_primera_app/app/home/models/job.dart';
import 'package:mi_primera_app/services/database.dart';
import 'package:provider/provider.dart';

class JobsPage extends StatelessWidget {
  Future<void> _delete(BuildContext context, Job job) async {
    try {
      final database = Provider.of<Database>(context);
      await database.deleteJob(job);
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
          IconButton(
            icon: Icon(Icons.add, color: Colors.white),
            onPressed: () => EditJobPage.show(context,
                database: Provider.of<Database>(context)),
          ),
        ],
      ),
      body: _buildContents(context),
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
              ontap: () => JobEntriesPage.show(context, job),
            ),
          ),
        );
      },
    );
  }
}
