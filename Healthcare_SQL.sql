CREATE DATABASE Healthcare_Data;
USE Healthcare_Data;

create table if not exists Healthcare(
FAC_NO int not null,
FAC_NAME varchar(250) not null,
YEAR_QTR int not null,
BEG_DATE date not null,
END_DATE date not null,
OP_STATUS varchar(250) not null,
COUNTY_NAME varchar(250) not null,
HSA int,
HFPA int,
TYPE_CNTRL varchar(250),
TYPE_HOSP varchar(250),
TEACH_RURL varchar(250),
PHONE varchar(250),
ADDRESS varchar(250),
CITY varchar(250),
ZIP_CODE varchar(250),
CEO varchar(250),
LIC_BEDS bigint,
AVL_BEDS bigint,
STF_BEDS bigint,
DIS_MCAR bigint,
DIS_MCAR_MC bigint,
DIS_MCAL bigint,
DIS_MCAL_MC bigint,
DIS_CNTY bigint,
DIS_CNTY_MC bigint,
DIS_THRD bigint,
DIS_THRD_MC bigint,
DIS_INDGNT bigint,
DIS_OTH bigint,
DIS_TOT bigint,
DIS_LTC bigint,
DAY_MCAR bigint,
DAY_MCAR_MC bigint,
DAY_MCAL bigint,
DAY_MCAL_MC bigint,
DAY_CNTY bigint,
DAY_CNTY_MC bigint,
DAY_THRD bigint,
DAY_THRD_MC bigint,
DAY_INDGNT bigint,
DAY_OTH bigint,
DAY_TOT bigint,
DAY_LTC bigint,
VIS_MCAR bigint,
VIS_MCAR_MC bigint,
VIS_MCAL bigint,
VIS_MCAL_MC bigint,
VIS_CNTY bigint,
VIS_CNTY_MC bigint,
VIS_THRD bigint,
VIS_THRD_MC bigint,
VIS_INDGNT bigint,
VIS_OTH bigint,
VIS_TOT bigint,
GRIP_MCAR bigint,
GRIP_MCAR_MC bigint,
GRIP_MCAL bigint,
GRIP_MCAL_MC bigint,
GRIP_CNTY bigint,
GRIP_CNTY_MC bigint,
GRIP_THRD bigint,
GRIP_THRD_MC bigint,
GRIP_INDGNT bigint,
GRIP_OTH bigint,
GRIP_TOT bigint,
GROP_MCAR bigint,
GROP_MCAR_MC bigint,
GROP_MCAL bigint,
GROP_MCAL_MC bigint,
GROP_CNTY bigint,
GROP_CNTY_MC bigint,
GROP_THRD bigint,
GROP_THRD_MC bigint,
GROP_INDGNT bigint,
GROP_OTH bigint,
GROP_TOT bigint,
BAD_DEBT bigint,
CADJ_MCAR bigint,
CADJ_MCAR_MC bigint,
CADJ_MCAL bigint,
CADJ_MCAL_MC bigint,
DISP_855 bigint,
CADJ_CNTY bigint,
CADJ_CNTY_MC bigint,
CADJ_THRD bigint,
CADJ_THRD_MC bigint,
CHAR_HB bigint,
CHAR_OTH bigint,
SUB_INDGNT bigint,
TCH_ALLOW bigint,
TCH_SUPP bigint,
DED_OTH bigint,
DED_TOT bigint,
CAP_MCAR bigint,
CAP_MCAL bigint,
CAP_CNTY bigint,
CAP_THRD bigint,
CAP_TOT bigint,
NET_MCAR bigint,
NET_MCAR_MC bigint,
NET_MCAL bigint,
NET_MCAL_MC bigint,
NET_CNTY bigint,
NET_CNTY_MC bigint,
NET_THRD bigint,
NET_THRD_MC bigint,
NET_INDGNT bigint,
NET_OTH bigint,
NET_TOT bigint,
OTH_OP_REV bigint,
TOT_OP_EXP bigint,
PHY_COMP bigint,
NONOP_REV bigint,
DIS_PIPS bigint,
DAY_PIPS bigint,
EXP_PIPS bigint,
EXP_POPS bigint,
CAP_EXP bigint,
FIX_ASSETS bigint,
DISP_TRNFR bigint,
DIS_TOT_CC bigint,
PAT_DAY_TOT_CC bigint,
TOT_OUT_VIS_CC bigint,
GROS_INPAT_REV_CC bigint,
GROS_OUTPAT_REV_CC bigint,
CONTR_ADJ_CC bigint,
OTHR_DEDUCT_CC bigint,
CAP_PREM_REV_CC bigint,
NET_PAT_REV_CC bigint,
QA_FEES bigint,
QA_SUPPL_PAY bigint,
MNGD_CARE_QA_PAY bigint
);

select * from Healthcare;
show variables like "secure_file_priv"; 
set session sql_mode='';
 
