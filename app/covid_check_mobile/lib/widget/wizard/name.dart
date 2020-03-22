import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';

import '../../screens/wizard/wizard.dart';
import '../../model/patient.dart';

import 'title.dart';

class NameForm extends StatefulWidget {

  final PageController controller;
  final int index;

  NameForm(this.index, this.controller);

  @override
  State<StatefulWidget> createState() {
    return NameFormState(this.index, this.controller);
  }
}

class NameFormState extends State<NameForm>{
  PageController controller;
  final int index;
  
  String title;

  DateTime _selectedDate = DateTime.now();
  Gender _selectedGender = Gender.d;

  NameFormState(this.index, this.controller);

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    Patient patient = Wizard.of(context).patient;

    return Scaffold(
      body: ListView(
        shrinkWrap: true,
        children: <Widget>[
          Container(
              padding: EdgeInsets.all(30),
              child: Form(
                  key: _formKey,
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        FormTitle("Bitte geben Sie Ihre Daten ein", index),
                        SizedBox(height: 20.0),
                        TextFormField(
                            onChanged: (value) => patient.firstname = value,
                            decoration:
                            InputDecoration(labelText: "Vorname")),
                        SizedBox(height: 20.0),
                        TextFormField(
                            onChanged: (value) => patient.lastname = value,
                            decoration:
                            InputDecoration(labelText: "Nachname")),
                        SizedBox(height: 30.0),
                        GestureDetector(
                          onTap: () => _selectDate(context),
                          child: Row(children: <Widget>[
                            Icon(FontAwesomeIcons.birthdayCake, color: Colors.grey[600],),
                            SizedBox(width: 20.0),
                            Text(DateFormat.yMMMEd().format(_selectedDate)),
                          ]),
                        ),
                        SizedBox(height: 30.0),
                        Row(
                          children: <Widget>[
                            DropdownButton(
                              icon: _genderIcon(), 
                              value: _selectedGender,
                              onChanged: (value) => setState(() {
                                _selectedGender = value;
                                patient.gender = value;
                              }),
                              items: [
                                DropdownMenuItem(
                                  value: Gender.m,
                                  child: new Text("männlich"),
                                ),
                                DropdownMenuItem(
                                  value: Gender.f,
                                  child: new Text("weiblich"),
                                ),
                                DropdownMenuItem(
                                  value: Gender.d,
                                  child: new Text("divers"),
                                )
                              ]
                            ),
                          ],
                        )
                      ]
                  )
              )
          )
        ],
      ),
    );
  }

  Icon _genderIcon() {
    switch (_selectedGender) {
      case Gender.m:
        return Icon(FontAwesomeIcons.male);
      case Gender.f:
        return Icon(FontAwesomeIcons.female);
      case Gender.d:  
        return Icon(FontAwesomeIcons.genderless);
      default:
        return Icon(FontAwesomeIcons.genderless);
    }
  } 

  Future<Null> _selectDate(BuildContext context) async {
    Patient patient = Wizard.of(context).patient;

    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: _selectedDate,
        firstDate: DateTime(1900),
        lastDate: DateTime.now());
    if (picked != null && picked != _selectedDate)
      setState(() {
        _selectedDate = picked;
        patient.dateofbirth = Timestamp.fromMicrosecondsSinceEpoch(_selectedDate.millisecondsSinceEpoch);
      });
  }
}