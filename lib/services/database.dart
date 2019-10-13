import 'package:flutter/cupertino.dart';
import 'package:mi_primera_app/app/home/models/job.dart';
import 'package:mi_primera_app/services/api_path.dart';
import 'package:mi_primera_app/services/firestore_service.dart';

abstract class Database {
  Future<void> createJob(Job job);
  Stream<List<Job>> jobsStream();
}

class FirestoreDatabase implements Database {
  FirestoreDatabase({@required this.uid}) : assert(uid != null);
  final String uid;
  final _service = FirestoreService.instance;

  Future<void> createJob(Job job) async => await _service.setData(
        path: APIPath.job(uid, 'job_abc'),
        data: job.toMap(),
      );

  Stream<List<Job>> jobsStream() => _service.collectionsStream(
        path: APIPath.jobs(uid),
        builder: (data) => Job.fromMap(data),
      );
}
