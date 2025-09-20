USE BankManagement;
GO

CREATE OR ALTER TRIGGER trg_AutoCloseLoan
ON dbo.LoanPayments
AFTER INSERT
AS
BEGIN
    SET NOCOUNT ON;

    -- Update loan status to 'Closed' if fully paid
    UPDATE L
    SET L.Status = 'Closed'
    FROM dbo.Loans L
    INNER JOIN (
        SELECT LoanID, SUM(AmountPaid) AS TotalPaid
        FROM dbo.LoanPayments
        GROUP BY LoanID
    ) P ON L.LoanID = P.LoanID
    INNER JOIN inserted I ON L.LoanID = I.LoanID  -- only for newly inserted payments
    WHERE L.Status <> 'Closed' AND P.TotalPaid >= L.LoanAmount;
END;
GO
--testing:
SELECT * FROM dbo.Loans WHERE LoanID = 1;
SELECT * FROM dbo.LoanPayments WHERE LoanID = 1;

INSERT INTO dbo.LoanPayments (LoanID, AmountPaid)
VALUES (1, 40000);  -- adjust amount to fully pay the loan

SELECT LoanID, Status FROM dbo.Loans WHERE LoanID = 1;
