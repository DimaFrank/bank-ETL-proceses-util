%macro create_account_id(table_name, branch, account);

	data preparation;
		set &table_name.;
		branch_copy = &branch.;
		account_copy = &account.;
	run;

	%type(preparation, account_copy);

	%if  "&type"="num " %then
		%do;
			%convert_to_char(preparation, account_copy);
			data preparation;
				set preparation;
				if &account. > 99 and &account. <= 999
					then account_copy = CATS('000',account_copy);
				else if &account. > 999 and &account. <=9999
					then account_copy = CATS('00',account_copy);
				else if &account. > 9999 and &account. <= 99999
					then account_copy = CATS('0', account_copy);
				else account_copy = &account.;
			run;
				
		%end;
	%if  "&type"="char" %then
		%do;
			data preparation;
				set preparation;
				acc_temp = &account.;
			run;

			%convert_to_num(acc_temp, work, preparation);
			data preparation;
				set preparation;
				if acc_temp > 99 and acc_temp <= 999
					then account_copy = CATS('000',account_copy);
				else if acc_temp > 999 and acc_temp <=9999
					then account_copy = CATS('00',account_copy);
				else if acc_temp > 9999 and acc_temp <= 99999
					then account_copy = CATS('0', account_copy);
				else account_copy = acc_temp;
			run;
			%drop_column(preparation, acc_temp);
		
		%end;

	%else %do;
		%put Invalid type of column 'account' is provided!;
		%end;

	

	%type(preparation, branch_copy);
	%put BRANCH IS &type;
	%if "&type"="num " %then 
		%do;
			%convert_to_char(preparation, branch_copy);
			data preparation;
				set preparation;
				if &branch. > 9 and &branch. <=99
					then branch_copy = CATS('0', branch_copy);
				else branch_copy = &branch.;
				run;

		%end;
	
	%if "&type"="char" %then 
		%do;
			data preparation;
				set preparation;
				branch_temp = &branch.;
			run;
			
			%convert_to_num(branch_temp, work, preparation);
			data preparation;
				set preparation;
				if branch_temp > 9 and branch_temp <=99
					then branch_copy = CATS('0', branch_copy);
			run;
			%drop_column(preparation, branch_temp);
		%end;


	 proc sql;
		 create table final
		 as
		 select p.*,
	 			   case 
						when account_copy like '%.%' OR account_copy = ''
				   			then ''
						when branch_copy like '%.%' OR branch_copy = ''
							then ''
						else CATS('912',branch_copy,'0', account_copy)
					end as account_id

	 	 from preparation as p
	 ;quit;

	 %drop_column(final, branch_copy);
	 %drop_column(final, account_copy); 
	 %clean(preparation);
	 %rename_table(final, &table_name.);

%mend create_account_id;





