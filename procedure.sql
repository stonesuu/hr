create procedure hr_salary_cal()
begin
declare id_chk varchar(20);
declare base_salary_stf float(7,2);
declare high_temp_base_stf float(7,2);
declare special_job_base_stf float(7,2);
declare night_job_base_stf float(7,2);
declare leader_salary_stf float(7,2);
declare age_salary_stf float(7,2);
declare meal_base_stf float(7,2);
declare env_salary_stf float(7,2);
declare SB_base_stf float(7,2);
declare YB_base_stf float(7,2);
declare switch_stf int;
declare BJ_chk float(4,2);
declare SJ_chk float(4,2);
declare KG_chk float(4,2);
declare TQJ_chk float(4,2);
declare HSJ_chk float(4,2);
declare CJ_chk float(4,2);
declare GSJ_chk float(4,2);
declare QTJ_chk float(4,2);
declare JHSYJ_chk float(4,2);
declare GJ_chk float(4,2);
declare full_night_job_chk float(4,2);
declare holiday_job_chk float(4,2);
declare sunday_job_chk float(4,2);
declare add_job_chk float(4,2);
declare JT_days_chk float(4,2);
declare reward_salary_chk float(7,2);
declare check_salary_chk float(7,2);
declare BX_check_chk float(7,2);
declare ZG_sal float(4,2);
declare base_salary_sal float(7,2);
declare salary_XJ_sal float(7,2);
declare check_salary_sal float(7,2);
declare high_temp_salary_sal float(7,2);
declare special_job_salary_sal float(7,2);
declare leader_salary_sal float(7,2);
declare add_job_salary_sal float(7,2);
declare age_salary_sal float(7,2);
declare night_job_salary_sal float(7,2);
declare meal_salary_sal float(7,2);
declare env_salary_sal float(7,2);
declare reward_salary_sal float(7,2);
declare salary_get_sal float(7,2);
declare SB_base_sal float(7,2);
declare YB_base_sal float(7,2);
declare YL_C_sal float(7,2);
declare YL_I_sal float(7,2);
declare SY_C_sal float(7,2);
declare SY_I_sal float(7,2);
declare GS_C_sal float(7,2);
declare YB_C_sal float(7,2);
declare YB_I_sal float(7,2);
declare BI_C_sal float(7,2);
declare SI_C_sal float(7,2);
declare BX_check_sal float(7,2);
declare BX_XJ_sal float(7,2);
declare tex_sal float(7,2);
declare salary_sum_sal float(7,2);
declare done int default 0;
declare cur01 cursor for (select id,BJ,SJ,KG,TQJ,HSJ,CJ,GSJ,QTJ,JHSYJ,GJ,full_night_job,holiday_job,sunday_job,add_job,JT_days,reward_salary,check_salary,BX_check from check_once);
declare continue handler for sqlstate '02000' set done = 1;
start transaction;
delete from salary_once;
open cur01;
fetch cur01 into id_chk,BJ_chk,SJ_chk,KG_chk,TQJ_chk,HSJ_chk,CJ_chk,GSJ_chk,QTJ_chk,JHSYJ_chk,GJ_chk,full_night_job_chk,holiday_job_chk,sunday_job_chk,add_job_chk,JT_days_chk,reward_salary_chk,check_salary_chk,BX_check_chk;
while not done do
select base_salary,high_temp_base,special_job_base,night_job_base,leader_salary,age_salary,meal_base,env_salary,SB_base,YB_base,switch into base_salary_stf,high_temp_base_stf,special_job_base_stf,night_job_base_stf,leader_salary_stf,age_salary_stf,meal_base_stf,env_salary_stf,SB_base_stf,YB_base_stf,switch_stf from stuff where id=id_chk;
set ZG_sal = 21.75-BJ_chk-SJ_chk-KG_chk-TQJ_chk-GSJ_chk-QTJ_chk-JHSYJ_chk-GJ_chk;
set base_salary_sal = base_salary_stf;
set salary_XJ_sal = 1.5*base_salary_sal*(ZG_sal+BJ_chk*0.6)/21.75;
set check_salary_sal = check_salary_chk;
set high_temp_salary_sal = high_temp_base_stf*JT_days_chk;
set special_job_salary_sal = special_job_base_stf*JT_days_chk;
set leader_salary_sal = leader_salary_stf;
set add_job_salary_sal = 1.5*base_salary_sal*(3*holiday_job_chk+2*sunday_job_chk+1.5*add_job_chk)/21.75;
if (BJ_chk+SJ_chk+KG_chk+TQJ_chk+HSJ_chk+CJ_chk+GSJ_chk+QTJ_chk+JHSYJ_chk+GJ_chk)>=10 then
set age_salary_sal = 0;
set env_salary_sal = 0;
elseif (BJ_chk+SJ_chk+KG_chk+TQJ_chk+HSJ_chk+CJ_chk+GSJ_chk+QTJ_chk+JHSYJ_chk+GJ_chk)>=5 then
set age_salary_sal = age_salary_stf*0.5;
set env_salary_sal = env_salary_stf*0.5;
else
set age_salary_sal = age_salary_stf;
set env_salary_sal = env_salary_stf;
end if;
set night_job_salary_sal = night_job_base_stf*JT_days_chk;
set meal_salary_sal = meal_base_stf*JT_days_chk;
set reward_salary_sal = reward_salary_chk;
set salary_get_sal = salary_XJ_sal+check_salary_sal+high_temp_salary_sal+special_job_salary_sal+leader_salary_sal+add_job_salary_sal+age_salary_sal+night_job_salary_sal+meal_salary_sal+reward_salary_sal;
set SB_base_sal = SB_base_stf;
set YB_base_sal = YB_base_stf;
set YL_C_sal = SB_base_sal*0.2;
set YL_I_sal = SB_base_sal*0.08;
set SY_C_sal = SB_base_sal*0.01;
set SY_I_sal = SB_base_sal*0.005;
set GS_C_sal = SB_base_sal*0.015;
set YB_C_sal = YB_base_sal*0.07;
set YB_I_sal = YB_base_sal*0.02;
set BI_C_sal = YB_base_sal*0.005;
set SI_C_sal = 11;
set BX_check_sal = BX_check_chk;
set BX_XJ_sal = YL_I_sal+SY_I_sal+YB_I_sal;
if (salary_get_sal-BX_XJ_sal)<=3500 then
set tex_sal = 0;
elseif (salary_get_sal-BX_XJ_sal)<=5000 then
set tex_sal = (salary_get_sal-BX_XJ_sal-3500)*0.03;
elseif (salary_get_sal-BX_XJ_sal)<=8000 then
set tex_sal = (salary_get_sal-BX_XJ_sal-5000)*0.1+105+45;
else
set tex_sal = (salary_get_sal-BX_XJ_sal-8000)*0.2+555+450+45;
end if;
set salary_sum_sal = salary_get_sal-BX_XJ_sal-tex_sal;
insert into salary_once(id,ZG,base_salary,salary_XJ,check_salary,high_temp_salary,special_job_salary,leader_salary,add_job_salary,age_salary,night_job_salary,meal_salary,env_salary,reward_salary,salary_get,SB_base,YB_base,YL_C,YL_I,SY_C,SY_I,GS_C,YB_C,YB_I,BI_C,SI_C,BX_check,BX_XJ,tex,salary_sum) values (id_chk,ZG_sal,base_salary_sal,salary_XJ_sal,check_salary_sal,high_temp_salary_sal,special_job_salary_sal,leader_salary_sal,add_job_salary_sal,age_salary_sal,night_job_salary_sal,meal_salary_sal,env_salary_sal,reward_salary_sal,salary_get_sal,SB_base_sal,YB_base_sal,YL_C_sal,YL_I_sal,SY_C_sal,SY_I_sal,GS_C_sal,YB_C_sal,YB_I_sal,BI_C_sal,SI_C_sal,BX_check_sal,BX_XJ_sal,tex_sal,salary_sum_sal);
fetch cur01 into id_chk,BJ_chk,SJ_chk,KG_chk,TQJ_chk,HSJ_chk,CJ_chk,GSJ_chk,QTJ_chk,JHSYJ_chk,GJ_chk,full_night_job_chk,holiday_job_chk,sunday_job_chk,add_job_chk,JT_days_chk,reward_salary_chk,check_salary_chk,BX_check_chk;
end while;
close cur01;
commit;
end//



