USE BankManagement;
GO

ALTER PROCEDURE dbo.sp_TransferMoney
   @FromAccountID INT,
   @ToAccountID INT,
   @Amount DECIMAL (18,2),
   @Description VARCHAR (255) = NULL
AS
BEGIN
   SET NOCOUNT ON;
   IF @Amount <= 0
      THROW 53000,'Amount must be greater than zero.',1;

   DECLARE @BalanceFrom DECIMAL (18,2), @ExistsTo INT;
   SELECT @BalanceFrom = Balance FROM dbo.Accounts WHERE AccountID = @FromAccountID;
   SELECT @ExistsTo = COUNT(*) FROM dbo.Accounts WHERE AccountID = @ToAccountID;
   
   IF @BalanceFrom IS NULL
      THROW 53001, 'Source account not found!',1;
   IF @ExistsTo = 0
      THROW 53002, 'Destination account not found!',1;

   -- 🔹 Mark as procedure update
   EXEC sys.sp_set_session_context @key = 'ByProcedure', @value = 1;

   BEGIN TRY
     SET XACT_ABORT ON;
     BEGIN TRAN;

     -- DEBIT FROM SOURCE
     UPDATE dbo.Accounts
     SET Balance = Balance - @Amount
     WHERE AccountID = @FromAccountID;

     -- CREDIT TO DESTINATION
     UPDATE dbo.Accounts
     SET Balance = Balance + @Amount
     WHERE AccountID = @ToAccountID;

     -- LOG TRANSACTIONS (ONE DEBIT , ONE CREDIT)
     INSERT INTO dbo.Transactions (AccountID, Amount, TransactionType, Description)
     VALUES (@FromAccountID, @Amount, 'Transfer Out', 
        ISNULL(@Description, CONCAT('Transfer to ', @ToAccountID)));

     INSERT INTO dbo.Transactions (AccountID, Amount, TransactionType, Description)
     VALUES (@ToAccountID, @Amount, 'Transfer In',
        ISNULL(@Description, CONCAT('Transfer From ', @FromAccountID)));

     COMMIT TRAN;
   END TRY
   BEGIN CATCH
     IF XACT_STATE() <> 0
        ROLLBACK TRAN;
     THROW;
   END CATCH;

   -- 🔹 Clear flag
   EXEC sys.sp_set_session_context @key = 'ByProcedure', @value = NULL;
END;
GO


ALTER PROCEDURE dbo.sp_OpenAccount
   @CustomerID INT,
   @AccountTypeID INT,
   @BranchID INT,
   @InitialDeposit DECIMAL (18,2) = 0
AS
BEGIN
   SET NOCOUNT ON;

   IF @InitialDeposit < 0
      THROW 54000, 'Initial Balance can not be negative.',1;

   IF NOT EXISTS (SELECT 1 FROM Customers WHERE CustomerID = @CustomerID)
      THROW 54001, 'Customer does not exist!', 1;
      
   -- 🔹 Mark as procedure update
   EXEC sys.sp_set_session_context @key = 'ByProcedure', @value = 1;

   BEGIN TRY
      SET XACT_ABORT ON;
      BEGIN TRAN;

      INSERT INTO dbo.Accounts(CustomerID, AccountTypeID, BranchID, Balance)
      VALUES (@CustomerID,@AccountTypeID, @BranchID, @InitialDeposit);

      DECLARE @NewAccountID INT = SCOPE_IDENTITY();

      IF @InitialDeposit > 0
      BEGIN
         INSERT INTO dbo.Transactions (AccountID, Amount, TransactionType, Description)
         VALUES(@NewAccountID, @InitialDeposit, 'Deposit', 'Initial deposit on account opening');
      END

      COMMIT TRAN;

      -- Return Created account ID
      SELECT @NewAccountID AS NewAccountID;
   END TRY
   BEGIN CATCH
      IF XACT_STATE()<>0
         ROLLBACK TRAN;
      THROW;
   END CATCH;

   -- 🔹 Clear flag
   EXEC sys.sp_set_session_context @key = 'ByProcedure', @value = NULL;
END;
GO
