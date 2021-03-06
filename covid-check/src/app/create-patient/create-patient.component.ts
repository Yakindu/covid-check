import { Component, OnInit, Inject, Input, ViewChild, ElementRef } from '@angular/core';
import { MatDialogRef, MAT_DIALOG_DATA } from '@angular/material/dialog';
import { Location, Appearance } from '@angular-material-extensions/google-maps-autocomplete';
import { PatientService } from '../service/patient.service';
import { Patient, Gender } from '../model/model';
import { v4 as uuid } from 'uuid';
import PlaceResult = google.maps.places.PlaceResult;
import { MatDatepicker } from '@angular/material/datepicker';
import { concat } from 'rxjs';
import { concatAll } from 'rxjs/operators';
import { database } from 'firebase/app';

@Component({
  selector: 'app-create-patient',
  templateUrl: './create-patient.component.html',
  styleUrls: ['./create-patient.component.css']
})
export class CreatePatientComponent implements OnInit {

  @ViewChild('birthdatepicker')
  birthdatepicker: MatDatepicker<Date>;

  @ViewChild('firstname')
  firstname: ElementRef;

  @ViewChild('lastname')
  lastname: ElementRef;

  latitude = 52.520008;
  longitude = 13.404954;
  zoom = 5;
  placeResult: PlaceResult;


  constructor(
    private dialogRef: MatDialogRef<CreatePatientComponent>,
    @Inject(MAT_DIALOG_DATA) public message: string,
    private patientService: PatientService,
  ) { }

  ngOnInit(): void {
  }

  finish(event: any) {
    const patient: Patient = {
      firstname: this.firstname.nativeElement.value,
      lastname: this.lastname.nativeElement.value,
      city: this.placeResult.address_components[4].long_name,
      street: this.placeResult.address_components[1].long_name + ' ' + this.placeResult.address_components[0].long_name,
      zip: this.placeResult.address_components[this.placeResult.address_components.length - 1].long_name,
      filenumber: uuid(),
      dateofbirth: database.ServerValue.TIMESTAMP.constructor(this.birthdatepicker._datepickerInput.value),
      gender: Gender.d,
    };
    this.patientService.addItem(patient);
    this.dialogRef.close();
  }

  onAutocompleteSelected(result: PlaceResult) {
    this.placeResult = result;
  }
  onLocationSelected(location: Location) {
    this.latitude = location.latitude;
    this.longitude = location.longitude;
    this.zoom = 15;
  }



}
