/*  */
FILENAME REFFILE FILESRVC FOLDERPATH='/Users/bernard.ma@sas.com/My Folder/Demo'  FILENAME='SwimmerPlotDataN.csv';

PROC IMPORT DATAFILE=REFFILE
	DBMS=CSV
	OUT=WORK.swimmer;
	GETNAMES=YES;
RUN;

%let gpath='/export/viya/homes/bernard.ma@sas.com/';
%let dpi=200;

ods html close;
ods listing gpath=&gpath image_dpi=&dpi;

ods graphics on / reset height=3.5in width=6in imagename='Swimmer'; 
proc sgplot data= swimmer  nocycleattrs;
  highlow y=item low=low high=high / highcap=highcap type=bar group=stage fill nooutline
          lineattrs=(color=black) name='stage' barwidth=1 nomissinggroup transparency=0.3;

  scatter y=item x=PR / markerattrs=(symbol=squarefilled size=8 color=blue) name='R' legendlabel='Partial Response' /*group=status attrid=status*/;
  scatter y=item x=SD / markerattrs=(symbol=HomeDownFilled size=8 color=green) name='S' legendlabel='Stable Disease' /*group=status attrid=status*/;
  scatter y=item x=PD / markerattrs=(symbol=DiamondFilled size=8 color=red) name='P' legendlabel='Progressive Disease';
  scatter y=ymin x=low / markerattrs=(symbol=trianglerightfilled size=14 color=darkgray) name='C' legendlabel='Treatment ongoing';

  xaxis label='Months' values=(0 to 20 by 1) valueshint;
  yaxis reverse display=(noticks novalues noline) label='Subjects Received Study Drug' min=1;
  keylegend 'stage' / title='Disease Stage';
  keylegend 'R' 'S' 'P'  'C' / noborder location=inside position=bottomright across=1;
  run;
