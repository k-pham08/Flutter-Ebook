import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_ebook_app/components/book_history_item.dart';
import 'package:flutter_ebook_app/models/category.dart';
import 'package:flutter_ebook_app/view_models/history_provider.dart';
import 'package:provider/provider.dart';

class History extends StatefulWidget {
  @override
  _HistoryState createState() => _HistoryState();
}

class _HistoryState extends State<History> {
  @override
  void initState() {
    super.initState();
    getHistory();
  }

  getHistory() {
    SchedulerBinding.instance.addPostFrameCallback(
      (_) {
        if (mounted) {
          Provider.of<HistoryProvider>(context, listen: false).listen();
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<HistoryProvider>(
      builder: (BuildContext context, HistoryProvider historyProvider,
          Widget? child) {
        return Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: Text(
              'Đã xem',
            ),
          ),
          body: historyProvider.history.isEmpty
              ? _buildEmptyListView()
              : _buildListView(historyProvider),
        );
      },
    );
  }

  _buildEmptyListView() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Image.asset(
            'assets/images/empty.png',
            height: 300.0,
            width: 300.0,
          ),
          Text(
            'Trống',
            style: TextStyle(
              fontSize: 24.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  _buildListView(HistoryProvider historyProvider) {
    return ListView.builder(
      reverse: true,
      padding: EdgeInsets.fromLTRB(10.0, 20.0, 10.0, 0.0),
      shrinkWrap: true,
      itemCount: historyProvider.history.length,
      itemBuilder: (BuildContext context, int index) {
        Entry entry = Entry.fromJson(historyProvider.history[index]['item']);
        String time = historyProvider.history[index]['created_at'];
        return Padding(
          padding: EdgeInsets.symmetric(horizontal: 5.0),
          child: BookHistoryItem(
            entry: entry,
            time: time,
          ),
        );
      },
    );
  }
}
