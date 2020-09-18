import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class BundleError extends StatelessWidget {
  const BundleError({
    Key key,
    @required RefreshController refreshController,
    this.refresh,
  })  : _refreshController = refreshController,
        super(key: key);

  final RefreshController _refreshController;
  final Function refresh;

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text("Something went wrong..."),
        SizedBox(
          height: 25,
        ),
        Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(70)),
                color: Theme.of(context).primaryColor),
            child: FlatButton(
              child: Text('Try Again?',
                  style: TextStyle(
                      color: Theme.of(context).accentColor,
                      fontWeight: FontWeight.w700,
                      fontSize: 14)),
              onPressed: () => refresh(_refreshController),
            ))
      ],
    ));
  }
}
