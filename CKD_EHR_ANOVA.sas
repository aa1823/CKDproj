
FILENAME REFFILE '/home/u62330021/stat660finalproj/ChronicKidneyDisease_EHRs_from_AbuDhabi.csv';

PROC IMPORT DATAFILE=REFFILE
	DBMS=CSV
	OUT=ckd;
	GETNAMES=YES;
RUN;

PROC CONTENTS DATA=ckd; RUN;

proc format ;
	value BP
	1 = "Normal"
	2 = "Elevated" 
	3 = "High Blood Pressure (Hypertension STG 1)"
	4 = "High Blood Pressure (Hypertension STG 2)" 
	5 = "Hypertensive Crisis"  ;
	
	VALUE CKD 
	0 = "No"
	1 = "Yes" ; 
	
	VALUE Sex 
	0 = "Female"
	1 = "Male" ; 

RUN;


	data ckd2 ; 
		set ckd ;
		format BP BP.;
		*format Sex Sex.;
		*format CKD CKD. ; 
		IF (sBPBaseline < 120) AND (dBPBaseline < 80) THEN BP = 1;
		IF (120 =< sBPBaseline <= 129) AND (dBPBaseline < 80) THEN BP = 2; 
		IF (130 <= sBPBaseline <= 139) OR (80 <= dBPBaseline <= 89) THEN BP = 3; 
		IF (sBPBaseline => 140) OR (dBPBaseline => 90) THEN BP = 4; 
		IF (sBPBaseline > 180) OR (dBPBaseline > 120) THEN BP = 5; 
		run;
		
	proc print data=ckd2; 
		run;


	
	proc glm data=ckd2;
		title "This is the Fixed Effect model";
		class Sex BP;
		model CreatinineBaseline=Sex BP/solution;
		*random temp temp*model / test;
		run;
	quit;
	
	proc glm data=ckd2;
    class Sex BP;
    model CreatinineBaseline = Sex BP Sex*BP;
    lsmeans Sex BP / pdiff adjust=tukey;
run;
quit;
	x4
	

	

