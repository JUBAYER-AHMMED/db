USE BankManagement;
GO

--testing store procedure
-- deposit 1000 -> account 1000

EXEC dbo.sp_DepositMoney @AccountID = 1000, @Amount = 1000, @Description = 'Test deposit';

-- withdraw 200 from 1000
EXEC dbo.sp_WithdrawMoney @AccountID = 1000, @Amount = 200, @Description = 'Test withdrawal';

-- transfer 500 from 1001 to 1002
EXEC dbo.sp_TransferMoney @FromAccountID = 1001, @ToAccountID = 1002, @Amount = 500, @Description = 'Test transfer';

-- open new account for customer 1 with initial deposit 2500
EXEC dbo.sp_OpenAccount @CustomerID = 1, @AccountTypeID = 1, @BranchID = 1, @InitialDeposit = 2500;


SELECT AccountID, CustomerID, Balance
FROM Accounts
WHERE AccountID = 1001;


--check
SELECT AccountID, CustomerID, Balance FROM Accounts ORDER BY AccountID;
SELECT TOP 20 * FROM Transactions ORDER BY TransactionDate DESC, TransactionID DESC;
