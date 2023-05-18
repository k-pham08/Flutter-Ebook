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
          translator
              .translate(element.title!, to: 'vi')
              .then((value) => element.title = value.text);
        } catch (e) {
          element.title = 'Chưa xác định';
        }
      }
      for (var entry in popular.feed!.entry!) {
        for (var element in entry.category!) {
          try {
            var category = translator.translate(element.label!, to: 'vi');
            category.then((value) => element.label = value.text);
          } catch (e) {
            element.label = 'Chưa xác định';
          }
        }
      }
      setTop(popular);
      CategoryFeed newReleases = await api.getCategory(Api.recent);
      for (int index = 0; index < newReleases.feed!.entry!.length; index++) {
        var element = newReleases.feed!.entry![index];
        try {
          var first_part = element.summary!.t!.substring(0, 100);
          var rest_part = element.summary!.t!
              .substring(100, element.summary!.t!.toString().length);
          var translation = await translator.translate(first_part, to: 'vi');
          translator.translate(rest_part, to: 'vi').then(
              (value) => element.summary!.t = translation.text + value.text);

          ;
          for (var ele in element.category!) {
            try {
              var category = translator.translate(ele.label!, to: 'vi');
              category.then((value) => ele.label = value.text);
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
