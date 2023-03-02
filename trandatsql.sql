--file viết code để nộp--

--trong SQL server
--chia thanh 3 tập lớn (D=Data, L=language)
--DDL (Data Definition Language)
---->bao gồm các câu lệnh liên quan đến việc tạo xoá sửa database và table (creat tạo, drop xoá, alter sửa)
--DML
---->
--DCL
---->



--code tay thì tự refresh f5 để thấy
USE master
GO

--câu lệnh tạo database
DROP DATABASE IF EXISTS C2206L
CREATE DATABASE C2206L
GO

--câu lệnh đưa về database mặc định để tạo bảng table
--NOT NULL: ko đc phép để trống bắt buộc phải nhập
USE C2206L
GO

DROP TABLE IF EXISTS customer
CREATE TABLE customer
(
	id INT PRIMARY KEY,
	fullname NVARCHAR(50),
	gender BIT,
	dob DATETIME 
)
GO

--CASE sensitive (phân biệt chữ hoa thường)
--CASE unsensitive (ko phân biệt chữ hoa thường)

DROP TABLE IF EXISTS [order]
CREATE TABLE [order]
(
	id INT PRIMARY KEY,
	mfgdate DATETIME,
	codeCus INT
)
GO

--xét mối quan hệ để liên kết
--chúng ta phải đi từ bảng nhiều (n) sang bảng 1 (1)
--bảng nhiều là order, bảng 1 là customer

ALTER TABLE [order]	--sửa chửa lại bảng nhiều
ADD
CONSTRAINT FK_order_customer --vẽ 1 đường kết nối --FK_tên bảng nhiều_tên bảng 1
FOREIGN KEY (codeCus) --khoá ngoại của bảng nhiều
REFERENCES customer(id) --liên kết đến tên bảng 1 (khoá chính)
GO

--luật câu select
--với 1 câu select đơn, thường bao gồm 6 từ này


--lấy hết tất cả thông tin nhân viên
--hiển thị toàn bộ thông tin nhân viên
USE QLDA
GO

SELECT *
FROM NHANVIEN

--hiển thị họ tên nhân viên và lương
--gom lại thành 1 cột
SELECT HONV +' ' + TENLOT +' '+ TENNV AS FULLNAME, LUONG TOTALMONEY
FROM NHANVIEN

SELECT CONCAT(HONV,' ',TENLOT,' ',TENNV) FULLNAME, LUONG TOTALMONEY
FROM NHANVIEN

--hiển thị tên nhân viên
--loại bỏ tên bị trùng
--có từ khoá distinct là loại bỏ trùng
--sau select phải là distinct
select distinct TENNV
from NHANVIEN

--hiển thị tất cả mức lương mà nhân viên được nhận
select distinct LUONG
from NHANVIEN

--hiển thị 4 dòng đầu tiền trong bảng nhân viên
--top so dong, top phai sau select
select top 4 TENNV
from NHANVIEN


--hiển thị tên nhân viên và lương từng nhân viên
select TENNV,LUONG
from NHANVIEN
order by LUONG, TENNV desc--ascending tăng dần--desc giảm dần

--hiển thị toàn bộ thông tin nhân viên vơi mức lương phải trong khoảng 25 ngàn đến 43 ngàn
select *
from NHANVIEN
where LUONG >= 25000 and luong <= 43000
order by LUONG

--liệt kê tất cả nhân nhiên mà không có người quản lý
select HONV+' '+TENLOT+' '+TENNV fullname
from NHANVIEN
where MA_NQL is Null

--liệt kê tất cả nhân viên có tên quang
--với kiểu nvarchar hoặc nchar phải thêm N phía trước
select HONV+' '+TENLOT+' '+TENNV fullname
from NHANVIEN
where TENNV = N'quang'

select HONV+' '+TENLOT+' '+TENNV fullname
from NHANVIEN
where HONV = N'dinh'

select HONV+' '+TENLOT+' '+TENNV fullname
from NHANVIEN
where HONV collate sql_Latin1_General_CP1_CI_AI =N'dinh' collate sql_Latin1_General_CP1_CI_AI 









--index (chỉ mục,mục lục)
--mục đích là tăng tốc SQL
--câu lệnh mà chỉ có select ..from thì ko có hiện diện của index

