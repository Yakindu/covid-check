import 'package:covidcheckmobile/service/patient_service.dart';
import 'package:flutter/material.dart';

import 'package:covidcheckmobile/screens/wizard/wizard.dart';
import 'package:covidcheckmobile/model/patient.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

import 'title.dart';

class SubmitForm extends StatefulWidget {

  final PageController controller;
  final int index;

  SubmitForm(this.index, this.controller);

  @override
  State<StatefulWidget> createState() {
    return SubmitFormState(this.index, this.controller);
  }
}

class SubmitFormState extends State<SubmitForm>{
  final PatientService service =PatientService();
  PageController controller;
  final int index;

  String email;
  String phone;

  SubmitFormState(this.index, this.controller);

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
                        FormTitle("Übermitteln Sie Ihre Daten um Terminvorschläge zu erhalten", index),
                        SizedBox(height: 20.0),
                        Container(
                          padding: const EdgeInsets.all(10.0),
                          child: Column(
                            children: <Widget>[
                              Container(
                                margin: EdgeInsets.all(6.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                  Text("Name: "),
                                  Text("${patient.firstname} ${patient.lastname}")
                                ],),
                              ),
                              Container(
                                margin: EdgeInsets.all(6.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                  Text("Adresse: "),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: <Widget>[
                                      Text("${patient.street}"),
                                      Text("${patient.zip} ${patient.city}")
                                    ],
                                  )
                                ],),
                              ),
                              Container(
                                margin: EdgeInsets.all(6.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Text("Geburtstag: "),
                                    Text(patient.dateofbirth != null ? 
                                      DateFormat.yMMMd("de_DE").format(DateTime.fromMillisecondsSinceEpoch(patient.dateofbirth.millisecondsSinceEpoch)) : 
                                      "-")
                                  ]
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.all(6.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Text("Geschlecht: "),
                                    Text(patient.gender != null ? 
                                      _genderToText(patient.gender) : 
                                      "-")
                                  ]
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.all(6.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                  Text("Email: "),
                                  Text("abc@de.com")
                                ],),
                              ),
                              Container(
                                margin: EdgeInsets.all(6.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                  Text("Telefon: "),
                                  Text("123 456 789")
                                ],),
                              ),
                              Container(
                                margin: EdgeInsets.all(6.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                  Text("Spezifische Beschwerden: "),
                                  Text("Ja")
                                ],),
                              ),
                              Container(
                                margin: EdgeInsets.all(6.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                  Text("Kontakt mit pot. infizierten Personen: "),
                                  Text("Nein")
                                ],),
                              ),
                              Container(
                                margin: EdgeInsets.all(6.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                  Text("Aus Risikogebiet kommend: "),
                                  Text("Ja")
                                ],),
                              )
                            ],
                          ),
                        ),
                        SizedBox(height: 20.0),
                        RaisedButton.icon(
                          color: Theme.of(context).accentColor,
                          onPressed: submitData,
                          icon: Icon(Icons.send),
                          label: Text("Daten übermitteln"),
                        )
                      ]
                  )
              )
          )
        ],
      ),
    );
  }

  String _genderToText(Gender gender) {
    switch (gender) {
      case Gender.m:
        return "männlich";
      case Gender.f:
        return "weiblich";
      case Gender.d:
        return "divers";
      default:
        return "divers";
    }
  }

  void submitData() {
    Patient currentPatient = Wizard.of(context).patient;
    currentPatient.filenumber = Uuid().v4();
    service.submitPatient(currentPatient, Wizard.of(context).user);
    Navigator.of(context).pop();
  }
}