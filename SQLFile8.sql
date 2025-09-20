USE BankManagement;
GO

CREATE OR ALTER TRIGGER trg_LogManualBalanceChange
ON dbo.Accounts
AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON;

    -- 🔹 Check if the update came from a stored procedure
    DECLARE @ByProcedure BIT = CAST(SESSION_CONTEXT(N'ByProcedure') AS BIT);

    -- Skip logging if update comes from procedure
    IF @ByProcedure = 1
        RETURN;

    -- Log only balance changes
    INSERT INTO dbo.Transactions (AccountID, Amount, TransactionType, Description)
    SELECT 
        i.AccountID,
        i.Balance - d.Balance,  -- Amount changed
        CASE 
            WHEN i.Balance > d.Balance THEN 'Manual Deposit'
            ELSE 'Manual Withdrawal'
        END,
        'Balance updated directly (outside stored procedures)'
    FROM inserted i
    JOIN deleted d ON i.AccountID = d.AccountID
    WHERE i.Balance <> d.Balance;  -- Only log if balance changed
END;
GO


--check
EXEC dbo.sp_DepositMoney @AccountID = 1000, @Amount = 500;

UPDATE dbo.Accounts SET Balance = Balance + 200 WHERE AccountID = 1000;

SELECT TOP 10 * FROM dbo.Transactions WHERE AccountID = 1000 ORDER BY TransactionID DESC;
