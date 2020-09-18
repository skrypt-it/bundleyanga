import 'package:bundle_yanga/controllers/bundles.dart';
import 'package:bundle_yanga/models/bundle.dart';
import 'package:bundle_yanga/models/bundles.dart';
import 'package:bundle_yanga/widgets/fcb.dart';
import 'package:bundle_yanga/widgets/loader.dart';
import 'package:flutter/material.dart';
import 'package:flutter_emoji/flutter_emoji.dart';
import 'package:get/get.dart';

enum BundleType { voice, data }

class BundleStatus extends StatelessWidget {
  final parser = EmojiParser();
  final BundleType type;
  final bool active;

  BundleStatus({Key key, this.type, this.active}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final BundlesController state = Get.find();
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Container(
            padding: EdgeInsets.symmetric(vertical: 7),
            child: active
                ? Obx(
                    () => FutureContent<Bundles>(
                        future: state.bundles.value,
                        builder: (context, value) {
                          int perc = type == BundleType.data
                              ? value.percent
                              : value.voicePercent;
                          final emo = perc == 0
                              ? 'sob'
                              : perc <= 25
                                  ? 'cry'
                                  : perc <= 49
                                      ? 'thinking_face'
                                      : perc <= 64 ? 'yum' : 'heart';
                          final String emoji = parser.emojify(':$emo:');
                          return Row(mainAxisSize: MainAxisSize.min, children: [
                            Text("$perc% Discount ",
                                style: TextStyle(color: Colors.black)),
                            Obx(() => FutureBuilder(
                                  future: state.bundles.value,
                                  builder: (context, _) => _.connectionState ==
                                          ConnectionState.waiting
                                      ? Padding(
                                          padding:
                                              const EdgeInsets.only(left: 5.0),
                                          child: Container(
                                            height: 33,
                                            width: 20,
                                            child:
                                                Loader(centralDotRadius: 12.0),
                                          ),
                                        )
                                      : Text(
                                          emoji,
                                          style: TextStyle(fontSize: 25.0),
                                        ),
                                ))
                          ]);
                        }),
                  )
                : type == BundleType.voice ? Text('Voice') : Text('Data')),
      ],
    );
  }
}
