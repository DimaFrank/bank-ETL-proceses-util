%macro fillna(table_name, column, value=mean_value);
	
	%clone(&table_name.);
	%rename_table(copy_of_&table_name., main);
	%type(main, &column);
	%IF "&type"="num " %THEN
		%DO;
			%shape(main);
			proc sql noprint;
				select number_of_rows into: n
				from main_shape
			;quit;

			%sum(main, &column.);
			proc sql noprint;
				select * into: sum
				from _SUM_
			;quit;

			%if &value = mean_value OR &value = mean %then 
				%do;
					data &table_name;
						set &table_name;
						if &column = . then &column = &sum/&n;
					run;
				%end;

				%else %if &value = median %then 
					%do;

						data t_temp;
							set &table_name;
							if &column = . then &column = 0;
						run;
						%median(t_temp, &column.);

						proc sql noprint;
							select median into: median
							from _MEDIAN_
						;quit;

						data &table_name;
							set &table_name;
							if &column = . then &column = &median;
						run;
						%clean(t_temp);
						%clean(_MEDIAN_);

					%end;

						%else %do;
							data &table_name;
								set &table_name;
								if &column = . then &column = &value;
							run;
						%end;

		%clean(main_shape);
		%clean(_SUM_);
	 %END;


	 %ELSE %DO;
			
	 		data &table_name;
				set &table_name;
				if &column = '' then &column = &value;
			run;
			
	  %END;
		%clean(main);


%mend fillna;


