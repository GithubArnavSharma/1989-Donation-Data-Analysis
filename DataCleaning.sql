--Rename main columns and add descriptions

sp_rename 'itcont.column1', 'CMTE_ID', 'COLUMN';
/* A 9-character alpha-numeric code assigned to a committee by the Federal Election Commission */
sp_rename 'itcont.column2', 'AMNDT_IND', 'COLUMN';
/* Indicates if the report being filed is new (N), an amendment (A) to a previous report or a 
termination (T) report. */
sp_rename 'itcont.column3', 'RPT_TP', 'COLUMN';
/* 	Indicates the type of report filed List of report type codes */
sp_rename 'itcont.column4', 'TRANSACTION_PGI', 'COLUMN';
/* This code indicates the election for which the contribution was made. EYYYY 
(election plus election year)
P = Primary
G = General
O = Other
C = Convention
R = Runoff
S = Special
E = Recount */
sp_rename 'itcont.column5', 'IMAGE_NUM', 'COLUMN';
/* 11-digit Image Number */
sp_rename 'itcont.column6', 'TRANSACTION_TP', 'COLUMN';
/* Transaction types */
sp_rename 'itcont.column7', 'ENTITY_TP', 'COLUMN';
/* CAN = Candidate
CCM = Candidate Committee
COM = Committee
IND = Individual (a person)
ORG = Organization (not a committee and not a person)
PAC = Political Action Committee
PTY = Party Organization */
sp_rename 'itcont.column8', 'Name', 'COLUMN';
sp_rename 'itcont.column9', 'CITY', 'COLUMN';
sp_rename 'itcont.column10', 'STATE', 'COLUMN';
sp_rename 'itcont.column11', 'ZIP_CODE', 'COLUMN';
sp_rename 'itcont.column12', 'EMPLOYER', 'COLUMN';
sp_rename 'itcont.column13', 'OCCUPATION', 'COLUMN';
sp_rename 'itcont.column14', 'TRANSACTION_DT', 'COLUMN';
sp_rename 'itcont.column15', 'TRANSACTION_AMT', 'COLUMN';
sp_rename 'itcont.column16', 'OTHER_ID', 'COLUMN';
/* For contributions from individuals this column is null. For contributions from candidates 
or other committees this column will contain that contributor's FEC ID. */
sp_rename 'itcont.column17', 'TRAN_ID', 'COLUMN';
/* A unique identifier associated with each itemization or transaction. */
sp_rename 'itcont.column18', 'FILE_NUM', 'COLUMN';
sp_rename 'itcont.column19', 'MEMO_CD', 'COLUMN';
/* 'X' indicates that the amount is NOT to be included in the itemization total. */
sp_rename 'itcont.column20', 'MEMO_TEXT', 'COLUMN';
/* A description of the activity. Memo Text is available on itemized amounts on Schedules A and B. 
These transactions are included in the itemization total. */
sp_rename 'itcont.column21', 'SUB_ID', 'COLUMN';


-- Filter columns to be more informative

UPDATE itcont
SET TRANSACTION_PGI = 
CASE
	WHEN TRANSACTION_PGI LIKE 'P%' THEN 'PRIMARY'
	WHEN TRANSACTION_PGI LIKE 'G%' THEN 'GENERAL'
	WHEN TRANSACTION_PGI LIKE 'O%' THEN 'OTHER'
	WHEN TRANSACTION_PGI LIKE 'C%' THEN 'CONVENTION'
	WHEN TRANSACTION_PGI LIKE 'R%' THEN 'RUNOFF'
	WHEN TRANSACTION_PGI LIKE 'S%' THEN 'SPECIAL'
	WHEN TRANSACTION_PGI LIKE 'E%' THEN 'RECOUNT'
	ELSE 'Unknown'
END;


CREATE TABLE popularOccupations (
	Occ nvarchar(MAX),
);

INSERT INTO popularOccupations (Occ)
(
	SELECT DISTINCT(OCCUPATION)
	FROM itcont
	GROUP BY OCCUPATION
	HAVING COUNT(OCCUPATION) > 200
);

UPDATE itcont
SET OCCUPATION = 
CASE
	WHEN OCCUPATION IN (SELECT * FROM popularOccupations) THEN OCCUPATION
	ELSE 'Other'
END;

UPDATE itcont
SET EMPLOYER = 
CASE
	WHEN EMPLOYER LIKE '%SELF%' THEN 'SELF EMPLOYED'
	WHEN EMPLOYER LIKE '%RETIRE%' THEN 'RETIRED'
	WHEN EMPLOYER LIKE '%NOT%' THEN 'NOT EMPLOYED'
	WHEN EMPLOYER LIKE '%N/A%' THEN 'NOT EMPLOYED'
	WHEN EMPLOYER LIKE '%NONE%' THEN 'NOT EMPLOYED'
	WHEN EMPLOYER LIKE '%ARMY%' THEN 'US ARMY'
	WHEN EMPLOYER LIKE '%HOME%' THEN 'HOMEMAKER'
	ELSE EMPLOYER
END;

UPDATE itcont
SET [STATE] = 
CASE
	WHEN [STATE] IN (SELECT DISTINCT([STATE]) FROM itcont GROUP BY [STATE] HAVING COUNT([STATE]) > 2000)
		THEN [STATE]
	ELSE 'ZZ'
END;

CREATE TABLE popularCities (
	theCity nvarchar(MAX)
);

INSERT INTO popularCities (theCity)
(
	SELECT DISTINCT(CITY)
	FROM itcont
	GROUP BY City
	HAVING COUNT(CITY) > 100
);

UPDATE itcont
SET CITY = 
CASE
	WHEN CITY IN (SELECT * FROM popularCities) THEN CITY
	ELSE 'Other'
END;
