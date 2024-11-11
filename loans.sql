CREATE TABLE loans (
    id BIGINT PRIMARY KEY,
    address_state VARCHAR(2),
    application_type VARCHAR(50),
    emp_length VARCHAR(20),
    emp_title VARCHAR(100),
    grade CHAR(1),
    home_ownership VARCHAR(20),
    issue_date DATE,
    last_credit_pull_date DATE,
    last_payment_date DATE,
    loan_status VARCHAR(50),
    next_payment_date DATE,
    member_id BIGINT,
    purpose VARCHAR(50),
    sub_grade VARCHAR(5),
    term VARCHAR(20),
    verification_status VARCHAR(50),
    annual_income NUMERIC(12, 2),
    dti NUMERIC(5, 4),
    installment NUMERIC(10, 2),
    int_rate NUMERIC(5, 4),
    loan_amount NUMERIC(12, 2),
    total_acc INT,
    total_payment NUMERIC(15, 2)
);

SET datestyle = 'DMY';
Copy loans (id, address_state, application_type, emp_length, emp_title, grade, home_ownership, issue_date, last_credit_pull_date, last_payment_date, loan_status, next_payment_date, member_id, purpose, sub_grade, term, verification_status, annual_income, dti, installment, int_rate, loan_amount, total_acc, total_payment)
FROM 'H:\Shivam code\End to end project\financial_loan.csv'
DELIMITER ','
CSV HEADER
ENCODING 'UTF8';


SELECT * FROM loans

-- Total application
SELECT COUNT(id) AS Total_Applications FROM loans

-- Month to Date
SELECT COUNT(id) AS MTD_Total_Applications FROM loans
WHERE EXTRACT(MONTH FROM issue_date) = 12 AND EXTRACT(YEAR FROM issue_date) = 2021;
 
-- PMTD
SELECT COUNT(id) AS PMTD_Total_Applications FROM loans
WHERE EXTRACT(MONTH FROM issue_date) = 11 AND EXTRACT(YEAR FROM issue_date) = 2021;

-- Ttoal Loan amount
SELECT SUM(loan_amount) as Total_loan_amount FROM loans

-- MTD Loan Amount
SELECT SUM(loan_amount) AS MTD_Total_Loan_Amount FROM loans
WHERE EXTRACT(MONTH FROM issue_date) = 12 AND EXTRACT(YEAR FROM issue_date) = 2021;

-- PMTD Loan Amount
SELECT SUM(loan_amount) AS PMTD_Total_Loan_Amount FROM loans
WHERE EXTRACT(MONTH FROM issue_date) = 11 AND EXTRACT(YEAR FROM issue_date) = 2021;

-- Total Amount Received
SELECT SUM(total_payment) AS Total_amount_received FROM loans

-- MTD Total Amount Received
SELECT SUM(total_payment) AS MTD_Total_Amount_Collected FROM loans
WHERE EXTRACT(MONTH FROM issue_date) = 12  AND EXTRACT(YEAR FROM issue_date) = 2021;

-- PMTD Total Amount Received
SELECT SUM(total_payment) AS PMTD_Total_Amount_Collected FROM loans
WHERE EXTRACT(MONTH FROM issue_date) = 11  AND EXTRACT(YEAR FROM issue_date) = 2021;

-- Average Interest Rate
SELECT AVG(int_rate)*100 AS Avg_Int_Rate FROM loans

-- MTD Average Interest Rate
SELECT AVG(int_rate)*100 AS DTM_Avg_Int_Rate FROM loans
WHERE EXTRACT(MONTH FROM issue_date) = 12;

-- PMTD Average Interest Rate
SELECT AVG(int_rate)*100 AS PDTM_Avg_Int_Rate FROM loans
WHERE EXTRACT(MONTH FROM issue_date) = 11;

-- Average DTI
SELECT ROUND(AVG(dti)*100,2) AS avg_dti FROM loans;

-- DTM Average DTI
SELECT ROUND(AVG(dti)*100,2) AS DTM_avg_dti FROM loans
WHERE EXTRACT (MONTH FROM issue_date) = 12;

-- PDTM Average DTI
SELECT ROUND(AVG(dti)*100,2) AS PDTM_avg_dti FROM loans
WHERE EXTRACT (MONTH FROM issue_date) = 11;

