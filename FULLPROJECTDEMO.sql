USE BankManagement;
GO

select * from Branches;
INSERT INTO dbo.Branches (BranchName,BranchAddress,City,Division)
VALUES 
('Rajshahi', '123 main p', 'Rajshahi','Rajshahi Division');

select * from AccountTypes;


select * from Customers;
INSERT INTO dbo.Customers (FullName,DateOfBirth,Gender,Address, PhoneNumber,Email)
VALUES
('Redwan Ridoy','1999-01-01','Male', 'Dhaka', '01700000000', 'redwan100@gmail.com');
GO

--02) Open Accounts
EXEC dbo.sp_OpenAccount @CustomerID = 5, @AccountTypeID = 1, @BranchID = 5, @InitialDeposit = 5000;

--03) Deposit & Withdraw:
EXEC dbo.sp_DepositMoney @AccountID = 1005, @Amount = 2000, @Description = 'Salary deposit';

EXEC dbo.sp_WithdrawMoney @AccountID = 1004, @Amount = 2000, @Description = 'Shopping';

GO

--04) Transfer Funds:
select * from Accounts;
EXEC dbo.sp_TransferMoney @FromAccountID = 1001,@ToAccountID = 1005, @Amount =1500, @Description ='Rent Transfer';
GO

--05) Take Loans:
select * from Loans;
select * from Customers;
select * from Accounts;
select * from Branches;
INSERT INTO dbo.Loans (CustomerID,BranchID,LoanAmount,InterestRate,StartDate,DurationMonths,Status)
VALUES (4,4,100000, 5 , '2025-09-11', 36, 'Pending');
GO

--06)Pay Loan:
select * from LoanPayments;
INSERT INTO dbo.LoanPayments (LoanID, AmountPaid)
VALUES (2, 20000);
GO

--07)View 
-- Customer Accounts
SELECT * FROM vw_CustomerAccounts;

-- Transactions
SELECT TOP 20 * FROM vw_AccountTransactions ORDER BY TransactionDate DESC;

-- Loan Summary
SELECT * FROM vw_LoanSummary;

-- Check Low Balance Alerts
SELECT AccountID, Balance, LowBalanceAlert FROM dbo.Accounts;