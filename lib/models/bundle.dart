class Bundle {
  String bundleCacheId;
  int validity;
  int price;
  int size;
  String unit;
  int percent;
  bool preBuyable = false;
  bool data = false;

  Bundle(
      {this.validity,
      this.price,
      this.size,
      this.unit,
      this.percent,
      this.data,
      this.bundleCacheId});

  factory Bundle.fromMap(Map<String, dynamic> map) {
    return Bundle(
        validity: map["validity"],
        price: map["price"] ~/ 1,
        size: map["size"] ~/ 1,
        unit: map["unit"],
        data: map["services"][0] == "Data",
        percent: calculatePercent(map["size"] ~/ 1, map["price"] ~/ 1),
        bundleCacheId: map['bundleCacheId']);
  }
  @override
  String toString() {
    return "$size$unit @ K$price - %$percent";
  }

  String toBuyString(token) {
    return "{'bundleCacheId': '$bundleCacheId','preBuyable': false,'price': $price,'size': $size,'token': '$token'}";
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'bundleCacheId': bundleCacheId,
      'preBuyable': preBuyable,
      'price': price,
      'size': size
    };
  }
}

const List<Map> initPrices = [
  {'size': 1, 'price': 1200},
  {'size': 3, 'price': 1920},
  {'size': 4, 'price': 2400},
  {'size': 10, 'price': 60},
  {'size': 30, 'price': 100},
  {'size': 50, 'price': 140},
  {'size': 150, 'price': 340},
  {'size': 400, 'price': 750},
  {'size': 800, 'price': 950},
];
calculatePercent(size, price) {
  return (((price / initPrices.firstWhere((b) => b["size"] == size)["price"]) -
              (1)) *
          -1 *
          100)
      .toInt();
}

class ActiveBundle extends Bundle {
  final DateTime expiry;
  final int remaining;
  final int threshold;
  ActiveBundle(
      {String bundleCacheId,
      int validity,
      int price,
      int size,
      int percent,
      String unit,
      this.expiry,
      this.remaining,
      this.threshold})
      : super(
            bundleCacheId: bundleCacheId,
            validity: validity,
            price: price,
            size: size,
            percent: percent,
            unit: unit);
  factory ActiveBundle.fromMap(Map<String, dynamic> map) {
    return ActiveBundle(
        expiry: DateTime.parse(map['expiryDateTime']),
        remaining: map["remainingValue"],
        threshold: map["thresholdValue"],
        validity: map["validity"],
        price: map["price"] ~/ 1,
        size: map["size"] ~/ 1,
        percent: calculatePercent(map["size"], map["price"]),
        unit: map["unit"],
        bundleCacheId: map['bundleCacheId']);
  }
  String toString() {
    return "${(((remaining / 1024 / 10.24)).round()) / 100}MB | ${expiry.difference(DateTime.now()).inMinutes} minutes left";
  }

  String toShortString() {
    return expiry.difference(DateTime.now()).inMinutes >= 1
        ? "${(((remaining / 1024 / 10.24)).round()) / 100}MB | ${expiry.difference(DateTime.now()).inMinutes}min"
        : "${(((remaining / 1024 / 10.24)).round()) / 100}MB | ${expiry.difference(DateTime.now()).inSeconds}s";
  }
}
