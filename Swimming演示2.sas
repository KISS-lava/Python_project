/*  */
%let gpath='/export/viya/homes/bernard.ma@sas.com/';
%let dpi=200;
/*  */
ods html close;
ods listing gpath=&gpath image_dpi=&dpi;

data swimmer;
  input item stage $4-12 low high highcap $25-40 status $40-60 start end durable;
  startline=start; endline=end;
  if status ne ' ' then do;
    if end eq . then endline=high-0.3;
    if start eq . then startline=low+0.3;
  end;
  if stage eq ' ' then durable=.;
  ymin=-1;
  datalines;
1  Stage 1  0  18.5     FilledArrow     Complete response      6.5  13.5  -0.25
2  Stage 2  0  17.0                     Complete response     10.5  17.0  -0.25
3  Stage 3  0  14.0     FilledArrow     Partial response       2.5   3.5  -0.25
3           0  14.0     FilledArrow     Partial response       6.0     .  -0.25
4  Stage 4  0  13.5     FilledArrow     Partial response       7.0  11.0     .
4           0  13.5     FilledArrow     Partial response      11.5     .     .
5  Stage 1  0  12.5     FilledArrow     Complete response      3.5   4.5  -0.25
5           0  12.5     FilledArrow     Complete response      6.5   8.5  -0.25
5           0  12.5     FilledArrow     Partial response      10.5     .  -0.25
6  Stage 2  0  12.6     FilledArrow     Partial response       2.5   7.0     .
6           0  12.6     FilledArrow     Partial response       9.5     .     .
7  Stage 3  0  11.5                     Complete response      4.5  11.5  -0.25
8  Stage 1  0   9.5                     Complete response      1.0   9.5  -0.25
9  Stage 4  0   8.3                     Partial response       6.0     .     .
10 Stage 2  0   4.2     FilledArrow     Complete response      1.2     .     .
;
run;

ods html;
proc print;run;
ods html close;

data attrmap;
length ID $ 9 linecolor markercolor $ 20;
input id $ value $10-30 linecolor $ markercolor;
datalines;
status   Complete response    darkred   darkred
status   Partial response     blue      blue
;
run;
proc print;run;


ods graphics on / reset height=3.5in width=6in imagename='Swimmer'; 
/* footnote  J=l h=0.8 'Each bar represents one subject in the study.'; */
/* footnote2 J=l h=0.8 'A durable responder is a subject who has confirmed response for at least 183 days (6 months).'; */
proc sgplot data= swimmer /*dattrmap=attrmap*/ nocycleattrs;
  highlow y=item low=low high=high / highcap=highcap type=bar group=stage fill nooutline
          lineattrs=(color=black) name='stage' barwidth=1 nomissinggroup transparency=0.3;
  highlow y=item low=startline high=endline / group=status lineattrs=(thickness=2 pattern=solid) 
          name='status' nomissinggroup attrid=status;
  scatter y=item x=start / markerattrs=(symbol=trianglefilled size=8) name='s' legendlabel='Response start' /*group=status attrid=status*/;
  scatter y=item x=end / markerattrs=(symbol=circlefilled size=8) name='e' legendlabel='Response end' /*group=status attrid=status*/;
  scatter y=ymin x=low / markerattrs=(symbol=trianglerightfilled size=14 color=darkgray) name='x' legendlabel='Continued response ';
  scatter y=item x=durable / markerattrs=(symbol=squarefilled size=6 color=black) name='d' legendlabel='Durable responder';
/*   scatter y=item x=start / markerattrs=(symbol=trianglefilled size=8) group=status attrid=status; */
/*   scatter y=item x=end / markerattrs=(symbol=circlefilled size=8) group=status attrid=status; */
  xaxis label='Months' values=(0 to 20 by 1) valueshint;
  yaxis reverse display=(noticks novalues noline) label='Subjects Received Study Drug' min=1;
  keylegend 'stage' / title='Disease Stage';
  keylegend 'status' 'd' 's' 'e'  'x' / noborder location=inside position=bottomright across=1;
  run;
/* footnote; */

