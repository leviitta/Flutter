import 'package:flutter/cupertino.dart';
import 'package:mi_primera_app/app/home/models/job.dart';
import 'package:mi_primera_app/services/api_path.dart';
import 'package:mi_primera_app/services/firestore_service.dart';

abstract class Database {
  Future<void> setJob(Job job);
  Future<void> deleteJob(Job job);
  Stream<List<Job>> jobsStream();
}

String documentIdFromCurrentDate() => DateTime.now().toIso8601String();

class FirestoreDatabase implements Database {
  FirestoreDatabase({@required this.uid}) : assert(uid != null);
  final String uid;
  final _service = FirestoreService.instance;

  @override
  Future<void> setJob(Job job) async => await _service.setData(
        path: APIPath.job(uid, job.id),
        data: job.toMap(),
      );

  @override
  Future<void> deleteJob(Job job) async => _service.deleteData(
        path: APIPath.job(uid, job.id),
      );

  @override
  Stream<List<Job>> jobsStream() => _service.collectionsStream(
        path: APIPath.jobs(uid),
        builder: (data, documentId) => Job.fromMap(data, documentId),
      );
}
