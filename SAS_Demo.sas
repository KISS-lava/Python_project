data class_new;
	set sashelp.class;
	BMI=round(Weight*0.454/ ((Height*0.0254)**2),0.1);
run;

proc print data=class_new;
run;