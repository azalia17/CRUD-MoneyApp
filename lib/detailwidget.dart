import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import './palette.dart';
import './database/dbconn.dart';
import './editdatawidget.dart';
import './models/trans.dart';

final oCcy = new NumberFormat("#,##0.00", "en_US");

class DetailWidget extends StatefulWidget {
  DetailWidget(this.trans);

  final Trans trans;

  @override
  _DetailWidgetState createState() => _DetailWidgetState();
}

class _DetailWidgetState extends State<DetailWidget> {
  _DetailWidgetState();

  DbConn dbconn = DbConn();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Details Transaction',
          style: TextStyle(color: Colors.black,
              fontSize: 18.0
          ),
        ),
        backgroundColor: Colors.white,
        leading: IconButton(
          color: Colors.black,
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        centerTitle: true,
        elevation: 0.0,
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(20.0),
          child: Card(
              child: Container(
                  padding: EdgeInsets.all(10.0),
                  width: 440,
                  child: Column(
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.fromLTRB(0, 0, 0, 10),
                        child: Column(
                          children: <Widget>[
                            Text('Transaction Name:', style: TextStyle(color: Palette.abu, fontSize: 15.0)),
                            Text(widget.trans.transName, style: Theme.of(context).textTheme.title)
                          ],
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.fromLTRB(0, 0, 0, 10),
                        child: Column(
                          children: <Widget>[
                            Text('Transaction Type:', style: TextStyle(color: Palette.abu, fontSize: 15.0)),
                            Text(widget.trans.transType, style: Theme.of(context).textTheme.title)
                          ],
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.fromLTRB(0, 0, 0, 10),
                        child: Column(
                          children: <Widget>[
                            Text('Amount:', style: TextStyle(color: Palette.abu, fontSize: 15.0)),
                            Text('Rp. ${oCcy.format(widget.trans.amount)}'.toString(), style: Theme.of(context).textTheme.title)
                          ],
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.fromLTRB(0, 0, 0, 10),
                        child: Column(
                          children: <Widget>[
                            Text('Transaction Date:', style: TextStyle(color: Palette.abu, fontSize: 15.0)),
                            Text(widget.trans.transDate, style: Theme.of(context).textTheme.title)
                          ],
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.fromLTRB(0, 0, 0, 10),
                        child: Row(
                          children: <Widget>[
                            Expanded(
                              child: Container(
                                child: FlatButton(
                                  onPressed: () {
                                    _navigateToEditScreen(context, widget.trans);
                                  },
                                  child: Text('Edit', style: TextStyle(color: Colors.white)),
                                  color: Palette.ijo,
                                ),
                              ),
                            ),
                            const SizedBox(width: 10.0,),
                            Expanded(
                              child: Container(
                                child: FlatButton(
                                  onPressed: () {
                                    _confirmDialog();
                                  },
                                  child: Text('Delete', style: TextStyle(color: Colors.white)),
                                  color: Palette.merah,
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  )
              )
          ),
        ),
      ),
    );
  }

  _navigateToEditScreen (BuildContext context, Trans trans) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => EditDataWidget(trans)),
    );
  }

  Future<void> _confirmDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Warning!', style: TextStyle(color: Palette.merah, fontWeight: FontWeight.bold)),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Are you sure want delete this item?'),
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('Yes', style: TextStyle(color: Palette.merah),),
              onPressed: () {
                final initDB = dbconn.initDB();
                initDB.then((db) async {
                  await dbconn.deleteTrans(widget.trans.id);
                });

                Navigator.popUntil(context, ModalRoute.withName(Navigator.defaultRouteName));
              },
            ),
            FlatButton(
              child: const Text('No'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

}