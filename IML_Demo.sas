proc iml;                   /* begin IML session */

start MySqrt(x);            /* begin module */
   y = 1;                   /* initialize y */
   do until(w<1e-3);        /* begin DO loop */
      z = y;                /* set z=y */
      y = 0.5#(z+x/z);      /* estimate square root */
      w = abs(y-z);         /* compute change in estimate */
   end;                     /* end DO loop */
   return(y);               /* return approximation */
finish;                     /* end module */

t = MySqrt({3,4,7,9});      /* call function MySqrt  */
s = sqrt({3,4,7,9});        /* compare with true values */
diff = t - s;               /* compute differences */
print t s diff;             /* print matrices */

quit;


****************************************************************;
/* proc options option=RLANG; */
/* run; */

proc iml;
	call ExportDataSetToR("sashelp.class","classdf");
	submit / R;
		lmod <- lm(Weight ~ Height + Age + Sex, data = classdf)
		lmod_sum <- summary(lmod)
		lmod_coefs <- lmod_sum$coefficients
		lmod_coefs
	endsubmit;
run;

proc iml;
	submit / R;
		library(MASS)
		lm(VitC ~ Cult + Date + HeadWt, data = cabbages)
	endsubmit;
run;

proc iml;
	submit / R;
		library(MASS)
	endsubmit;
	call ImportDataSetFromR("sascab", "cabbages");
quit;


proc iml;
	submit / R;
		# install.packages("ggalluvial", repos = "https://cran.r-project.org/")
		library(tidyverse)
		library(ggalluvial)
		ggplot(as.data.frame(UCBAdmissions),aes(y = Freq, axis1 = Gender, axis2 = Dept)) +
  			geom_alluvium(aes(fill = Admit), width = 1/12) +
			geom_stratum(width = 1/12, fill = "black", color = "grey") +
  			geom_label(stat = "stratum", aes(label = after_stat(stratum))) +
  			scale_x_discrete(limits = c("Gender", "Dept"), expand = c(.05, .05)) +
  			scale_fill_brewer(type = "qual", palette = "Set1") +
  			ggtitle("UC Berkeley admissions and rejections, by sex and department")
		ggsave("/Users/bernard.ma@sas.com/ggalluvialtest.png")
	endsubmit;
quit;

proc iml;
	submit / R;
		library(tidyverse)
		library(ggplot2)
		ggplot(iris, aes(x=Sepal.Length, y=Sepal.Width, alpha=Species)) + geom_point(size=6, color="#69b3a2") +
			ggsave("/export/viya/homes/bernard.ma@sas.com/ggplottest.png")
	endsubmit;
quit;

****************************************************************;
