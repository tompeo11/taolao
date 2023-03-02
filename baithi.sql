use master
go

drop database if exists QuanLyNhanSu
create database QuanLyNhanSu
go

use QuanLyNhanSu
go

drop table if exists NhanVien
create table NhanVien
(
	MaNV int primary key,
	TenNV nvarchar(50),
	Tuoi smallint,
	GioiTinh bit
)
go

drop table if exists DuAn
create table DuAn
(
	MaDA int primary key,
	TenDA nvarchar(50),
	NgayBD datetime,
	NgayKT datetime
)
go

drop table if exists ThamGia
create table ThamGia
(
	MaNV int,
	MaDA int,
	NgayVaoDA datetime,
	NgayRaDA datetime
	primary key (MaNV,MaDA)
)
go

alter table ThamGia
add
constraint FK_ThamGia_NhanVien
foreign key (MaNV)
references NhanVien(MaNV)
go

alter table ThamGia
add
constraint FK_ThamGia_DuAn
foreign key (MaDA)
references DuAn(MaDA)
go

create trigger KiemTra
on NhanVien
after insert
as
begin
	declare @Tuoi smallint
	declare @GioiTinh bit
	select @Tuoi = Tuoi from inserted
	select @GioiTinh = GioiTinh from inserted
	if (@Tuoi > 45 and @GioiTinh = 0) or (@Tuoi > 50 and @GioiTinh = 1)
	begin
		print 'Tuoi khong hop le'
		rollback transaction
	end
end
go

insert into NhanVien values (1, N'Nguyễn Hoàng Anh', 1, 0)
insert into NhanVien values (2, N'Trần Hạo Bình', 33, 1)
insert into NhanVien values (5, N'Bành Đại Kiện', 30, Null)
insert into NhanVien values (6, N'Quách Đại Lộ', 32, Null)
insert into NhanVien values (4, N'Hứa Quảng Hà', 24, 0)
go

insert into DuAn values (1, N'Phần mềm quản lý trường học', '20050202', '20070505')
insert into DuAn values (2, N'Hệ thống dự báo thời tiết', '20050303', '20090308')
insert into DuAn values (3, N'Hệ thống xác thực vân tay', '20050703', '20090508')
go

insert into ThamGia values (1,1,'20060303','20070405')
insert into ThamGia values (2,1,'20060202','20070505')
insert into ThamGia values (1,2,'20060303','20070405')
insert into ThamGia values (3,2,'20060303','20070404')
go

--cau5
create proc cau5
as
begin
	select DA.TenDA, count(MaNV) SoLuong
	from ThamGia TG
	right join DuAn DA
	on TG.MaDA = DA.MaDA
	group by DA.TenDA
	order by SoLuong desc
end
go

--cau6
create proc cau6
as
begin
	select TenNV,Tuoi,
	case when GioiTinh = 0 then N'Nam'
		when GioiTinh = 1 then N'Nữ'
		else 'Không rõ'
	end GioiTinh
	from NhanVien
	order by GioiTinh DESC
end
go

--cau7
create proc cau7
as
begin
	select nv.TenNV,da.TenDA,tg.NgayVaoDA,tg.NgayRaDA
	from ThamGia TG
	join NhanVien NV
	on TG.MaNV = NV.MaNV
	join DuAn DA
	on TG.MaDA = DA.MaDA
	order by TenDA DESC
end
go

--cau8
create proc cau8
as
begin
	select NV.MaNV,Nv.TenNV,NV.Tuoi,NV.GioiTinh
	from NhanVien NV
	left join ThamGia TG
	on NV.MaNV = TG.MaNV
	where MaDA is null
end
go

--cau9
create trigger cau9
on NhanVien
instead of delete
as
begin
	declare @MaNV int
	select @MaNV = MaNV from Deleted
	delete from ThamGia where MaNV = @MaNV
	delete from NhanVien where MaNV = @MaNV
end
go
--delete from NhanVien where MaNV = 1

--cau10
create nonclustered index ix_tenda on DuAn(TenDA)
go