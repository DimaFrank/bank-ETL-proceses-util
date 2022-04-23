
%*******************************************************************************;
%* To get an item from a given list by index.			   		       		   *;
%* The function asserts that the list is separated by space. 	    	       *;
%* Change the deafault separator by providing it as a third argument.		   *;
%*																			   *;		
%*																			   *;
%* Created: 11/01/2022 Dima Frank										       *;
%* Variables: list , index,  separator = ' ' by deafault			           *;
%* Returns: The function initialize the output variable -> &item	 	       *;
%* Ecample: %let my_list = USD RUB ILS GDP EUR CHF KRW NZD;                    *;
%*			    %get_item(&my_list., 5);                                       *;
%*              %put &item;                                                    *;
%*																		       *;		
%*******************************************************************************;


%macro get_item(list, index);

	%global item;
	%let item=%scan(&list,&index,%str( ));
	

%mend get_item;




/*%let my_list1 = USD RUB ILS GDP EUR CHF KRW NZD;  */
/*%get_item(&my_list1,5);*/
/*%put &item;*/


