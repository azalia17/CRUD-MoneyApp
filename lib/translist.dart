import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import './models/trans.dart';
import './detailwidget.dart';
import './palette.dart';

final oCcy = new NumberFormat("#,##0.00", "en_US");

class TransList extends StatelessWidget {
  final List<Trans> trans;
  TransList({Key key, this.trans}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: trans == null ? 0 : trans.length,
        itemBuilder: (BuildContext context, int index) {
          return Card(
              child: InkWell(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => DetailWidget(trans[index])),);
                  },
                child: Container(
                  height: 60.0,
                  padding: EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
                  child: Column(
                    children: [
                      Container(height: 10.0,),
                      Row(
                        children: [
                          trans[index].transType == 'earning'? Icon(Icons.attach_money, color: Palette.biru, size: 40.0,)
                              : Icon(Icons.money_off, color: Palette.merah, size: 40.0,),
                          const SizedBox(width: 8.0),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  trans[index].transName,
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 15.0,
                                    fontWeight: FontWeight.normal,
                                  ),
                                ),
                                Text(
                                  trans[index].transDate,
                                  style: const TextStyle(
                                    color: Palette.abu,
                                    fontSize: 12.0,
                                    fontWeight: FontWeight.normal,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          trans[index].transType == 'earning'? Text(
                            '${oCcy.format(trans[index].amount)}'.toString(),
                            style: const TextStyle(
                              color: Palette.biru,
                              fontSize: 15.0,
                              fontWeight: FontWeight.normal,
                            ),) :
                          Text(
                            '${oCcy.format(trans[index].amount)}'.toString(),
                            style: const TextStyle(
                              color: Palette.merah,
                              fontSize: 15.0,
                              fontWeight: FontWeight.normal,
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              )
          );
        },
    );
  }
}
