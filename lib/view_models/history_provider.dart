import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_ebook_app/database/history_helper.dart';

class HistoryProvider extends ChangeNotifier {
  List history = [];
  var db = HistoryDB();

  StreamSubscription<List>? _streamSubscription;

  Future<void> listen() async {
    if (_streamSubscription != null) {
      _streamSubscription!.cancel();
      _streamSubscription = null;
    }
    _streamSubscription = (await db.listAllStream()).listen(
      (books) => history = books,
    );
  }

  @override
  void dispose() {
    if (_streamSubscription != null) {
      _streamSubscription!.cancel();
      _streamSubscription = null;
    }
    super.dispose();
  }

  Future<Stream<List>> getHistoryStream() async {
    Stream<List<dynamic>> all = await db.listAllStream();
    return all;
  }

  void setHistory(value) {
    history = value;
    notifyListeners();
  }
}
