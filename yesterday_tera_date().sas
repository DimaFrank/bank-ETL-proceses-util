
%macro yesterday_tera_date();

data date;	
	today_date = today();
	_d_ = day(today_date);
	_m_ = month(today_date);
	_y_ = year(today_date);
	format today_date mmddyyd10.;
	calendar_month = ((_y_*100)+_m_);
	tera_format = ( ((MOD(_y_,1000)+100)*100 + _m_)*100 + _d_ );
run;

proc sql noprint;
select calendar_month, _d_, _m_
into: calendar_month, :_d_, :_m_
from date
;quit;

Proc Sql noprint;
Connect to teradata As ConDbms
(mode=teradata);
create table  calendar  as 
select  *
From Connection to ConDbms
(
	select Prev_Working_Day
	from calendar2
	where calendar_month = &calendar_month.
	and TheMonth = &_m_. and TheDay = &_d_.
	order by 1
);
DisConnect From ConDbms;
Quit;

data yesterday;
	set calendar;
	day = day(Prev_Working_Day);
	month = month(Prev_Working_Day);
	year = year(Prev_Working_Day);
	yesterday_tera = ( ((MOD(year,1000)+100)*100 + month)*100 +day );
run;
%global yesterday_tera_date;
proc sql noprint;
select yesterday_tera into:yesterday_tera_date from yesterday
;quit;

%clean(date);
%clean(calendar);
%clean(yesterday);


%mend yesterday_tera_date;






%yesterday_tera_date();


data test;
var1= %yesterday_tera_date();
run;

