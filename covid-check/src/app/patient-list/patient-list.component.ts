import { Component, OnInit, ViewChild } from '@angular/core';
import { Patient, Examination, ExaminationStatus } from '../model/model';
import { PatientService } from '../service/patient.service';
import { Observable } from 'rxjs';
import { MatSort } from '@angular/material/sort';
import { MatTableDataSource } from '@angular/material/table';
import { MatPaginator } from '@angular/material/paginator';
import { DatePipe } from '@angular/common';
import { MatDialog } from '@angular/material/dialog';
import { CreateTestComponent } from '../dialogs/create-test/create-test.component';
import { CreatePatientComponent } from '../create-patient/create-patient.component';
import { Router } from '@angular/router';
import { PatientStateService } from '../patient-state.service';

@Component({
  selector: 'app-patient-list',
  templateUrl: './patient-list.component.html',
  styleUrls: ['./patient-list.component.css']
})
export class PatientListComponent implements OnInit {
  dataSource = new MatTableDataSource();
  displayedColumns: string[] = ['filenumber', 'firstname', 'lastname', 'dateofbirth', 'street', 'zip', 'city'];
  @ViewChild(MatSort, { static: true }) sort: MatSort;
  @ViewChild(MatPaginator, { static: true }) paginator: MatPaginator;

  constructor(private patientService: PatientService, private dialog: MatDialog, private router: Router, private patientState: PatientStateService) {
  }

  ngOnInit(): void {
    this.patientService.patients.subscribe({
      next: (patientList) => this.dataSource.data = patientList,
      error: (error) => console.log(error)
    });
    this.dataSource.sort = this.sort;
    this.dataSource.paginator = this.paginator;
  }

  dateOfBirthNullSafe(p: Patient) {
    if (p.dateofbirth !== undefined) {
      return p.dateofbirth.toDate();
    } else {
      return null;
    }
  }

  linkToExamination(p: Patient) {
    var e: Examination;
    if (p.examinations != null && p.examinations.filter((e) => { return e.status == ExaminationStatus.probeOutstanding }).length > 0) {
      e = p.examinations.filter((e) => { return e.status == ExaminationStatus.probeOutstanding })[0];
    }

    if (e != null) {
      return 'Examination ' + e.id;
    } else {
      return 'Create New';
    }

  }

  applyFilter(event: Event) {
    const filterValue = (event.target as HTMLInputElement).value;
    this.dataSource.filter = filterValue.trim().toLowerCase();
  }

  createPatient() {
    const dialogRef = this.dialog.open(CreatePatientComponent, {
      data: 'data'
    });
    dialogRef.afterClosed().subscribe(result => {
      if (result) {
        //TODO:
        console.log('result');
      }
    });
  }

  select(patient: Patient) {
    this.patientState.patient = patient;
    this.router.navigate(['/patient-detail']);
  }
}
