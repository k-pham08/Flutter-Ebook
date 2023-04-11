import 'package:flutter/material.dart';
import 'package:flutter_ebook_app/components/loading_widget.dart';
import 'package:flutter_ebook_app/util/functions.dart';

class DescriptionTextWidget extends StatefulWidget {
  final String text;

  DescriptionTextWidget({required this.text});

  @override
  _DescriptionTextWidgetState createState() => _DescriptionTextWidgetState();
}

class _DescriptionTextWidgetState extends State<DescriptionTextWidget> {
  late String firstHalf = '';
  late String secondHalf = '';

  bool flag = true;

  @override
  void initState() {
    super.initState();

    // if (widget.text.length > 300) {
    //   translate(widget.text.substring(0, 300))
    //       .then((value) => firstHalf = value);
    //   translate(widget.text.substring(300, widget.text.length))
    //       .then((value) => secondHalf = value);
    // } else {
    //   firstHalf = widget.text;
    //   secondHalf = '';
    // }
    Functions.translate(widget.text).then((value) => firstHalf = value);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: firstHalf.isEmpty
          ? LoadingWidget(
              isImage: false,
            )
          : Text(
              '${firstHalf}'
                  .replaceAll(r'\n', '\n')
                  .replaceAll(r'\r', '')
                  .replaceAll(r"\'", "'"),
              style: TextStyle(
                fontSize: 16.0,
                color: Theme.of(context).textTheme.caption!.color,
              ),
            ),
    );
  }
}
