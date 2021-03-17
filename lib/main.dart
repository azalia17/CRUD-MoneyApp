import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:async';
import './palette.dart';
import './adddatawidget.dart';
import './models/trans.dart';
import './database/dbconn.dart';
import './translist.dart';

final oCcy = new NumberFormat("#,##0.00", "en_US");

void main() async {
  await DbConn;
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.green,
        fontFamily: 'Poppins',
        canvasColor: Color(0xFFF0F2F5),
      ),
      home: MyHomePage(title: 'Transactions Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  DbConn dbconn = DbConn();
  List<Trans> transList;
  int totalCount = 0;
  int sumEarning = 0;
  int sumExpense = 0;

  @override
  Widget build(BuildContext context) {

    if(transList == null) {
      transList = List<Trans>();
    }
    return Scaffold(
      appBar: AppBar(
        title: Column(
          children: [
            new FutureBuilder(
              future: loadTotal(),
              builder: (context, snapshot)  {
                return Column(
                  children: [
                    Text(
                      'Balance',
                      style: const TextStyle(
                        color: Palette.abu,
                        fontSize: 16.0,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                    const SizedBox(height: 15.0,),
                    Text(
                      'Rp. ${oCcy.format(totalCount)}',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.right,
                    ),
                  ],
                );
              },
            ),
            const SizedBox(height: 15.0,),
            new FutureBuilder(
                future: inTotal(),
                builder: (context, snapshot){
                  return Row(
                    children: [
                      Expanded(
                          child: Container(
                            child: Text(
                              'Earning',
                              style: const TextStyle(
                                color: Palette.abu,
                                fontSize: 14.0,
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                          )
                      ),
                      //const SizedBox(width: 20.0,),
                      Expanded(
                          child: Container(
                            child: Text(
                              '${oCcy.format(sumEarning)}',
                              textAlign: TextAlign.right,
                              style: const TextStyle(
                                color: Palette.biru,
                                fontSize: 14.0,
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                          )
                      )
                    ],
                  );
                }
            ),
            new FutureBuilder(
                future: exTotal(),
                builder: (context, snapshot){
                  return Row(
                    children: [
                      Expanded(
                          child: Container(
                            child: Text(
                              'Expense',
                              style: const TextStyle(
                                color: Palette.abu,
                                fontSize: 14.0,
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                          )
                      ),
                      Expanded(
                          child: Container(
                            child: Text(
                              '- ${oCcy.format(sumExpense)}',
                              textAlign: TextAlign.right,
                              style: const TextStyle(
                                color: Palette.merah,
                                fontSize: 14.0,
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                          )
                      )
                    ],
                  );
                }
            ),
            Row(
              children: [
                Expanded(
                    child: Container(
                      child: Text(' '),
                    )
                ),
                Expanded(
                    child: Container(
                      child: Text(
                        '${oCcy.format(totalCount)}',
                        textAlign: TextAlign.right,
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 16.0,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    )
                )
              ],
            )
          ],
        ),
        toolbarHeight: 200.0,
        elevation: 0.0,
        centerTitle: true,
        backgroundColor: Colors.white,
      ),
      body: Padding(
        padding: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 0.0),
        child: new Center(
            child: new FutureBuilder(
              future: loadList(),
              builder: (context, snapshot) {
                return transList.length > 0? new TransList(trans: transList):
                new Center(
                    child: new Text('No transaction added yet',
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.grey,
                      ),
                    ));
                },
            )
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _navigateToAddScreen(context);
        },
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ),
    );
  }

  Future loadList() {
    final Future futureDB = dbconn.initDB();
    return futureDB.then((db) {
      Future<List<Trans>> futureTrans = dbconn.trans();
      futureTrans.then((transList) {
        setState(() {
          this.transList = transList;
        });
      });
    });
  }

  Future loadTotal() {
    final Future futureDB = dbconn.initDB();
    return futureDB.then((db) {
      Future<int> futureTotal = dbconn.countTotal();
      futureTotal.then((ft) {
        setState(() {
          this.totalCount = ft;
        });
      });
    });
  }

  Future inTotal() {
    final Future futureDB = dbconn.initDB();
    return futureDB.then((db) {
      Future<int> futureEarn = dbconn.earnTotal();
      futureEarn.then((ft) {
        setState(() {
          this.sumEarning = ft;
        });
      });
    });
  }

  Future exTotal() {
    final Future futureDB = dbconn.initDB();
    return futureDB.then((db) {
      Future<int> futureEx = dbconn.exTotal();
      futureEx.then((ft) {
        setState(() {
          this.sumExpense = ft;
        });
      });
    });
  }

  _navigateToAddScreen (BuildContext context) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AddDataWidget()),
    );
  }
}