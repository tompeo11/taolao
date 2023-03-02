use master
go

drop database if exists QLD
create database QLD
go

use QLD
go

drop table if exists MonHoc
create table MonHoc
(
	MaMon int primary key,
	TenMon nvarchar(50) not null,
	SoTiet int
)
go

drop table if exists SinhVien
create table SinhVien
(
	MaSV int primary key,
	TenSV nvarchar(70) not null,
	NamSinh smallint,
	ThuDienTu char(100)
)
go

drop table if exists Diem
create table Diem
(
	MaSV int,
	MaMH int,
	NgayThi datetime,
	DiemThi int
	primary key (MaSV,MaMH)
)
go

alter table Diem
add
constraint FK_Diem_SinhVien
foreign key (MaSV)
references SinhVien(MaSV)
go

alter table Diem
add
constraint FK_Diem_MonHoc
foreign key (MaMH)
references MonHoc(MaMon)
go

insert into SinhVien
values
	(1,N'Nguyễn Hoàng Anh', 1980, 'nhanh@yahoo.com'),
	(2,N'Trần Hạo Bình', 1980, 'trhbinh@gmail.com'),
	(3,N'Trương Bảo Thu', 1982, 'truongbaothu@hotmail.com'),
	(4,N'Hứa Quảng Hà', 1990, 'huaquangha@gmail.com'),
	(5,N'Bành Đại Kiên', 1978, 'truongdaikien@hotmail.com'),
	(6,N'Quách Đại Lộ', 1980, 'quachdailo@yahoo.com'),
	(7,N'Trương Tiểu Hướng', 1983, 'trtieuhuong@gmail.com'),
	(8,N'Sái Văn Cơ', 1980, 'svc@gmail.com'),
	(9,N'Phạm Thời Bình', 1980, 'phtb@gmail.com')
go

insert into MonHoc
values
	 (1,N'Word',30),
	 (2,N'Excel',60),
	 (3,N'Access',80),
	 (4,N'C programming',60),
	 (5,N'HTML',30),
	 (6,N'ASP programming',30)
go

insert into Diem
values	
	(1,1,'20051231',9),
	(1,1,'20051120',3),
	(1,3,'20050417',8),
	(1,2,'20050413',8),
	(2,3,'20050525',9),
	(2,3,'20050525',9),
	(9,5,'20051020',8),
	(8,5,'20050425',6),
	(5,3,'20050821',7)
go


select * from SinhVien