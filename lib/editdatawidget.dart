import 'package:intl/intl.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/material.dart';
import './palette.dart';
import './database/dbconn.dart';
import './models/trans.dart';

enum TransType { earning, expense }

class EditDataWidget extends StatefulWidget {
  EditDataWidget(this.trans);

  final Trans trans;

  @override
  _EditDataWidgetState createState() => _EditDataWidgetState();
}

class _EditDataWidgetState extends State<EditDataWidget> {
  _EditDataWidgetState();

  DbConn dbconn = DbConn();
  final _addFormKey = GlobalKey<FormState>();
  int _id = null;
  final format = DateFormat("dd MMMM yyyy");
  final _transDateController = TextEditingController();
  final _transNameController = TextEditingController();
  String transType = '';
  final _amountController = TextEditingController();
  TransType _transType = TransType.earning;

  @override
  void initState() {
    _id = widget.trans.id;
    _transDateController.text = widget.trans.transDate;
    _transNameController.text = widget.trans.transName;
    _amountController.text = widget.trans.amount.toString();
    transType = widget.trans.transType;
    if(widget.trans.transType == 'earning') {
      _transType = TransType.earning;
    } else {
      _transType = TransType.expense;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Edit Transaction',
          style: TextStyle(
              color: Colors.black,
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
      body: Form(
        key: _addFormKey,
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(28.0, 40.0, 28.0, 0.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 3.0, bottom: 3.0),
                        child: Text(
                          'Amount',
                          style: const TextStyle(
                              fontSize: 15.0,
                              fontWeight: FontWeight.normal,
                              color: Palette.ijo
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 20.0),
                      child: TextFormField(
                        controller: _amountController,
                        onEditingComplete: (){},
                        keyboardType: TextInputType.number,
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.black,
                          fontWeight: FontWeight.normal,
                        ),
                        decoration: InputDecoration(
                          hintText: 'Add Amount',
                          hintStyle: const TextStyle(
                            fontSize: 16,
                            color: Palette.abu,
                            fontWeight: FontWeight.normal,
                          ),
                          contentPadding: EdgeInsets.symmetric(
                              vertical: 10,
                              horizontal: 5
                          ),
                          focusColor: Palette.ijo,
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide(
                                color: Palette.ijo,
                              )
                          ),
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide(
                                color: Palette.abu,
                              )
                          ),
                        ),
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Please enter amount';
                          }
                          return null;
                        },
                        onChanged: (value) {},
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 3.0, bottom: 3.0),
                        child: Text(
                            'Transaction Name',
                            style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.normal,
                                color: Palette.ijo
                            )
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 20.0),
                      child: TextFormField(
                        controller: _transNameController,
                        onEditingComplete: (){},
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.black,
                          fontWeight: FontWeight.normal,
                        ),
                        decoration: InputDecoration(
                          hintText: 'Add Name',
                          hintStyle: const TextStyle(
                            fontSize: 16,
                            color: Palette.abu,
                            fontWeight: FontWeight.normal,
                          ),
                          contentPadding: EdgeInsets.symmetric(
                              vertical: 10,
                              horizontal: 5
                          ),
                          focusColor: Palette.ijo,
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide(
                                color: Palette.ijo,
                              )
                          ),
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide(
                                color: Palette.abu,
                              )
                          ),
                        ),
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Please enter transaction name';
                          }
                          return null;
                        },
                        onChanged: (value) {},
                      ),
                    ),
                    Column(
                      children: [
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 3.0,bottom: 3.0),
                            child: Text(
                                'Transaction Date',
                                style: const TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.normal,
                                    color: Palette.ijo
                                )
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 20.0),
                          child: DateTimeField(
                            format: format,
                            controller: _transDateController,
                            onShowPicker: (context, currentValue) {
                              return showDatePicker(
                                  context: context,
                                  firstDate: DateTime(1900),
                                  initialDate: currentValue ?? DateTime.now(),
                                  lastDate: DateTime.now());
                            },
                            onChanged: (value) {},
                          ),
                        ),
                      ],
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 3.0,bottom: 3.0),
                        child: Text(
                            'Transaction Type',
                            style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.normal,
                                color: Palette.ijo
                            )
                        ),
                      ),
                    ),
                    ListTile(
                      title: const Text('Earning', style: const TextStyle(fontSize: 16.0,)),
                      leading: Radio(
                        value: TransType.earning,
                        groupValue: _transType,
                        onChanged: (TransType value) {
                          setState(() {
                            _transType = value;
                            transType = 'earning';
                          });
                        },
                      ),
                    ),
                    ListTile(
                      title: const Text('Expense', style: const TextStyle(fontSize: 16.0,)),
                      leading: Radio(
                        value: TransType.expense,
                        groupValue: _transType,
                        onChanged: (TransType value) {
                          setState(() {
                            _transType = value;
                            transType = 'expense';
                          });
                        },
                      ),
                    ),
                    Container(
                        margin: EdgeInsets.fromLTRB(0, 25.0, 0, 25.0),
                        width: MediaQuery.of(context).size.height * 1,
                        height: 50,
                        child: FlatButton(
                          onPressed: () {
                            if (_addFormKey.currentState.validate()) {
                              _addFormKey.currentState.save();
                              final initDB = dbconn.initDB();
                              initDB.then((db) async {
                                await dbconn.updateTrans(Trans(id: _id, transDate: _transDateController.text, transName: _transNameController.text, transType: transType, amount: int.parse(_amountController.text)));
                              });

                              Navigator.popUntil(context, ModalRoute.withName(Navigator.defaultRouteName));
                            }
                          },
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text('Update', style: TextStyle(color: Colors.white, fontSize: 16)),
                          color: Palette.ijo,
                        )
                    ),
                  ],
                ),
              ),
            ],
          ),
        )
      ),
    );
  }
}