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
      itemBuilder: (ctx, index) {
        return Card(
        margin: EdgeInsets.symmetric(vertical: 3, horizontal: 0),
          elevation: 0.5,
          child: InkWell(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => DetailWidget(trans[index])),);
              },
            child: ListTile(
              leading: trans[index].transType == 'earning'? Icon(Icons.attach_money, color: Palette.biru, size: 40.0,)
                  : Icon(Icons.money_off, color: Palette.merah, size: 40.0,),
              title: Text(
                trans[index].transName,
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 15.0,
                  fontWeight: FontWeight.normal,
                ),
                textAlign: TextAlign.left,
              ),
            subtitle: Text(
              trans[index].transDate,
              style: const TextStyle(
                color: Palette.abu,
                fontSize: 12.0,
                fontWeight: FontWeight.normal,
              ),
            ),
              trailing: trans[index].transType == 'earning'?
              Text(
                '${oCcy.format(trans[index].amount)}'.toString(),
                style: const TextStyle(
                  color: Palette.biru,
                  fontSize: 15.0,
                  fontWeight: FontWeight.normal,
                ),
              ) :
            Text(
              '${oCcy.format(trans[index].amount)}'.toString(),
              style: const TextStyle(
                color: Palette.merah,
                fontSize: 15.0,
                fontWeight: FontWeight.normal,
              ),
            ),
          ),
          )
        );
      },
      itemCount: trans.length,
    );

    // return ListView.builder(
    //     itemCount: trans == null ? 0 : trans.length,
    //     itemBuilder: (BuildContext context, int index) {
    //       return Card(
    //           child: InkWell(
    //             onTap: () {
    //               Navigator.push(context, MaterialPageRoute(builder: (context) => DetailWidget(trans[index])),);
    //               },
    //             child: Container(
    //               height: MediaQuery.of(context).size.height * 0.08,
    //               padding: EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
    //               child:Row(
    //                     crossAxisAlignment: CrossAxisAlignment.center,
    //                     children: [
    //                       trans[index].transType == 'earning'? Icon(Icons.attach_money, color: Palette.biru, size: 40.0,)
    //                           : Icon(Icons.money_off, color: Palette.merah, size: 40.0,),
    //                       const SizedBox(width: 8.0),
    //                       Expanded(
    //                         child: Column(
    //                           mainAxisAlignment: MainAxisAlignment.center,
    //                           crossAxisAlignment: CrossAxisAlignment.start,
    //                           children: [
    //                             Text(
    //                                 trans[index].transName,
    //                                 style: const TextStyle(
    //                                   color: Colors.black,
    //                                   fontSize: 15.0,
    //                                   fontWeight: FontWeight.normal,
    //                                 ),
    //                                 textAlign: TextAlign.left,
    //                               ),
    //                             Text(
    //                               trans[index].transDate,
    //                               style: const TextStyle(
    //                                 color: Palette.abu,
    //                                 fontSize: 12.0,
    //                                 fontWeight: FontWeight.normal,
    //                               ),
    //                             ),
    //                           ],
    //                         ),
    //                       ),
    //                       trans[index].transType == 'earning'? Text(
    //                         '${oCcy.format(trans[index].amount)}'.toString(),
    //                         style: const TextStyle(
    //                           color: Palette.biru,
    //                           fontSize: 15.0,
    //                           fontWeight: FontWeight.normal,
    //                         ),) :
    //                       Text(
    //                         '${oCcy.format(trans[index].amount)}'.toString(),
    //                         style: const TextStyle(
    //                           color: Palette.merah,
    //                           fontSize: 15.0,
    //                           fontWeight: FontWeight.normal,
    //                         ),
    //                       )
    //                     ],
    //                   ),
    //               ),
    //           )
    //       );
    //     },
    // );
  }
}
