USE BankManagement;
GO

CREATE OR ALTER VIEW vw_CustomerAccounts AS
SELECT 
    C.CustomerID,
    C.FullName AS CustomerName,
    A.AccountID,
    AT.TypeName AS AccountType,
    B.BranchName,
    A.Balance,
    A.OpenDate
FROM dbo.Customers C
JOIN dbo.Accounts A ON C.CustomerID = A.CustomerID
JOIN dbo.AccountTypes AT ON A.AccountTypeID = AT.AccountTypeID
JOIN dbo.Branches B ON A.BranchID = B.BranchID;
GO

--usage:
SELECT * FROM vw_CustomerAccounts WHERE CustomerID = 5;



--View for loan summary
CREATE OR ALTER VIEW vw_LoanSummary AS
SELECT 
    L.LoanID,
    C.FullName AS CustomerName,
    B.BranchName,
    L.LoanAmount,
    ISNULL(SUM(P.AmountPaid),0) AS TotalPaid,
    L.LoanAmount - ISNULL(SUM(P.AmountPaid),0) AS RemainingAmount,
    L.Status,
    L.StartDate,
    L.DurationMonths
FROM dbo.Loans L
JOIN dbo.Customers C ON L.CustomerID = C.CustomerID
JOIN dbo.Branches B ON L.BranchID = B.BranchID
LEFT JOIN dbo.LoanPayments P ON L.LoanID = P.LoanID
GROUP BY L.LoanID, C.FullName, B.BranchName, L.LoanAmount, L.Status, L.StartDate, L.DurationMonths;
GO

--usage:
SELECT * FROM vw_LoanSummary WHERE Status = 'Approved';
select * from dbo.Loans


--view for transaction history per account:
CREATE OR ALTER VIEW vw_AccountTransactions AS
SELECT 
    T.TransactionID,
    T.AccountID,
    C.FullName AS CustomerName,
    T.TransactionDate,
    T.Amount,
    T.TransactionType,
    T.Description
FROM dbo.Transactions T
JOIN dbo.Accounts A ON T.AccountID = A.AccountID
JOIN dbo.Customers C ON A.CustomerID = C.CustomerID;
GO


--usage:
SELECT TOP 20 * FROM vw_AccountTransactions
WHERE AccountID = 1000
ORDER BY TransactionDate DESC;
