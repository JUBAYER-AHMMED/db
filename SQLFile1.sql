CREATE DATABASE BankManagement;
GO

USE BankManagement;
GO

--Creating Branch
CREATE TABLE Branches (
   BranchID INT PRIMARY KEY IDENTITY(1,1),
   BranchName VARCHAR(100) NOT NULL,
   BranchAddress VARCHAR(255),
   City VARCHAR(50),
   Division VARCHAR(50)
);

--Creating Employees Table:
CREATE TABLE Employees (
   EmployeeID INT PRIMARY KEY IDENTITY(1,1),
   FullName VARCHAR(100),
   Position VARCHAR(50),
   BranchID INT,
   HireDate Date,
   FOREIGN KEY (BranchID) REFERENCES Branches(BranchID)
);

--Creating Customers Table:

CREATE TABLE Customers (
   CustomerID INT PRIMARY KEY IDENTITY(1,1),
   FullName VARCHAR(100),
   DateOfBirth DATE,
   Gender VARCHAR(10),
   Address VARCHAR (255),
   PhoneNumber VARCHAR(15),
   Email VARCHAR(100)
);

--CREATING AccountTypes TABLE:
CREATE TABLE AccountTypes (
    AccountTypeID INT PRIMARY KEY IDENTITY(1,1),
    TypeName VARCHAR(50),
    Description VARCHAR(255)
);

--Creating Accounts Table:
CREATE TABLE Accounts (
    AccountID INT PRIMARY KEY IDENTITY(1000,1),
    CustomerID INT,
    AccountTypeID INT,
    BranchID INT,
    Balance DECIMAL(18,2) DEFAULT 0,
    OpenDate DATE DEFAULT GETDATE(),
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID),
    FOREIGN KEY (AccountTypeID) REFERENCES AccountTypes(AccountTypeID),
    FOREIGN KEY (BranchID) REFERENCES Branches(BranchID)
);

--Creating Transactions Table:
CREATE TABLE Transactions (
    TransactionID INT PRIMARY KEY IDENTITY(1,1),
    AccountID INT,
    TransactionDate DATETIME DEFAULT GETDATE(),
    Amount DECIMAL(18,2),
    TransactionType VARCHAR(50),  -- 'Deposit' or 'Withdrawal'
    Description VARCHAR(255),
    FOREIGN KEY (AccountID) REFERENCES Accounts(AccountID)
);
--Creating Loan Table:
CREATE TABLE Loans (
    LoanID INT PRIMARY KEY IDENTITY(1,1),
    CustomerID INT,
    BranchID INT,
    LoanAmount DECIMAL(18,2),
    InterestRate DECIMAL(5,2),
    StartDate DATE,
    DurationMonths INT,
    Status VARCHAR(50), -- e.g. 'Approved', 'Pending', 'Closed'
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID),
    FOREIGN KEY (BranchID) REFERENCES Branches(BranchID)
);

--Creating LoanPayments Table:
CREATE TABLE LoanPayments (
    PaymentID INT PRIMARY KEY IDENTITY(1,1),
    LoanID INT,
    PaymentDate DATE DEFAULT GETDATE(),
    AmountPaid DECIMAL(18,2),
    FOREIGN KEY (LoanID) REFERENCES Loans(LoanID)
);



-- Branches
INSERT INTO Branches (BranchName, BranchAddress, City, Division)
VALUES 
 ('Main Branch', '123 Dhaka Road', 'Dhaka', 'Dhaka Division'),
 ('Chittagong Branch', '456 Port Road', 'Chittagong', 'Chittagong Division'),
 ('Sylhet Branch', '789 Tea Ave', 'Sylhet', 'Sylhet Division'),
 ('Bogura Branch', 'Satmatha', 'Bogura', 'Rajshahi Division');
GO

-- Account types
INSERT INTO AccountTypes (TypeName, Description)
VALUES
 ('Savings', 'Basic savings account'),
 ('Current', 'Business/current account'),
 ('Fixed Deposit', 'Fixed term deposit');
GO

-- Employees
INSERT INTO Employees (FullName, Position, BranchID, HireDate)
VALUES
 ('Md. Rahim', 'Manager', 1, '2020-01-10'),
 ('Md. Mursalin', 'Teller', 1, '2021-03-05'),
 ('Abrar Khan', 'Loan Officer', 2, '2019-07-22'),
 ('Sadik Rahman', 'Teller', 3, '2022-02-14');
GO

-- Customers
INSERT INTO Customers (FullName, DateOfBirth, Gender, Address, PhoneNumber, Email)
VALUES
 ('Jubayer Ahmmed', '2000-05-15', 'Male', 'Dhaka, Bangladesh', '01711111111', 'jubayer@example.com'),
 ('Sara Rahman', '1998-08-22', 'Female', 'Chittagong, Bangladesh', '01822222222', 'sara@example.com'),
 ('Ratul Ahmed', '1995-03-10', 'Male', 'Dhaka, Bangladesh', '01633333333', 'ratul@example.com'),
 ('Nadia Khan', '1987-11-20', 'Female', 'Sylhet, Bangladesh', '01944444444', 'nadia@example.com');
GO

INSERT INTO Accounts (CustomerID, AccountTypeID, BranchID, Balance)
VALUES
 (1, 1, 1, 5000.00),   -- AccountID 1000
 (2, 2, 2, 15000.00),  -- AccountID 1001
 (3, 1, 1, 0.00),      -- AccountID 1002
 (4, 3, 3, 200000.00); -- AccountID 1003
GO


--later insert a customer into Bogura branch and add accounts there then.
-- Transactions (we reference AccountIDs 1000..1003 which are first identities)
INSERT INTO Transactions (AccountID, TransactionDate, Amount, TransactionType, Description)
VALUES
 (1000, GETDATE()-10, 5000.00, 'Deposit', 'Initial deposit'),
 (1000, GETDATE()-5, 200.00, 'Withdrawal', 'ATM withdrawal'),
 (1001, GETDATE()-3, 10000.00, 'Deposit', 'Salary deposit'),
 (1003, GETDATE()-30, 200000.00, 'Deposit', 'Fixed deposit placement');
GO


--Loan for Customer 3
INSERT INTO Loans (CustomerID, BranchID, LoanAmount, InterestRate, StartDate, DurationMonths, Status)
VALUES
 (3, 1, 50000.00, 9.50, '2024-01-15', 24, 'Approved');
GO


-- Loan payment (partial)
INSERT INTO LoanPayments (LoanID, PaymentDate, AmountPaid)
VALUES
 (1, GETDATE()-60, 10000.00);
GO


--lets check what have we done:
SELECT * from Branches;
select * from AccountTypes
SELECT * FROM Accounts;
SELECT * FROM Transactions;
select * from Customers;
select * from Employees;
select * from Loans;
select * from LoanPayments;

--store procedure: