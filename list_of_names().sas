
%*******************************************************************************;
%* This function replace all column names in a given dataset    		       *;
%* by a list of names provided as an argument to the function.                 *;
%* The list of strings provided to the function should be separeted by space.  *;
%* 																		       *;
%* Created: 11/01/2022 Dima Frank										       *;
%* Variables: _list_ , table_name(should be a dataset from a Work library)     *;
%* Ecample: %let new_names = A B C; 										   *;
%*			%list_of_names(test_table, &new_names.);						   *;
%*																		       *;		
%*******************************************************************************;

%macro list_of_names(table_name, _list_);

	%let libname = WORK;
	%global list_of_cols;

	%col_names(&libname., &table_name.);
	proc sql noprint;
	select name 
	into: list_of_cols separated by ' '
	from columns_of_&table_name.
	;
	quit;

	%shape(&table_name.);
	proc sql noprint;
	select number_of_columns into: n
	from &table_name._shape
	;
	quit;
	

	%do i=1 %to &n;
		%let old_name=%scan(&list_of_cols,&i,%str( ));
		%let new_name=%scan(&_list_,&i,%str( ));
		%rename_column(&table_name., &old_name., &new_name.);
	%end;
	
	%clean(&table_name._shape);

%mend list_of_names;






