import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_ebook_app/database/favorite_helper.dart';

class FavoritesProvider extends ChangeNotifier {
  List favorites = [];
  var db = FavoriteDB();
  var status = false;

  StreamSubscription<List>? _streamSubscription;

  Future<void> listen() async {
    if (_streamSubscription != null) {
      _streamSubscription!.cancel();
      _streamSubscription = null;
    }
    _streamSubscription = (await db.listAllStream()).listen(
      (books) => favorites = books,
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

  Future<Stream<List>> getFavoritesStream() async {
    Stream<List<dynamic>> all = await db.listAllStream();
    setStatus(true);
    print(all);
    return all;
  }

  void setFavorites(value) {
    favorites = value;
    notifyListeners();
  }

  void setStatus(value) {
    status = value;
    notifyListeners();
  }
}
