import 'package:flutter/material.dart';
import 'package:bundle_yanga/models/bundle.dart';
import 'package:bundle_yanga/screens/home/widgets/bundle_emoji.dart';

class BundleTile extends StatelessWidget {
  final Bundle bundle;
  final VoidCallback onPressed;
  BundleTile({this.bundle, this.onPressed});
  @override
  Widget build(BuildContext context) {
    return Container(
        width: double.infinity,
        height: 70,
        margin: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(100)),
            color: Theme.of(context).accentColor),
        child: FlatButton(
          onPressed: onPressed,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                  width: 50,
                  height: 50,
                  margin: EdgeInsets.only(right: 15),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      border: Border.all(
                          width: 3, color: Theme.of(context).primaryColor)),
                  child:
                      Center(child: BundleEmoji(bundle.size, bundle.percent))),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      "${bundle.size}${bundle.unit}",
                      style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 18),
                    ),
                    SizedBox(
                      height: 6,
                    ),
                    Row(
                      children: <Widget>[
                        Icon(
                          Icons.label,
                          color: Theme.of(context).primaryColor,
                          size: 20,
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Text("K${bundle.price}.00 - ",
                            style: TextStyle(
                                color: Theme.of(context).primaryColor,
                                fontSize: 14,
                                letterSpacing: .3)),
                        Text("${bundle.percent}%",
                            style: TextStyle(
                                color: Theme.of(context).primaryColor,
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                letterSpacing: .3)),
                      ],
                    ),
                  ],
                ),
              )
            ],
          ),
        ));
  }
}
