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
	NamSinh smallint not null,
	ThuDienTu char(100) not null
)
go

drop table if exists Diem
create table Diem
(
	MaSV int,
	MaMH int,
	NgayThi datetime not null,
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

insert into SinhVien values (1, N'Nguyễn Hoàng Anh', 1980, 'nhanh@yahoo.com')
insert into SinhVien values (2, N'Trần Hạo Bình', 1980, 'trhbinh@gmail.com')
insert into SinhVien values (3, N'Trương Bảo Thu', 1982, 'truongbaothu@hotmail.com')
insert into SinhVien values (4, N'Hứa Quảng Hà', 1990, 'huaquangha@gmail.com')
insert into SinhVien values (5, N'Bành Đại Kiên', 1978, 'truongdaikien@hotmail.com')
insert into SinhVien values (6, N'Quách Đại Lộ', 1980, 'quachdailo@yahoo.com')
insert into SinhVien values (7, N'Trương Tiểu Hướng', 1983, 'trtieuhuong@gmail.com')
insert into SinhVien values (8, N'Sái Văn Cơ', 1980, 'svc@gmail.com')
insert into SinhVien values (9, N'Phạm Thời Bình', 1980, 'phtb@gmail.com')
go

insert into MonHoc values(1, N'Word', 30)
insert into MonHoc values(2, N'Excel', 60)
insert into MonHoc values(3, N'Access', 80)
insert into MonHoc values(4, N'C programming', 60)
insert into MonHoc values(5, N'HTML', 30)
insert into MonHoc values(6, N'ASP programming', 30)
go

insert into Diem values(1, 1, '20051231', 9)
insert into Diem values(1, 1, '20051120', 3)
insert into Diem values(1, 3, '20050417', 8)
insert into Diem values(1, 2, '20050413', 8)
insert into Diem values(2, 3, '20050525', 9)
insert into Diem values(2, 3, '20050525', 9)
insert into Diem values(9, 5, '20051020', 8)
insert into Diem values(8, 5, '20050425', 6)
insert into Diem values(5, 3, '20050821', 7)
go

create proc cau3
@MaMon int,
@TenMon nvarchar(50),
@SoTiet int
as
begin
	insert into MonHoc(MaMon,TenMon,SoTiet) values (@MaMon,@TenMon,@SoTiet)
end
go

create proc cau4
@NamSinh smallint
as
begin
	select sv.TenSV,di.DiemThi,mh.TenMon,SV.NamSinh
	from Diem Di
	join SinhVien SV
	on Di.MaSV = SV.MaSV
	join MonHoc MH
	on Di.MaMH = MH.MaMon
	where SV.NamSinh = @NamSinh
end
go

create proc cau5
as
begin
	select sv.TenSV,di.DiemThi
	from SinhVien SV
	left join Diem Di
	on SV.MaSV = Di.MaSV
	where Di.DiemThi is null
end
go

create proc cau6
as
begin
	select SV.TenSV,avg(DiemThi) Diem_Trung_Binh
	from SinhVien SV
	join Diem Di
	on SV.MaSV = Di.MaSV
	group by SV.TenSV
	having avg(DiemThi) > 4
	order by Diem_Trung_Binh
end
go

create proc cau7
as
begin
	select count(*) TongSVDaThi from (select sv.TenSV
	from SinhVien SV
	left join Diem Di
	on SV.MaSV = Di.MaSV
	where Di.DiemThi is not null
	group by sv.TenSV) SVDaThi
end
go
