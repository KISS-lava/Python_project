/*Sort by descending length of bars*/

proc sort data=final1 out=final1;
	by descending line_end;
run;

proc format;
	value stage 1="Stage 1"
	2="Stage 2"
	3="Stage 3"
	4="Stage 4";
run;

data final1;
	set final1;

	/*Create new subject number variable based on the descending order*/
	subjn=_n_;

	/*Flag the Durable Responder subjects and set DURRESP as the location for symbol*/
	if adrfl='Y' then durresp=-.25;
	label dstage="Disease Stage";
	format dstage stage.;
run;

proc sort data=final1;
	by subjn;
run;

***CREATE ANNOTATE DATA SETS***;

/*Arrows at the end of the bars for continuing response*/
data anno1;
	length function linecolor $25;
	retain drawspace "datavalue" linecolor "black" linethickness 3;
	set final1(keep=subjid subjn line_end symbol where=(symbol='a'));
	function='ARROW';
	x1=line_end+.05;
	x2=line_end+.8;
	y1=subjn;
	y2=subjn;
	shape='FILLED';
run;

/*Customized legend with symbols and text*/
data anno2;
	length label $100 function fillcolor linecolor $25;
	retain drawspace 'datavalue' linethickness 3 display 'ALL'
	widthunit 'data' heightunit 'data' anchor 'left';

	/*Draw red triangle indicating complete response start time*/
	function='POLYGON';
	x1=15.20;
	y1=4.10;
	linecolor='red';
	fillcolor='red';
	output;
	function='POLYCONT';
	x1=15.30;
	y1=3.90;
	linecolor='red';
	output;
	function='POLYCONT';
	x1=15.10;
	y1=3.90;
	linecolor='red';
	output;
	function='POLYCONT';
	x1=15.20;
	y1=4.10;
	linecolor='red';
	output;

	/*Draw blue triangle indicating partial response start time*/
	function='POLYGON';
	x1=15.20;
	y1=3.1;
	linecolor='blue';
	fillcolor='blue';
	output;
	function='POLYCONT';
	x1=15.30;
	y1=2.9;
	linecolor='blue';
	output;
	function='POLYCONT';
	x1=15.10;
	y1=2.9;
	linecolor='blue';
	output;
	function='POLYCONT';
	x1=15.20;
	y1=3.1;
	linecolor='blue';
	output;

	/*Draw a circle indicating response end time using the OVAL function*/
	function='OVAL';
	x1=15.125;
	y1=8;
	linecolor='black';
	fillcolor='black';
	height=.25;
	width=.2;
	output;

	/*Draw an arrow indicating continuing response*/
	function='ARROW';
	x1=15;
	x2=15.8;
	y1=9;
	y2=9;
	linecolor='black';
	shape='FILLED';
	output;

	/*Draw a square indicating durable responder using the RECTANGLE function*/
	function='RECTANGLE';
	x1=15.125;
	y1=10;
	linecolor='black';
	fillcolor='black';
	height=.25;
	width=.2;
	output;

	/*Create text labels for the legend*/
	function='TEXT';
	x1=16;
	y1=6;
	label="Complete response start";
	width=7;
	shape='';
	fillcolor='';
	output;
	function='TEXT';
	x1=16;
	y1=7;
	label="Partial response start";
	width=7;
	shape='';
	fillcolor='';
	output;
	function='TEXT';
	x1=16;
	y1=8;
	label="Response episode end";
	width=7;
	shape='';
	fillcolor='';
	output;
	function='TEXT';
	x1=16;
	y1=9;
	label="Continued response";
	width=7;
	shape='';
	fillcolor='';
	output;
	function='TEXT';
	x1=16;
	y1=10;
	label="Durable Responder";
	width=7;
	shape='';
	fillcolor='';
	output;
run;

/*Set both annotate data sets together to specify in PROC SGPLOT*/
data anno;
	set anno1 anno2;
run;

/*Attribute map for assigning colors for disease stage in GROUP= option*/
data attrmap;
	length fillcolor $25;
	ID='A';
	value=1;
	fillcolor='cx7C95CA';
	linecolor='cx7C95CA';
	output;
	ID='A';
	value=2;
	fillcolor='cxDE7E6F';
	linecolor='cxDE7E6F';
	output;
	ID='A';
	value=3;
	fillcolor='cx66A5A0';
	linecolor='cx66A5A0';
	output;
	ID='A';
	value=4;
	fillcolor='cxA9865B';
	linecolor='cxA9865B';
	output;
run;

proc sgplot data=final1 dattrmap=attrmap sganno=anno;
	hbarparm category=subjn response=line_end/group=dstage attrid=A barwidth=.5;
	scatter X=durresp Y=subjn /markerattrs=(symbol=squarefilled size=9 
		color=black);
	scatter X=crstart1 Y=subjn /markerattrs=(symbol=trianglefilled size=9 
		color=red);
	scatter X=crstart2 Y=subjn /markerattrs=(symbol=trianglefilled size=9 
		color=red);
	scatter X=prstart1 Y=subjn /markerattrs=(symbol=trianglefilled size=9 
		color=blue);
	scatter X=prstart2 Y=subjn /markerattrs=(symbol=trianglefilled size=9 
		color=blue);
	scatter X=end1 Y=subjn /markerattrs=(symbol=circlefilled size=9 color=black);
	scatter X=end2 Y=subjn /markerattrs=(symbol=circlefilled size=9 color=black);
	yaxis type=discrete display=(novalues noticks) label="Subjects Received Drug";
	xaxis type=linear label="Months" values=(-1 to 20 by 1);
run;