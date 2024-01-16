create database  library_data;
use library_data;

create table  tbl_book ( book_BookID Int AUTO_INCREMENT primary key   ,book_Title varchar(100) , book_PublisherName varchar(100) ,
    FOREIGN KEY (book_publisherName) REFERENCES tbl_publisher(publisher_PublisherName) ON DELETE CASCADE ON UPDATE CASCADE);


CREATE TABLE tbl_publisher (
    publisher_PublisherName VARCHAR(100) PRIMARY KEY,
    publisher_PublisherAddress VARCHAR(100),
    publisher_PublisherPhone VARCHAR(100)
);

create table tbl_book_authors ( book_authors_AuthorsID int auto_increment primary key ,book_authors_Book_ID int  , book_authors_AuthorName varchar(100) ,
 foreign key (book_authors_Book_ID) References tbl_book(book_BookID) ON DELETE CASCADE ON UPDATE CASCADE);


create table tbl_book_copies ( book_copies_CopiesID int  auto_increment primary key not null  ,book_copies_BookID int , book_copies_BranchID int  ,
book_copies_No_Of_Copies int  ,foreign key (book_copies_BookID) References tbl_book(book_BookID) ON DELETE CASCADE ON UPDATE CASCADE,
foreign key (book_copies_BranchID) References tbl_library_branch(library_branch_BranchID) ON DELETE CASCADE ON UPDATE CASCADE);

create table tbl_library_branch ( library_branch_BranchID int auto_increment primary key ,library_branch_BranchName varchar(100),library_branch_BranchAddress varchar(100));

create table tbl_book_loans ( book_loans_Loans_ID  int auto_increment primary key ,book_loans_BookID int  , book_loans_BranchID int,
book_loans_CardNo int  , book_loans_DateOut date, book_loans_DueDate date , foreign key (book_loans_BookID) references tbl_book(book_BookID) on delete cascade 
on update cascade,foreign key (book_loans_BranchID) references tbl_library_branch(library_branch_BranchID) on delete cascade 
on update cascade,foreign key (book_loans_CardNo) references tbl_borrower(borrower_CardNo) on delete cascade 
on update cascade);
select * from tbl_book;

-- Creating the tbl_book_loans table
CREATE TABLE tbl_book_loans (
    book_loans_Loans_ID INT PRIMARY KEY,
    book_loans_BookID INT,
    book_loans_BranchID INT,
    book_loans_CardNo INT,
    book_loans_DateOut DATE,
    book_loans_DueDate DATE,tbl_book_authors
    
    FOREIGN KEY (book_loans_BookID) REFERENCES tbl_book(book_BookID) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (book_loans_BranchID) REFERENCES tbl_library_branch(library_branch_BranchID) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (book_loans_CardNo) REFERENCES tbl_borrower(borrower_CardNo) ON DELETE CASCADE ON UPDATE CASCADE
);


create table tbl_borrower ( borrower_CardNo int primary key ,borrower_BorrowerName varchar(100),borrower_BorrowerAddress varchar(100),
borrower_BorrowerPhone varchar(100));

select * from tbl_book_authors;

#1Q) How many copies of the book titled "The lost Tribe " are owned by the library branch whose name is "Sharpstown"?
select b.book_title,l.library_branch_BranchName ,c.book_copies_No_Of_copies from  tbl_book as b inner join tbl_book_copies  as c 
on b.book_BookID = c.book_copies_bookID inner join tbl_library_branch as l on c.book_copies_branchID = l.library_branch_BranchID 
where b.book_Title ='The lost Tribe' and l.library_branch_BranchName ='sharpstown';

#2Q) How many copies of the book titled "The Lost Tribe" are owned by each library branch?
select * from tbl_library_branch;
select b.book_title,l.library_branch_BranchName ,c.book_copies_No_Of_copies from  tbl_book as b inner join tbl_book_copies  as c 
on b.book_BookID = c.book_copies_bookID inner join tbl_library_branch as l on c.book_copies_branchID = l.library_branch_BranchID 
where b.book_Title ='The lost Tribe' ;

#3Q) Retrieve the names of all borrowers who do not have any books checked out?

select * from tbl_borrower;
select  b.borrower_BorrowerName  b from tbl_borrower b where b.borrower_cardNo not in(select l.book_loans_cardNo from tbl_book_loans l);


#4Q) For each book that is loaned out from the "Sharpstown" branch and whose DueDate is 2/3/18, 
-- retrieve the book title, the borrower's name, and the borrower's address?
select * from  tbl_book_loans;
select lb.library_branch_BranchName ,b.book_title,br.borrower_BorrowerName,br.borrower_Borroweraddress,
l.book_loans_duedate from tbl_borrower 
as br inner join tbl_book_loans as l on br.borrower_cardno = l.book_loans_cardno 
inner join tbl_book as b on l.book_loans_bookid = b.book_BookID
inner join tbl_library_branch as lb on l.book_loans_branchid = lb.library_branch_branchid
where  lb.library_branch_branchname = 'Sharpstown' and l.book_loans_duedate = '2/3/18';

#5Q)For each library branch, retrieve the branch name and the total number of books loaned out from that branch.?
select * from tbl_library_branch;
select * from tbl_book_loans;
select  lb.library_branch_branchname,sum(book_loans_bookid) as tbls from tbl_book_loans as l 
inner join tbl_library_branch as lb on l.book_loans_branchid = lb.library_branch_branchid  
group by library_branch_BranchName;


#6Q) Retrieve the names, addresses, and number of books checked out for all borrowers who have more than five books checked out?
select br.borrower_Borrowername,br.borrower_Borroweraddress,count(l.book_loans_bookid) as comfive from tbl_borrower as br inner join tbl_book_loans
 as l on br.borrower_cardno = l.book_loans_cardno
 inner join tbl_book as b on l.book_loans_bookid = b. book_BookID  group by 
 br.borrower_Borrowername,br.borrower_Borroweraddress having comfive > 5;
 
 #7Q) For each book authored by "Stephen King", retrieve the title and the number 
 -- of copies owned by the library branch whose name is "Central".?
select  a.book_authors_authorname, b.book_title,c.book_copies_no_of_copies,lb.library_branch_branchname from
 tbl_book_authors as a inner join tbl_book as b on a.book_authors_book_id = b.book_BookID
 inner join tbl_book_copies as c on b.book_bookid = c.book_copies_bookid 
 inner join tbl_library_branch as lb on c.book_copies_branchid = lb.library_branch_branchid where a.book_authors_authorname ="Stephen King" and 
 lb.library_branch_branchname ="Central";
 
 
 
 