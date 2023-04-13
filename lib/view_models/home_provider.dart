import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ebook_app/models/category.dart';
import 'package:flutter_ebook_app/util/api.dart';
import 'package:flutter_ebook_app/util/enum/api_request_status.dart';
import 'package:flutter_ebook_app/util/functions.dart';
import 'package:translator/translator.dart';

class HomeProvider with ChangeNotifier {
  CategoryFeed top = CategoryFeed();
  CategoryFeed recent = CategoryFeed();
  APIRequestStatus apiRequestStatus = APIRequestStatus.loading;
  Api api = Api();

  getFeeds() async {
    setApiRequestStatus(APIRequestStatus.loading);
    final translator = GoogleTranslator();

    try {
      CategoryFeed popular = await api.getCategory(Api.popular);
      for (var element in popular.feed!.link!) {
        try {
          var des = await translator.translate(element.title!, to: 'vi');
          element.title = des.text;
        } catch (e) {
          element.title = 'Chưa xác định';
        }
      }
      for (var entry in popular.feed!.entry!) {
        for (var element in entry.category!) {
          try {
            var category = await translator.translate(element.label!, to: 'vi');
            element.label = category.text;
          } catch (e) {
            element.label = 'Chưa xác định';
          }
        }
      }
      setTop(popular);
      CategoryFeed newReleases = await api.getCategory(Api.recent);
      for (var element in newReleases.feed!.entry!) {
        try {
          var translation =
              await translator.translate(element.summary!.t!, to: 'vi');
          element.summary!.t = translation.text;
          for (var ele in element.category!) {
            try {
              var category = await translator.translate(ele.label!, to: 'vi');
              ele.label = category.text;
            } catch (e) {
              ele.label = 'Chưa xác định';
            }
          }
        } catch (e) {
          element.summary!.t = '';
        }
      }

      setRecent(newReleases);
      setApiRequestStatus(APIRequestStatus.loaded);
    } catch (e) {
      // print(e);
      checkError(e);
    }
  }

  void checkError(e) {
    if (Functions.checkConnectionError(e)) {
      setApiRequestStatus(APIRequestStatus.connectionError);
    } else {
      setApiRequestStatus(APIRequestStatus.error);
    }
  }

  void setApiRequestStatus(APIRequestStatus value) {
    apiRequestStatus = value;
    notifyListeners();
  }

  void setTop(value) {
    top = value;
    notifyListeners();
  }

  CategoryFeed getTop() {
    return top;
  }

  void setRecent(value) {
    recent = value;
    notifyListeners();
  }

  CategoryFeed getRecent() {
    return recent;
  }
}
