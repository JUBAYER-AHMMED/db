USE BankManagement;
GO

--1) Deposit Money
CREATE PROCEDURE dbo.sp_DepositMoney
   @AccountID INT,
   @Amount Decimal(18,2),
   @Description VARCHAR(255) = 'Deposit'

AS
BEGIN
   SET NOCOUNT ON;

   IF @Amount <= 0
      THROW 51000, 'Amount must be greater than zero.',1;

    BEGIN TRY
       SET XACT_ABORT ON;
       BEGIN TRAN;
       
       UPDATE dbo.Accounts
       SET Balance = Balance + @Amount
       WHERE AccountID = @AccountID;

       IF @@ROWCOUNT = 0
           THROW 51001, 'Account not found!',1;

       INSERT INTO Transactions (AccountID, Amount, TransactionType, Description)
       VALUES (@AccountID, @Amount, 'Deposit', @Description);

       COMMIT TRAN;
    END TRY
    BEGIN CATCH
       IF XACT_STATE() <> 0
           ROLLBACK TRAN;
       THROW;
    END CATCH
END;
GO


--2) Withdraw money (prevents overdraft):
CREATE PROCEDURE dbo.sp_WithdrawMoney
   @AccountID INT,
   @Amount DECIMAL(18,2),
   @Description VARCHAR(255) = 'Withdrawal'

AS
BEGIN
   SET NOCOUNT ON;
   IF @Amount <= 0
      THROW 52000, 'Amount must be greater than zero.',1;

   DECLARE @CurrentBalance DECIMAL (18,2);
   SELECT @CurrentBalance = Balance FROM dbo.Accounts WHERE AccountID = @AccountID;
   
   IF @CurrentBalance IS NULL
      THROW 52001, 'Account not found.',1;
   IF @CurrentBalance < @Amount 
      THROW 52002, 'Insufficient Balance!',1;

   BEGIN TRY
      SET XACT_ABORT ON;
      BEGIN TRAN;

      UPDATE dbo.Accounts
      SET Balance = Balance - @Amount
      WHERE AccountID = @AccountID;

      INSERT INTO dbo.Transactions (AccountID, Amount, TransactionType,Description)
      VALUES (@AccountID, @Amount, 'Withdrawal',@Description);

      COMMIT TRAN;
   END TRY

   BEGIN CATCH
       IF XACT_STATE()<>0
          ROLLBACK TRAN;
       THROW;
   END CATCH
END;
GO






