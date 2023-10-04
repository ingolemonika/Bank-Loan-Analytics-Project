create table finance_1 (
id int,
member_id int,
loan_amnt int,
funded_amnt int,
funded_amnt_inv double,
term varchar(100),
int_rate varchar(100),
installment double,
grade varchar(10),
sub_grade varchar(10),
emp_title varchar(100),
emp_length varchar(20),
home_ownership varchar(20),
annual_inc int,
verification_status varchar(30),
issue_d date,
loan_status varchar(20),
pymnt_plan varchar(10),
descr varchar(300),
purpose varchar(30),
title varchar(30),
zip_code varchar(10),
addr_state varchar(10),
dti double
);
Set sql_mode = "";

LOAD DATA INFILE 'C:/ProgramData/MySQL/Finance_1.csv' 
INTO TABLE finance_1 
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

create table finance_2 (
id int,
delinq_2yrs int,
earliest_cr_line date,
inq_last_6mths int,
mths_since_last_delinq int,
mths_since_last_record int,
open_acc int,
pub_rec double,
revol_bal int,
revol_util varchar(10),
total_acc int,
initial_list_status varchar(10),
out_prncp double,
out_prncp_inv double,
total_pymnt double,
total_pymnt_inv double,
total_rec_prncp double,
total_rec_int double,
total_rec_late_fee double,
recoveries double,
collection_recovery_fee double,
last_pymnt_d date,
last_pymnt_amnt double,
next_pymnt_d date,
last_credit_pull_d date
);
Set sql_mode = "";

LOAD DATA INFILE 'C:/ProgramData/MySQL/Finance_2.csv' 
INTO TABLE finance_2 
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

#1Q Year wise loan amount status
select year(issue_d),sum(loan_amnt),
loan_status from finance_1
group by year(issue_d),loan_status
order by year(issue_d);

#2Q Grade and Sub grade wise revol_bal 
select finance_1.grade ,finance_1.sub_grade,sum(finance_2.revol_bal)
from finance_1 inner join finance_2 using (id)
group by grade,sub_grade
order by grade,sub_grade;

#3Q Total Payment for Verified status vs Total Payment for Verified status   
select finance_1.verification_status ,sum(finance_2.total_pymnt)
from finance_1 inner join finance_2 using (id)
group by verification_status
order by verification_status;

#4Q State wise and last_credit_pull_d wise loan status
select sum(finance_2.last_credit_pull_d),finance_1.addr_state,finance_1.loan_status
from finance_1 inner join finance_2 using (id)
group by addr_state,loan_status
order by addr_state,loan_status;

#5Q Home ownership vs last payment data status
select year(finance_2.last_pymnt_d),count(finance_2.last_pymnt_amnt),finance_1.home_ownership
from finance_1 inner join finance_2 using (id)
group by year(last_pymnt_d),home_ownership
order by year(last_pymnt_d);



