USE BankManagement;
GO

--functions to calculate total deposits for an account
CREATE OR ALTER FUNCTION dbo.fn_TotalDeposits
(
    @AccountID INT
)
RETURNS DECIMAL(18,2)
AS
BEGIN
    DECLARE @Total DECIMAL(18,2);

    SELECT @Total = ISNULL(SUM(Amount), 0)
    FROM dbo.Transactions
    WHERE AccountID = @AccountID AND TransactionType IN ('Deposit','Transfer In','Manual Deposit');

    RETURN @Total;
END;
GO

--usage:
SELECT dbo.fn_TotalDeposits(1000) AS TotalDeposited;

--function to calculate total withdrawals for an account:
CREATE OR ALTER FUNCTION dbo.fn_TotalWithdrawals
(
    @AccountID INT
)
RETURNS DECIMAL(18,2)
AS
BEGIN
    DECLARE @Total DECIMAL(18,2);

    SELECT @Total = ISNULL(SUM(Amount), 0)
    FROM dbo.Transactions
    WHERE AccountID = @AccountID AND TransactionType IN ('Withdrawal','Transfer Out','Manual Withdrawal');

    RETURN @Total;
END;
GO
--usage:
SELECT dbo.fn_TotalWithdrawals(1000) AS TotalWithdrawn;


--function to calculate remaining loan:
CREATE OR ALTER FUNCTION dbo.fn_LoanRemaining
(
    @LoanID INT
)
RETURNS DECIMAL(18,2)
AS
BEGIN
    DECLARE @Remaining DECIMAL(18,2);

    SELECT @Remaining = L.LoanAmount - ISNULL(SUM(P.AmountPaid), 0)
    FROM dbo.Loans L
    LEFT JOIN dbo.LoanPayments P ON L.LoanID = P.LoanID
    WHERE L.LoanID = @LoanID
    GROUP BY L.LoanAmount;

    RETURN @Remaining;
END;
GO

--USAGE:
SELECT dbo.fn_LoanRemaining(1) AS RemainingLoan;


--ACCOUNT BALANCE ALLERT:
ALTER TABLE dbo.Accounts
ADD LowBalanceAlert AS CASE 
                          WHEN Balance < 1000 THEN 'Yes' 
                          ELSE 'No' 
                       END;
GO

--USAGE:
SELECT AccountID, Balance, LowBalanceAlert
FROM dbo.Accounts;

