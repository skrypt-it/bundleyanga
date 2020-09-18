import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:bundle_yanga/screens/home/widgets/fab.dart';
import 'package:bundle_yanga/screens/home/widgets/drawer.dart';
import 'package:bundle_yanga/screens/home/widgets/header.dart';
import 'package:bundle_yanga/screens/home/widgets/bundle_list.dart';
import 'package:bundle_yanga/screens/home/widgets/bundle_status.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _key = GlobalKey<ScaffoldState>();

  TabController _tabs;

  @override
  void initState() {
    super.initState();
    _tabs = TabController(vsync: this, length: 2);
    _tabs.addListener(_updateIndex);
  }

  _updateIndex() {
    setState(() {
      _tabs.index;
    });
  }

  @override
  void dispose() {
    _tabs.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: FAB(),
        key: _key,
        drawer: MyDrawer(),
        backgroundColor: Color(0xfff0f0f0),
        body: SingleChildScrollView(
            child: Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                child: Stack(children: <Widget>[
                  TabBarView(
                    controller: _tabs,
                    children: [
                      Container(
                          padding: EdgeInsets.only(top: 150),
                          height: MediaQuery.of(context).size.height,
                          width: double.infinity,
                          child: BundleList(type: BundleType.data)),
                      Container(
                          padding: EdgeInsets.only(top: 150),
                          height: MediaQuery.of(context).size.height,
                          width: double.infinity,
                          child: BundleList(type: BundleType.voice)),
                    ],
                  ),
                  Header(scaffoldKey: _key),
                  Positioned(
                    top: 95,
                    left: 0,
                    height: 55,
                    width: Get.width,
                    child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 18),
                        child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                          ),
                          color: Theme.of(context).accentColor.withAlpha(100),
                          child: TabBar(
                              controller: _tabs,
                              indicator: BoxDecoration(
                                boxShadow: [BoxShadow()],
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20)),
                                color: Theme.of(context).cardColor,
                              ),
                              labelColor: Theme.of(context).cardColor,
                              unselectedLabelColor:
                                  Theme.of(context).accentColor,
                              tabs: <Widget>[
                                BundleStatus(
                                    type: BundleType.data,
                                    active: _tabs.index == 0),
                                BundleStatus(
                                    type: BundleType.voice,
                                    active: _tabs.index == 1)
                              ]),
                        )),
                  )
                ]))));
  }
}