load data infile
"C:/Program Files/MySQL/Healthcare.csv"
into table Healthcare
CHARACTER SET latin1
fields terminated by ','
enclosed by '"'
lines terminated by '\n'
ignore 1 rows;
################################################################################################

# KPI-1 Total Discharge
select FAC_NAME as Hospital, SUM(DIS_TOT), SUM(DIS_LTC) FROM healthcare
GROUP BY FAC_NAME;
SELECT SUM(DIS_TOT) AS TOTAL_DISCHARGE FROM healthcare ;

# KPI-2 Patient Days
select FAC_NAME AS HOSPITALS, SUM(DAY_TOT), SUM(DAY_LTC) FROM healthcare
GROUP BY FAC_NAME;
SELECT SUM(DAY_TOT) AS Patient_Days FROM healthcare ;

# KPI-3 Net Patient Revenue 
select FAC_NAME AS HOSPITALS, SUM(NET_TOT) FROM healthcare
GROUP BY FAC_NAME;
SELECT CONCAT ("$ ", SUM(NET_TOT)) AS Net_Patient_Revenue FROM healthcare ;

# KPI-5 Patient Stays
# Average Length of Stay & Average Length of Stay (excluding LTC)  		
SELECT FAC_NAME AS HOSPITALS,
    avg(DAY_TOT) / avg(DIS_TOT) AS ALOS,
    (SUM(DAY_TOT) - SUM(DAY_LTC)) / (SUM(DIS_TOT) - SUM(DIS_LTC)) AS ALOS_XLTC
FROM Healthcare
GROUP BY FAC_NAME;	

# KPI-6 State Wise No of hospital /Revenue 
SELECT STATE_NAME, COUNT(FAC_NAME) AS HOSPITALS, CONCAT ("$ ",SUM(GRIP_TOT)) AS GRIP_TOTAL, CONCAT ("$ ",SUM(GROP_TOT)) AS GROP_TOTAL, CONCAT ("$ ",SUM(CAP_TOT)) AS CAP_TOTAL, CONCAT ("$ ",SUM(OTH_OP_REV)) AS OTH_OP_REV, CONCAT ("$ ",SUM(NONOP_REV)) AS NONOP_REV, CONCAT ("$ ",SUM(NET_TOT)) AS NET_REVENUE FROM healthcare
JOIN USCITIES
ON healthcare.CITY = USCITIES.CITY
GROUP BY STATE_NAME;

SELECT STATE_NAME, COUNT(FAC_NAME) AS HOSPITALS, CONCAT ("$ ",SUM(NET_TOT)) AS NET_REVENUE FROM healthcare
JOIN USCITIES
ON healthcare.CITY = USCITIES.CITY
GROUP BY STATE_NAME;

# KPI-7 Type of hospital Revenue
select FAC_NAME, CONCAT ("$ ",SUM(GRIP_TOT)) AS GRIP_TOTAL, CONCAT ("$ ",SUM(GROP_TOT)) AS GROP_TOTAL, CONCAT ("$ ",SUM(CAP_TOT)) AS CAP_TOTAL, CONCAT ("$ ",SUM(OTH_OP_REV)) AS OTH_OP_REV, CONCAT ("$ ",SUM(NONOP_REV)) AS NONOP_REV, CONCAT ("$ ",SUM(NET_TOT)) AS NET_REVENUE FROM healthcare
GROUP BY FAC_NAME;

# KPI-8 MTD/QTD/YTD Revenue
SELECT
    SUM(CASE WHEN MONTH(BEG_DATE) = MONTH(END_DATE) THEN NET_TOT ELSE 0 END) AS MTD_Revenue,
    SUM(CASE WHEN QUARTER(BEG_DATE) = QUARTER(END_DATE) THEN NET_TOT ELSE 0 END) AS QTD_Revenue,
    SUM(CASE WHEN YEAR(BEG_DATE) = YEAR(END_DATE) THEN NET_TOT ELSE 0 END) AS YTD_Revenue
FROM
    healthcare;
    
# KPI-9 Total Hospital
SELECT DISTINCT COUNT(FAC_NO) AS HOSPITALS FROM Healthcare;

# KPI-10 Revenue Trend
SELECT
    BEG_DATE,
    NET_TOT,
    LAG(NET_TOT) OVER (ORDER BY BEG_DATE) AS previous_revenue,
    NET_TOT - LAG(NET_TOT) OVER (ORDER BY BEG_DATE) AS revenue_change
FROM
    healthcare
ORDER BY
    BEG_DATE;

SELECT YEAR(BEG_DATE) AS revenue_year, SUM(NET_TOT) AS total_revenue
FROM healthcare
GROUP BY revenue_year
ORDER BY revenue_year;

# Patients Trends
SELECT YEAR(BEG_DATE) AS YEAR, FAC_NAME AS HOSPITALS, SUM(DAY_TOT) AS TOTAL_DAYS
FROM healthcare
GROUP BY HOSPITALS
ORDER BY YEAR(BEG_DATE);


