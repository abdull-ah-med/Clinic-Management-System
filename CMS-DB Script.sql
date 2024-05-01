--CREATE DATABASE [CMS_DB];
USE [CMS_DB];


CREATE TABLE Users (
	UserID NVARCHAR(10) PRIMARY KEY,
	UserName NVARCHAR(60),
	UserContact NVARCHAR(60),
	UserPass NVARCHAR(30),
	UserDOB DATE,
	UserRole CHAR(1),
	UserAddress NVARCHAR(100)
);

CREATE TABLE Doctors (
	DoctorID NVARCHAR(10) PRIMARY KEY REFERENCES Users(UserID),
	PMDC NVARCHAR(10),
	DoctorName NVARCHAR(60),
	ConsultationFee DECIMAL(10, 2),
	Department NVARCHAR(60),
	AssignedPatients NVARCHAR(MAX),
	UnderSupervisionOf NVARCHAR(10),
	CONSTRAINT FK_UnderSupervisionOf FOREIGN KEY (UnderSupervisionOf) REFERENCES Doctors(DoctorID)
);

Use [CMS_DB];

Create Table Patients (
	PatientID nvarchar(10) primary key references Users(UserID),
	DesignatedDoctor nvarchar(max),
	PatientAttendants nvarchar(max),
	Medicine nvarchar(max),
	LaboratoryTests nvarchar(max)
);

Use [CMS_DB]
Alter table
	Patients
add
	constraint FK_Patients_PatientID foreign key (PatientID) references Users(UserID) Use [CMS_DB];

CREATE TABLE DoctorPatientMapping (
	DoctorID NVARCHAR(10),
	PatientID NVARCHAR(10),
	CONSTRAINT FK_DoctorID FOREIGN KEY (DoctorID) REFERENCES Doctors(DoctorID),
	CONSTRAINT FK_PatientID FOREIGN KEY (PatientID) REFERENCES Patients(PatientID)
);

USE [CMS_DB];

CREATE TABLE PatientAttendants (
	AttendantID NVARCHAR(10) PRIMARY KEY REFERENCES Users(UserID),
	PatientID NVARCHAR(10),
	AttendantName NVARCHAR(60),
	LaboratoryTests NVARCHAR(100),
	Medicines NVARCHAR(100),
	Prescriptions NVARCHAR(100),
	CONSTRAINT FK_PatientID_Attendants FOREIGN KEY (PatientID) REFERENCES Patients(PatientID)
);

Use [CMS_DB];

Create Table Appointments(
	AppointmentID nvarchar(20) primary key,
	DoctorID nvarchar(10),
	PatientID nvarchar(10),
	DepartmentID nvarchar(10),
	AppointmentDate date constraint FK_DoctorID_Appointments foreign key (DoctorID) references Doctors(DoctorID),
	constraint FK_PatientID_Appointments foreign key (PatientID) references Patients(PatientID)
);

Use [CMS_DB];

Create table Visits(
	VisitID nvarchar(20) primary key,
	AppointmentID nvarchar(20),
	PatientID nvarchar(10),
	DoctorID nvarchar(10),
	DepartmentID nvarchar(10),
	VisitDate date,
	Referral nvarchar(20),
	constraint FK_AppointmentID_visits foreign key (AppointmentID) references Appointments(AppointmentID) ON DELETE
	SET
		NULL,
		constraint FK_PatientID_Visits foreign key (PatientID) references Patients(PatientID),
		constraint FK_DoctorID_Visits foreign key (DoctorID) references Doctors(DoctorID),
		constraint FK_Referral_Visits foreign key (VisitID) references Visits(VisitID)
);

Use [CMS_DB] Create table VisitPrescriptions(
	VisitPrescriptionID nvarchar (20) primary key,
	VisitID nvarchar(20),
	Prescription nvarchar(MAX),
	MedicineID nvarchar(20),
	LaboratoryTestID nvarchar(40),
	constraint FK_Prescription_VisitID foreign key (VisitID) references Visits(VisitID)
);