create procedure hr_check_all(date_sub varchar(20))
begin
create temporary table check_tmp select * from check_once;
alter table check_tmp add column date datetime;
update check_tmp set date=date_sub;
delete from check_all where date=date_sub;
insert into check_all select * from check_tmp;
drop table check_tmp;
end //

create procedure hr_salary_all(date_sub varchar(20))
begin
create temporary table salary_tmp select * from salary_once;
alter table salary_tmp add column date datetime;
update salary_tmp set date=date_sub;
delete from salary_all where date=date_sub;
insert into salary_all select * from salary_tmp;
drop table salary_tmp;
end //

create procedure hr_salary_cal()
begin
declare id_chk varchar(20);
declare base_salary_stf float(7,2);
declare high_temp_base_stf float(7,2);
declare special_job_base_stf float(7,2);
declare night_job_base_stf float(7,2);
declare leader_salary_stf float(7,2);
declare age_salary_stf float(7,2);
declare meal_base_stf float(7,2);
declare env_salary_stf float(7,2);
declare SB_base_stf float(7,2);
declare YB_base_stf float(7,2);
declare switch_stf int;
declare BJ_chk float(4,2);
declare SJ_chk float(4,2);
declare KG_chk float(4,2);
declare TQJ_chk float(4,2);
declare HSJ_chk float(4,2);
declare CJ_chk float(4,2);
declare GSJ_chk float(4,2);
declare QTJ_chk float(4,2);
declare JHSYJ_chk float(4,2);
declare GJ_chk float(4,2);
declare full_night_job_chk float(4,2);
declare holiday_job_chk float(4,2);
declare sunday_job_chk float(4,2);
declare add_job_chk float(4,2);
declare JT_days_chk float(4,2);
declare reward_salary_chk float(7,2);
declare check_salary_chk float(7,2);
declare BX_check_chk float(7,2);
declare ZG_sal float(4,2);
declare base_salary_sal float(7,2);
declare salary_XJ_sal float(7,2);
declare check_salary_sal float(7,2);
declare high_temp_salary_sal float(7,2);
declare special_job_salary_sal float(7,2);
declare leader_salary_sal float(7,2);
declare add_job_salary_sal float(7,2);
declare age_salary_sal float(7,2);
declare night_job_salary_sal float(7,2);
declare meal_salary_sal float(7,2);
declare env_salary_sal float(7,2);
declare reward_salary_sal float(7,2);
declare salary_get_sal float(7,2);
declare SB_base_sal float(7,2);
declare YB_base_sal float(7,2);
declare YL_C_sal float(7,2);
declare YL_I_sal float(7,2);
declare SY_C_sal float(7,2);
declare SY_I_sal float(7,2);
declare GS_C_sal float(7,2);
declare YB_C_sal float(7,2);
declare YB_I_sal float(7,2);
declare BI_C_sal float(7,2);
declare SI_C_sal float(7,2);
declare BX_check_sal float(7,2);
declare BX_XJ_sal float(7,2);
declare tex_sal float(7,2);
declare salary_sum_sal float(7,2);
declare done int default 0;
declare cur01 cursor for (select id,BJ,SJ,KG,TQJ,HSJ,CJ,GSJ,QTJ,JHSYJ,GJ,full_night_job,holiday_job,sunday_job,add_job,JT_days,reward_salary,check_salary,BX_check from check_once);
declare continue handler for sqlstate '02000' set done = 1;
start transaction;
delete from salary_once;
open cur01;
fetch cur01 into id_chk,BJ_chk,SJ_chk,KG_chk,TQJ_chk,HSJ_chk,CJ_chk,GSJ_chk,QTJ_chk,JHSYJ_chk,GJ_chk,full_night_job_chk,holiday_job_chk,sunday_job_chk,add_job_chk,JT_days_chk,reward_salary_chk,check_salary_chk,BX_check_chk;
while not done do
select base_salary,high_temp_base,special_job_base,night_job_base,leader_salary,age_salary,meal_base,env_salary,SB_base,YB_base,switch into base_salary_stf,high_temp_base_stf,special_job_base_stf,night_job_base_stf,leader_salary_stf,age_salary_stf,meal_base_stf,env_salary_stf,SB_base_stf,YB_base_stf,switch_stf from stuff where id=id_chk;
set ZG_sal = 21.75-BJ_chk-SJ_chk-KG_chk-TQJ_chk-GSJ_chk-QTJ_chk-JHSYJ_chk-GJ_chk;
set base_salary_sal = base_salary_stf;
set salary_XJ_sal = 1.5*base_salary_sal*(ZG_sal+BJ_chk*0.6)/21.75;
set check_salary_sal = check_salary_chk;
set high_temp_salary_sal = high_temp_base_stf*JT_days_chk;
set special_job_salary_sal = special_job_base_stf*JT_days_chk;
set leader_salary_sal = leader_salary_stf;
set add_job_salary_sal = 1.5*base_salary_sal*(3*holiday_job_chk+2*sunday_job_chk+1.5*add_job_chk)/21.75;
if (BJ_chk+SJ_chk+KG_chk+TQJ_chk+HSJ_chk+CJ_chk+GSJ_chk+QTJ_chk+JHSYJ_chk+GJ_chk)>=10 then
set age_salary_sal = 0;
set env_salary_sal = 0;
elseif (BJ_chk+SJ_chk+KG_chk+TQJ_chk+HSJ_chk+CJ_chk+GSJ_chk+QTJ_chk+JHSYJ_chk+GJ_chk)>=5 then
set age_salary_sal = age_salary_stf*0.5;
set env_salary_sal = env_salary_stf*0.5;
else
set age_salary_sal = age_salary_stf;
set env_salary_sal = env_salary_stf;
end if;
set night_job_salary_sal = night_job_base_stf*JT_days_chk;
set meal_salary_sal = meal_base_stf*JT_days_chk;
set reward_salary_sal = reward_salary_chk;
set salary_get_sal = salary_XJ_sal+check_salary_sal+high_temp_salary_sal+special_job_salary_sal+leader_salary_sal+add_job_salary_sal+age_salary_sal+night_job_salary_sal+meal_salary_sal+reward_salary_sal;
set SB_base_sal = SB_base_stf;
set YB_base_sal = YB_base_stf;
set YL_C_sal = SB_base_sal*0.2;
set YL_I_sal = SB_base_sal*0.08;
set SY_C_sal = SB_base_sal*0.01;
set SY_I_sal = SB_base_sal*0.005;
set GS_C_sal = SB_base_sal*0.015;
set YB_C_sal = YB_base_sal*0.07;
set YB_I_sal = YB_base_sal*0.02;
set BI_C_sal = YB_base_sal*0.005;
set SI_C_sal = 11;
set BX_check_sal = BX_check_chk;
set BX_XJ_sal = YL_I_sal+SY_I_sal+YB_I_sal;
if (salary_get_sal-BX_XJ_sal)<=3500 then
set tex_sal = 0;
elseif (salary_get_sal-BX_XJ_sal)<=5000 then
set tex_sal = (salary_get_sal-BX_XJ_sal-3500)*0.03;
elseif (salary_get_sal-BX_XJ_sal)<=8000 then
set tex_sal = (salary_get_sal-BX_XJ_sal-5000)*0.1+105+45;
else
set tex_sal = (salary_get_sal-BX_XJ_sal-8000)*0.2+555+450+45;
end if;
set salary_sum_sal = salary_get_sal-BX_XJ_sal-tex_sal;
insert into salary_once(id,ZG,base_salary,salary_XJ,check_salary,high_temp_salary,special_job_salary,leader_salary,add_job_salary,age_salary,night_job_salary,meal_salary,env_salary,reward_salary,salary_get,SB_base,YB_base,YL_C,YL_I,SY_C,SY_I,GS_C,YB_C,YB_I,BI_C,SI_C,BX_check,BX_XJ,tex,salary_sum) values (id_chk,ZG_sal,base_salary_sal,salary_XJ_sal,check_salary_sal,high_temp_salary_sal,special_job_salary_sal,leader_salary_sal,add_job_salary_sal,age_salary_sal,night_job_salary_sal,meal_salary_sal,env_salary_sal,reward_salary_sal,salary_get_sal,SB_base_sal,YB_base_sal,YL_C_sal,YL_I_sal,SY_C_sal,SY_I_sal,GS_C_sal,YB_C_sal,YB_I_sal,BI_C_sal,SI_C_sal,BX_check_sal,BX_XJ_sal,tex_sal,salary_sum_sal);
fetch cur01 into id_chk,BJ_chk,SJ_chk,KG_chk,TQJ_chk,HSJ_chk,CJ_chk,GSJ_chk,QTJ_chk,JHSYJ_chk,GJ_chk,full_night_job_chk,holiday_job_chk,sunday_job_chk,add_job_chk,JT_days_chk,reward_salary_chk,check_salary_chk,BX_check_chk;
end while;
close cur01;
commit;
end//



	-- select count(*) into stf_sum_cal from salary_all where id in (select id from stuff where department=department_input) and date=date_input;
	-- select sum(salary_sum) into sum_salary_cal from salary_all where id in (select id from stuff where department=department_input) and date=date_input;
	-- select sum(BX_XJ) into BX_XJ_cal from salary_all where id in (select id from stuff where department=department_input) and date=date_input;
	-- select sum(YL_C) into YL_C_cal from salary_all where id in (select id from stuff where department=department_input) and date=date_input;
	-- select sum(YL_I) into YL_I_cal from salary_all where id in (select id from stuff where department=department_input) and date=date_input;
	-- select sum(SY_C) into sum_salary_cal from salary_all where id in (select id from stuff where department=department_input) and date=date_input;