-- Good Loan Percentage
SELECT 
    (COUNT(CASE WHEN loan_status = 'Fully Paid' OR loan_status = 'Current' THEN id END) * 100)
    /
    COUNT(id) AS Good_loan_percentage 
FROM loans;


-- Good Loan Application
SELECT COUNT(id) AS Good_loan_Application 
FROM loans
WHERE loan_status = 'Fully Paid' OR loan_status = 'Current';

-- Good Loan Funded Amount
SELECT SUM(loan_amount) AS Good_Loan_Funded_amount FROM loans
WHERE loan_status = 'Fully Paid' OR loan_status = 'Current';

-- Good Loan Amount Received
SELECT SUM(total_payment) AS Good_Loan_amount_received FROM loans
WHERE loan_status = 'Fully Paid' OR loan_status = 'Current';

-- Bad Loan Percentage
SELECT
    (COUNT(CASE WHEN loan_status = 'Charged Off' THEN id END) * 100.0) / 
	COUNT(id) AS Bad_Loan_Percentage
FROM loans;

-- Bad Loan Applications
SELECT COUNT(id) AS bad_Loan_Applications FROM loans
WHERE loan_status = 'Charged Off';

--Bad Loan Funded Amount
SELECT SUM(loan_amount) AS Bad_Loan_Funded_amount FROM loans
WHERE loan_status = 'Charged Off';

-- Bad Loan Amount Received
SELECT SUM(total_payment) AS Bad_Loan_amount_received FROM loans
WHERE loan_status = 'Charged Off';


-- Loan Status
SELECT
        loan_status,
        COUNT(id) AS Total_loan_application,
        SUM(total_payment) AS Total_Amount_Received,
        SUM(loan_amount) AS Total_Funded_Amount,
        AVG(int_rate * 100) AS Interest_Rate,
        AVG(dti * 100) AS DTI
 FROM
        loans
 GROUP BY
        loan_status;
	
-- Loan Status MTD
SELECT 
	loan_status, 
	SUM(total_payment) AS MTD_Total_Amount_Received, 
	SUM(loan_amount) AS MTD_Total_Funded_Amount 
FROM loans
WHERE EXTRACT (MONTH FROM issue_date) = 12 
GROUP BY loan_status;

-- Bank Loan Report
SELECT 
    EXTRACT(MONTH FROM issue_date) AS Month_Number, 
    TO_CHAR(issue_date, 'Month') AS Month_Name, 
    COUNT(id) AS Total_Loan_Applications,
    SUM(loan_amount) AS Total_Funded_Amount,
    SUM(total_payment) AS Total_Amount_Received
FROM loans
GROUP BY EXTRACT(MONTH FROM issue_date), TO_CHAR(issue_date, 'Month')
ORDER BY Month_Number;

-- State
SELECT 
	address_state AS State, 
	COUNT(id) AS Total_Loan_Applications,
	SUM(loan_amount) AS Total_Funded_Amount,
	SUM(total_payment) AS Total_Amount_Received
FROM loans
GROUP BY address_state
ORDER BY address_state;


-- Term
SELECT 
	term AS Term, 
	COUNT(id) AS Total_Loan_Applications,
	SUM(loan_amount) AS Total_Funded_Amount,
	SUM(total_payment) AS Total_Amount_Received
FROM loans
GROUP BY term
ORDER BY term;

-- employee length
SELECT 
	emp_length AS Employee_Length, 
	COUNT(id) AS Total_Loan_Applications,
	SUM(loan_amount) AS Total_Funded_Amount,
	SUM(total_payment) AS Total_Amount_Received
FROM loans
GROUP BY emp_length
ORDER BY emp_length;

-- Purpose
SELECT 
	purpose AS PURPOSE, 
	COUNT(id) AS Total_Loan_Applications,
	SUM(loan_amount) AS Total_Funded_Amount,
	SUM(total_payment) AS Total_Amount_Received
FROM loans
GROUP BY purpose
ORDER BY purpose;

-- Home Ownership
SELECT 
	home_ownership AS Home_Ownership, 
	COUNT(id) AS Total_Loan_Applications,
	SUM(loan_amount) AS Total_Funded_Amount,
	SUM(total_payment) AS Total_Amount_Received
FROM loans
GROUP BY home_ownership
ORDER BY home_ownership;