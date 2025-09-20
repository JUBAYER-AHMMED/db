USE BankManagement;
GO

--TRIGGER
--An account should never have a negative balance.

CREATE TRIGGER trg_PreventNegativeBalance
ON dbo.Accounts
AFTER UPDATE
AS 
BEGIN 
   SET NOCOUNT ON;
   --Check if any updated row goes negative
   IF EXISTS (
      SELECT 1
      FROM inserted i
      WHERE i.Balance < 0
   )
   BEGIN
      ROLLBACK TRANSACTION;
      THROW 55000, 'Account balance cannot go below zero!',1;
   END
END;
GO


--TESTING
SELECT AccountID, Balance FROM Accounts WHERE AccountID = 1000;

--TRY FORCING IT BELOW ZERO:
UPDATE Accounts SET Balance = -500 WHERE AccountID = 1000;


--Auto-Log Manual Balance Updates
CREATE TRIGGER trg_LogManualBalanceChange
ON dbo.Accounts
AFTER UPDATE
AS
BEGIN
   SET NOCOUNT ON;
   --Insert logs only for balance changes
   INSERT INTO dbo.Transactions (AccountID,Amount,TransactionType,Description)
   SELECT
      i.AccountID,
      i.Balance - d.Balance,   --Difference
      CASE 
         WHEN i.Balance > d.Balance THEN 'Manual Deposit'
         ELSE 'Manual Withdrawal'
      END,
      'Balance Updated Directly (Outside stored procedures)'
   FROM inserted i
   JOIN deleted d ON i.AccountID = d.AccountID
   WHERE i.Balance <> d.Balance;  --Only if balance actually changed
END;
GO

--check:
--check current balance
SELECT AccountID, Balance FROM dbo.Accounts WHERE AccountID = 1000;

--direct update:
UPDATE dbo.Accounts SET Balance = Balance + 300 WHERE AccountID = 1000;

--check transaction logs:
SELECT TOP 5 * FROM dbo.Transactions WHERE AccountID = 1000 ORDER BY TransactionID DESC;
