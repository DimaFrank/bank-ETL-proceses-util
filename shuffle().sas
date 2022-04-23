%macro shuffle(dataset);

	data _rand_;
		set &dataset;
		_r_ = rand('Uniform');
	run;
	proc sort data=_rand_ out =_rand_;
		by _r_;
	run;
	%drop_column(_rand_, _r_);
	%rename_table(_rand_, &dataset.);
	
%mend shuffle;
