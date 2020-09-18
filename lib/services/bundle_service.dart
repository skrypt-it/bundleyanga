import 'dart:async';
import 'package:bundle_yanga/logger.dart';
import 'package:bundle_yanga/models/balance.dart';
import 'package:bundle_yanga/models/bundle.dart';
import 'package:bundle_yanga/models/bundles.dart';
import 'package:bundle_yanga/services/handler.dart';
import 'package:http/http.dart' as Http;

class BundleService with Handler {
  final String phone;
  final String token;
  final Logger logger;

  BundleService(this.phone, this.token, this.logger);

  Future<Bundles> checkYanga({bool active = true}) async {
    var url =
        "https://yangabundles.tnm.co.mw/ccc-p/dt/bundles/categorised?msisdn=$phone&token=$token";
    return handle(Http.get(url).timeout(const Duration(seconds: 10)),
            type: 'yanga')
        .then((bundleInfo) {
      List<dynamic> bundleList = bundleInfo['data'][0]['bundleList'];
      List<Bundle> bundles = bundleList.map((b) => Bundle.fromMap(b)).toList();
      bundles.sort((a, b) => b.percent.compareTo(a.percent));
      int percent = bundles.firstWhere((element) => element.data).percent;
      int voice = bundles.firstWhere((element) => !element.data).percent;
      bundles.sort((a, b) => a.size.compareTo(b.size));
      return Bundles(list: bundles, percent: percent, voicePercent: voice);
    });
  }

  Future<Balance> checkBalance({bool active = true}) {
    var url =
        "https://yangabundles.tnm.co.mw/ccc-p/dt/subscriber/balancesandusage?msisdn=$phone&token=$token";
    return handle(Http.get(url).timeout(const Duration(seconds: 10)),
            type: 'balance')
        .then((balanceInfo) {
      List<dynamic> bundleList = balanceInfo['data']['bundleUsage'];
      String balance = balanceInfo['data']['accountBalances']
          ['accountBalanceList'][0]['displayBalance'];
      if (balance == 'K .00') balance = 'K 0.00';
      List<ActiveBundle> activeBundles =
          bundleList.map((b) => ActiveBundle.fromMap(b)).toList();
      return Balance(bundles: activeBundles, amount: balance);
    });
  }

  Future<Balance> buyBundle(Bundle bundle) async {
    var url = "https://yangabundles.tnm.co.mw/ccc-p/dt/bundles?token=$token";
    return handle(
            Http.post(url, body: bundle.toBuyString(token))
                .timeout(const Duration(seconds: 10)),
            type: 'bundle')
        .then((res) {
      if (res['status'] == 0) {
        logger.event(
            'Bundle purchase failed', {"response": res['error_message']});
        return Future.error(res['error_message']);
      } else {
        List<dynamic> bundleList =
            res['data']['balanceAndUsage']['bundleUsage'];
        String balance = res['data']['balanceAndUsage']['accountBalances']
            ['accountBalanceList'][0]['displayBalance'];
        List<ActiveBundle> activeBundles =
            bundleList.map((b) => ActiveBundle.fromMap(b)).toList();
        logger.event('Bundle purchase successful', {
          "percent": bundle.percent.toString(),
          "bundle": bundle.size.toString()
        });
        return Balance(amount: balance, bundles: activeBundles);
      }
    });
  }
}
