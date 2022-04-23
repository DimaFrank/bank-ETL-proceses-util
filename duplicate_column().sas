%macro duplicate_column(table_name, col_name, n=1);

	data temp;
		set &table_name.;
	run;

	%do i=1 %to &n.;
		proc sql;
		create table temp
		as
		select *, &col_name. as &col_name._&i.
		from temp
		;quit;
	%end;

	%rename_table(temp, &table_name.);
	
%mend duplicate_column;



