import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mi_primera_app/app/home/models/job.dart';

class JobListTile extends StatelessWidget {

  JobListTile({Key key,@required this.job, this.ontap}): super(key:key);
  final Job job;
  final VoidCallback ontap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(job.name),
      trailing: Icon(Icons.chevron_right),
      onTap: ontap,
    );
  }
}