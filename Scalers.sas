data test;
input A B C;
datalines;
1 4 5
4 5 3
8 9 4
12 34 5 
;
run;


title 'Before Scaling';
proc means data=test;
run;


%macro StandardScaler(dataset, variable);

	proc means noprint data=&dataset.;
		output out = stats;
	run;
	
	proc sql noprint;
		select &variable. into: mean  from stats
		where _STAT_ ='MEAN'
	;quit;
	
	proc sql noprint;
		select &variable. into: std  from stats
		where _STAT_ ='STD'
	;quit;
	
	data &dataset.;
		set &dataset;
		&variable. = (&variable. - &mean.)/ &std. ;
	run;
		
	proc delete data = stats;
	run;
	
%mend StandardScaler;



%macro MinMaxScaler(dataset, variable, min=0, max=1);

	proc means noprint data=&dataset.;
		output out = stats;
	run;
	
	proc sql noprint;
		select &variable. into: min_p  from stats
		where _STAT_ ='MIN'
	;quit;
	
	proc sql noprint;
		select &variable. into: max_p  from stats
		where _STAT_ ='MAX'
	;quit;
	
	data &dataset.;
		set &dataset;
		&variable._std = ((&variable.- &min_p.)) / (&max_p. - &min_p.);
		&variable. = (&variable._std * (&max.- &min.)) + &min.;
		drop &variable._std;
	run;

	proc delete data = stats;
	run;
	
%mend MinMaxScaler;


title 'Original dataset';
proc print data=test;
run;

%MinMaxScaler(test, A, min=5,max=10);
%MinMaxScaler(test, B, min=90, max=100);
%MinMaxScaler(test, C);



title 'After Scaling';
proc print data=test;
run;

proc means data=test;
run;

