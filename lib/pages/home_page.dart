import 'package:carros/utils/network.dart';
import 'package:carros/utils/prefs.dart';
import 'package:carros/widgets/carro_listview.dart';
import 'package:carros/widgets/drawer_list.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin<HomePage> {
  TabController _tabController;

  @override
  void initState() {
    super.initState();

    _initTabs();
  }

  _initTabs() async {
    int tabIdx = await Prefs.getInt("tabIdx");

    _tabController = TabController(length: 3, vsync: this);


    setState(() {
      _tabController.index = tabIdx;
    });

    _tabController.addListener(() {
      print(">> ${_tabController.index}");
      Prefs.setInt("tabIdx", _tabController.index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Home"),
        bottom: _tabController == null
            ? null
            : TabBar(
                controller: _tabController,
                tabs: <Widget>[
                  Tab(
                    text: "Clássicos",
                  ),
                  Tab(
                    text: "Esportivos",
                  ),
                  Tab(
                    text: "Luxo",
                  )
                ],
              ),
      ),
      body: _tabController == null
          ? Center(
              child: CircularProgressIndicator(),
            )
          : TabBarView(
              controller: _tabController,
              children: <Widget>[
                CarroListView(TipoCarro.classicos),
                CarroListView(TipoCarro.esportivos),
                CarroListView(TipoCarro.luxo),
              ],
            ),
      drawer: DrawerList(),
    );
  }

}