--một bảng mà có khoá chính
--thì khoá chính đã đc mặc định đánh index rồi và index này có tên là clustered index
create clustered index ix_manv on NHANVIEN(MANV)
go
--nonclustered index đánh trên các cột thường ko phải là khoá chính và phải tự đánh
create nonclustered index ix_luong on NHANVIEN(LUONG)
create nonclustered index ix_tennv on NHANVIEN(TENNV)
go

create nonclustered index ix_tennv_luong on NHANVIEN(TENNV,LUONG)
go

create index ix_tennv on NHANVIEN(TENNV)
--có những dạng index nào trên bảng này
sp_helpindex nhanvien

drop index ix_luong on NHANVIEN

-->,<,>=,<=,= IN,IS,EXISTS, and
--NOT,!=,OR,LIKE...



--store procedure //hàm lưu trữ ==> lưu code dươi dạng hàm, lưu code trên server
select *
from NHANVIEN

--1. kiểm tra ai là người gọi
--2. kiểm tra cú pháp
--3. đí kiếm bảng dữ liệu và các cột liên quan
--4. chuyển dữ liệu về cho client

--create proc
create procedure selectAllNhanVien
as
begin
	select * from NHANVIEN
end
go

execute selectAllNhanVien
--exec selectallnhanvien

alter procedure selectAllNhanVien
@MANV CHAR(9)
as
begin
	select * from NHANVIEN
	where MANV = @MANV
end
go

selectAllNhanVien '005'


alter procedure select_manv_luong
@MANV CHAR(9),
@LUONG FLOAT
as
begin
	if @MANV is null or @LUONG is null
	begin
		select * from NHANVIEN
	end
	else
	begin
		select * from NHANVIEN
		where MANV = @MANV or LUONG > @LUONG
	end
end
go

select_manv_luong null,0


select phai from NHANVIEN
 
SELECT CASE WHEN phai = N'nữ' then 'female'
		ELSE 'male'
		END
FROM NHANVIEN



--trigger là những đoạn code tự động chạy trên sql server, khi có sự thay đổi dữ liệu (insert, update, delete)
use QUANLYBANHANG
go

create trigger xyz
on Customer
[for,after,instead of]
for delete, update
as
begin
	
end
go

--khai báo biến trong sql
declare @ten_bien int
--cài đặt giá trị có 2 cách
set @ten_bien = 10
--
--in giá trị biến ra màn hình
print @ten_bien
select @ten_bien [bien]
go

declare @Cusname nvarchar(25), @CusAge tinyint
--set @Cusname = (select Cusname from Customer where CusID = 1)
--set @CusAge = (select CusAge from Customer where CusID = 1)
select @Cusname = Cusname, @CusAge = CusAge
from Customer where CusID = 1

print @Cusname + ' ' + convert(nvarchar,@CusAge)
select @Cusname CustomerName, @CusAge CustomerName
go


declare @TableCustomer table (Cusname varchar(25))
insert into @TableCustomer (CusName)
select CusName from Customer
select CusName from @TableCustomer
where CusName = 'Minh Quan'
go

insert into Customer (CusID,CusName,CusAge)
values (6,'nguyen',50)
go

alter trigger CheckAge
on Customer
after insert
as
begin
	declare @CusAge tinyint
	select @CusAge = CusAge from inserted 
	if @CusAge>100
	begin
		select 'loi cusage <= 100 tuoi' error
		rollback transaction
		delete from Customer where CusAge = @CusAge
	end
end
go


--luật sql
--1. nhập dữ liệu của bảng 1 trước nhiều sau
--2. dữ liệu vào sql nếu là ngày tháng thì phải nhập năm-/tháng-/ngày
--3. 


--trigger ma` can` du lieu cua cau delete nay`
--thi trigger goi cau nay la delete
delete from Product
where ProID = 3
go

create trigger ShowDel
on Product
instead of delete
as
begin
	declare @ProID int
	select @ProID = ProID from Deleted
	delete from OrderDetails where ProID = @ProID
	delete from Product where ProID = @ProID
end
go

select * from Product

--////////////////////////////
delete from OrderDetails
go

alter trigger showOrd
on OrderDetails
after delete
as
begin
	declare @count int
	select @count = count(*) from OrderDetails
	print 'co ' + convert(nvarchar,@count) + ' dong bi xoa'
	--select * from Deleted
	select * into khacnguyen1 from deleted
end
go

update Customer set CusName = 'khacnguyen'
where CusID = 5
go

create trigger showupdate
on Customer
after update
as
begin
	if(update(CusName))
	begin
		select * from deleted
		select * from inserted
	end
end
go