create procedure baobiao_cal(sum_count_input float(11,2),ticket_input float(11,2),pro_tool_input float(11,2),other_input float(11,2),QYSDS_input float(11,2),department_input varchar(20),date_input datetime)
begin
declare stf_num_cal int;
declare sum_salary_cal float(11,2);
declare BX_XJ_cal float(11,2);
declare YL_C_cal float(11,2);
declare YL_I_cal float(11,2);
declare YL_cal float(11,2);
declare SY_C_cal float(11,2);
declare SY_I_cal float(11,2);
declare SY_cal float(11,2);
declare GS_C_cal float(11,2);
declare YB_C_cal float(11,2);
declare YB_I_cal float(11,2);
declare YB_cal float(11,2);
declare BI_C_cal float(11,2);
declare SI_C_cal float(11,2);
declare SH_XJ_cal float(11,2);
declare ZZS_cal float(11,2);
declare CJS_cal float(11,2);
declare JYS_cal float(11,2);
declare FJS_cal float(11,2);
declare output_sum_cal float(11,2);
declare last_cal float(11,2);
create temporary table salary_cal_tmp select * from salary_all where id in (select id from stuff where department=department_input) and date=date_input;
select count(*) into stf_num_cal from salary_cal_tmp;
select sum(salary_sum) into sum_salary_cal from salary_cal_tmp;
select sum(YL_C) into YL_C_cal from salary_cal_tmp;
select sum(YL_I) into YL_I_cal from salary_cal_tmp;
select sum(SY_C) into SY_C_cal from salary_cal_tmp;
select sum(SY_I) into SY_I_cal from salary_cal_tmp;
select sum(GS_C) into GS_C_cal from salary_cal_tmp;
select sum(YB_C) into YB_C_cal from salary_cal_tmp;
select sum(YB_I) into YB_I_cal from salary_cal_tmp;
select sum(BI_C) into BI_C_cal from salary_cal_tmp;
select sum(SI_C) into SI_C_cal from salary_cal_tmp;
set BX_XJ_cal = YL_C_cal+YL_I_cal+SY_C_cal+SY_I_cal+GS_C_cal+YB_C_cal+YB_I_cal+BI_C_cal+SI_C_cal;
set YL_cal = YL_C_cal+YL_I_cal;
set SY_cal = SY_C_cal+SY_I_cal;
set YB_cal = YB_C_cal+YB_I_cal+SI_C_cal;
set ZZS_cal = sum_count_input*0.06/1.06;
set CJS_cal = ZZS_cal*7;
set JYS_cal = ZZS_cal*3;
set FJS_cal = ZZS_cal*2;
set SH_XJ_cal = ZZS_cal+CJS_cal+JYS_cal+FJS_cal+QYSDS_input;
set output_sum_cal = sum_salary_cal+BX_XJ_cal+SH_XJ_cal+ticket_input+pro_tool_input+other_input;
set last_cal = sum_count_input-output_sum_cal;
drop table salary_cal_tmp;
delete from baobiao_once where department=department_input and date=date_input;
insert into baobiao_once values(department_input,date_input,stf_num_cal,sum_count_input,sum_salary_cal,BX_XJ_cal,YL_cal,SY_cal,GS_C_cal,YB_cal,BI_C_cal,SH_XJ_cal,ZZS_cal,CJS_cal,JYS_cal,FJS_cal,QYSDS_input,ticket_input,pro_tool_input,other_input,output_sum_cal,last_cal);
end//