Use [CMS_DB] Create table Medicines(
	MedicineID nvarchar(20) primary key,
	VisitPrescriptionID nvarchar(20),
	VisitID nvarchar(20),
	Medicine nvarchar(max),
	MedicineSchedule nvarchar(max),
	MedicineAmount int,
	PatientID nvarchar(10),
	constraint FK_Medicine_VisitPrescriptionID foreign key (VisitPrescriptionID) references VisitPrescriptions(VisitPrescriptionID),
	constraint FK_Medicine_VisitID foreign key (VisitID) references Visits(VisitID),
	constraint FK_Medicine_PatientID foreign key (PatientID) references Patients(PatientID)
);

Use [CMS_DB] Create table LaboratoryTests(
	LaboratoryTestID nvarchar(20) primary key,
	VisitPrescriptionID nvarchar(20),
	VisitID nvarchar(20),
	LabTest nvarchar(max),
	LabTestAmount int,
	PatientID nvarchar(10),
	constraint FK_LabTest_VisitPrescriptionID foreign key (VisitPrescriptionID) references VisitPrescriptions(VisitPrescriptionID),
	constraint FK_LabTest_VisitID foreign key (VisitID) references Visits(VisitID),
	constraint FK_LabTest_PatientID foreign key (PatientID) references Patients(PatientID)
);

USe [CMS_DB] Create Table Departments(
	DepartmentID nvarchar(20) primary key,
	DepartmentName nvarchar(100),
	HOD nvarchar(10),
	constraint FK_HOD_Department foreign key (HOD) references Doctors(DoctorID)
);

Use [CMS_DB] Create Table HospitalStaff(
	StaffID nvarchar(10) primary key,
	CurrentDepartment nvarchar(20),
	CurrentDuty nvarchar(100),
	CurrentShify nvarchar(100),
	constraint FK_Staff_StaffID foreign key (StaffID) references Users(UserID)
);

Use [CMS_DB] Create table Offices(
	OfficeID nvarchar(10) primary key,
	Department nvarchar(20),
	Person nvarchar(10),
	constraint FK_Offices_Person foreign key(Person) references HospitalStaff(StaffID)
);

Use [CMS_DB] Create table InsuranceCompanies(
	InsuranceCompanyID nvarchar(20) primary key,
	InsuranceCompanyName nvarchar(100) ,
	InsuranceCompanyAddress nvarchar(100),
	InsuranceCompanyContact nvarchar(100),
);

Use [CMS_DB] create table PatientInsurance(
	InsuranceID nvarchar (20) primary key,
	PatientID nvarchar (10),
	IsInsuranceActive Bit,
	TotalInsurance int,
	InsuranceCompanyName nvarchar(100),
	InsuranceCompanyID nvarchar(20),
	TotalAvailableAmount int,
	constraint FK_Insurance_CompanyID foreign key (InsuranceCompanyID) references InsuranceCompanies(InsuranceCompanyID),
	constraint FK_Insurance_PatientID foreign key (PatientID) references Patients(PatientID)
);

Use [CMS_DB] Create Table HospitalBill(
	BillID nvarchar(20) primary key,
	PatientID nvarchar (10),
	InsuranceID nvarchar(20),
	TotalAmount int,
	BillAmountCoveredByInsurance int,
	AmountAfterInsurance int,
	constraint FK_Bill_PatientID foreign key (PatientID) references Patients(PatientID),
	constraint FK_Bill_InsuranceID foreign key (InsuranceID) references PatientInsurance(InsuranceID)
);
Use [CMS_DB] Create Table PaymentMethod(
PaymentID nvarchar(20) primary key,
BillID nvarchar(20),
PaymentMethod nvarchar(20),
TotalAmount int,
IsPaymentProcessed bit,
constraint FK_Payements_BillID foreign key (BillID) references HospitalBill(BillID)
);

Use [CMS_DB] create table PatientRooms(
RoomID nvarchar(20) primary key,
IsRoomOccupied bit,
PatientID nvarchar(10) references Patients(PatientID),
);