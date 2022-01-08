data test;
input account_id $13. salary age;
datalines;
9120690334455 15000 31
9127550653434 18000 35
9126130654321 17000 30
;
quit;


%macro split_account_id(table_name);

	%let libname = WORK;
	%col_names(&libname., &table_name.);
	data temp;
		set columns_of_&table_name.;
		where name = 'account_id';
	run;
	%clean(columns_of_&table_name.);
	%shape(temp);
	proc sql noprint;
	select number_of_rows into: n
	from temp_shape
	;quit;
	%IF &n > 0
		%then %do;
			proc sql noprint;
			create table &table_name. as
			select
				   substr(account_id,4,3) as branch_id,
				   substr(account_id,8,6) as account,
				   t.*
			from &table_name. as t
			;
			quit;

		%end;
	%ELSE
		 %do;
		   %put THERE IS NO account_id column in a given dataset!;
		 %end;
%clean(temp);

%save_origin_cols_order(&table_name.);
	%convert_to_num(branch_id, &libname., &table_name.);
	%convert_to_num(account, &libname., &table_name.);
%back_origin_cols_order(&table_name.);

%mend split_account_id;


%split_account_id(test);
