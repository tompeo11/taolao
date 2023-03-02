use QLDA
go

--cau1
drop procedure if exists cau1
create procedure cau1
@PHG int
as
begin
	select * from NHANVIEN
	where PHG = @PHG
end
go
cau1 4



--cau2
drop proc if exists cau2
create procedure cau2
@LUONG float
as
begin
	select * from NHANVIEN
	where LUONG > @LUONG
	order by LUONG
end
go
cau2 30000



--cau3
drop proc if exists cau3
create procedure cau3
@LUONG float,
@PHG int
as
begin
	select * from NHANVIEN
	where (LUONG > @LUONG and PHG = @PHG) or (LUONG > @LUONG and PHG = @PHG)
end
go
cau3 30000,5



--cau4
drop proc if exists cau4
create procedure cau4
@DCHI nvarchar(30)
as
begin
	select HONV+' '+TENLOT+' '+TENNV TENNV,DCHI from NHANVIEN
	where DCHI like '%' + @DCHI + '%'
end
go
cau4 [TP HCM]



--cau5
drop proc if exists cau5
create procedure cau5
@HONV nvarchar(15),
@TENLOT nvarchar(15),
@TENNV nvarchar(15)
as
begin
	select HONV+' '+TENLOT+' '+TENNV HO_TEN,NGAYSINH,DCHI from NHANVIEN
	where HONV = @HONV 
	and TENLOT = @TENLOT 
	and TENNV = @TENNV
end
go
cau5 N'ÐINH',N'BÁ',N'TIẾN'



--cau6
drop proc if exists cau6
create procedure cau6
as
begin
	select TENPHG,DIADIEM
	from PHONGBAN
	join DIADIEM_PHG
	on PHONGBAN.MAPHG = DIADIEM_PHG.MAPHG
end
go
cau6



--cau7
drop proc if exists cau7
create procedure cau7
as
begin
	select NHANVIEN.TENNV,PHONGBAN.TENPHG
	from NHANVIEN
	inner join PHONGBAN
	on PHONGBAN.TRPHG = NHANVIEN.MANV
end
go
cau7



--cau8
drop proc if exists cau8
create procedure cau8
as
begin
	select *
	from DEAN
	inner join PHONGBAN
	on DEAN.PHONG = PHONGBAN.MAPHG
end
go
cau8



--cau10
drop proc if exists cau10
create procedure cau10
@PHG int
as
begin
	SELECT TENNV,NV.DCHI,PB.TENPHG
	FROM NHANVIEN NV
	JOIN PHONGBAN PB
	ON NV.PHG = PB.MAPHG
	WHERE PHG = @PHG
end
go
cau10 5



--cau11
drop proc if exists cau11
create procedure cau11
@PHAI nvarchar(3)
as
begin
	SELECT NV.TENNV,NV.PHAI,TN.TENTN
	FROM NHANVIEN NV
	JOIN THANNHAN TN
	ON NV.MANV = TN.MA_NVIEN
	WHERE NV.PHAI = @PHAI
end
go
cau11 N'nữ'



--cau12
drop proc if exists cau12
create procedure cau12
@DDIEM_DA nvarchar(15)
as
begin
	SELECT DA.MADA,DA.PHONG,HONV+' '+TENLOT+' '+TENNV HO_TEN_TRUONG_PHONG,NV.DCHI,NV.NGAYSINH
	FROM NHANVIEN NV
	JOIN PHONGBAN PB
	ON NV.PHG = PB.MAPHG
	JOIN DEAN DA
	ON PB.MAPHG = DA.PHONG
	WHERE NV.MANV = PB.TRPHG 
	AND PB.MAPHG = DA.PHONG
	AND DA.DDIEM_DA = @DDIEM_DA
end
go
cau12 N'HÀ NỘI'



--cau13
drop proc if exists cau13
create procedure cau13
as
begin
	SELECT NV.HONV+' '+NV.TENLOT+' '+NV.TENNV HO_TEN_NHAN_VIEN,QL.HONV+' '+QL.TENLOT+' '+QL.TENNV HO_TEN_NGUOI_QUAN_LY
	FROM NHANVIEN NV
	LEFT JOIN NHANVIEN QL
	ON QL.MANV = NV.MA_NQL
	ORDER BY HO_TEN_NGUOI_QUAN_LY
end
go
cau13



--cau14
drop proc if exists cau14
create procedure cau14
as
begin
	SELECT NV.HONV+' '+NV.TENLOT+' '+NV.TENNV HO_TEN_NHAN_VIEN,NV.PHG,TP.HONV+' '+TP.TENLOT+' '+TP.TENNV HO_TEN_TRUONG_PHONG
	FROM PHONGBAN PB
	JOIN NHANVIEN NV
	ON PB.MAPHG = NV.PHG
	JOIN NHANVIEN TP
	ON PB.TRPHG = TP.MANV
	ORDER BY HO_TEN_TRUONG_PHONG
end
go
cau14



--cau15
drop proc if exists cau15
create procedure cau15
@PHG int,
@TENDA nvarchar(15),
@HONV nvarchar(15),
@TENLOT nvarchar(15),
@TENNV nvarchar(15)
as
begin
	SELECT NV.TENNV,DA.TENDA,QL.TENNV TEN_NGUOI_QUAN_LY
	FROM NHANVIEN NV
	JOIN NHANVIEN QL
	ON NV.MA_NQL = QL.MANV
	JOIN DEAN DA
	ON DA.PHONG = NV.PHG
	WHERE NV.PHG = @PHG
	AND DA.TENDA = @TENDA
	AND QL.HONV = @HONV
	AND QL.TENLOT = @TENLOT
	AND QL.TENNV = @TENNV
end
go
cau15 5,[san pham x],NGUYỄN,THANH,TÙNG



--cau16
drop proc if exists cau16
create procedure cau16
as
begin
	SELECT NV.HONV+' '+NV.TENLOT+' '+NV.TENNV HO_TEN_NHAN_VIEN,DA.TENDA
	FROM NHANVIEN NV
	JOIN PHONGBAN PB
	ON NV.PHG = PB.MAPHG
	JOIN DEAN DA
	ON NV.PHG = DA.PHONG
end
go
cau16



--cau17
drop proc if exists cau17
create procedure cau17
as
begin
	SELECT DA.TENDA,SUM(THOIGIAN) TONG_SO_GIO_LAM_VIEC_1_TUAN
	FROM DEAN DA
	JOIN PHANCONG PC
	ON DA.MADA = PC.MADA
	GROUP BY DA.TENDA
	ORDER BY TONG_SO_GIO_LAM_VIEC_1_TUAN
end
go
cau17

--cau18
drop proc if exists cau18
create procedure cau18
as
begin
	SELECT NV.HONV+' '+NV.TENLOT+' '+NV.TENNV HO_TEN_NHAN_VIEN,COUNT(MA_NVIEN) SO_THAN_NHAN
	FROM NHANVIEN NV
	LEFT JOIN THANNHAN TN
	ON NV.MANV = TN.MA_NVIEN
	GROUP BY NV.HONV,NV.TENLOT,NV.TENNV
	ORDER BY SO_THAN_NHAN
end
go
cau18



--cau19
drop proc if exists cau19
create procedure cau19
as
begin
	SELECT PB.TENPHG,AVG(LUONG) LUONG_TRUNG_BINH
	FROM PHONGBAN PB
	JOIN NHANVIEN NV
	ON PB.MAPHG = NV.PHG
	GROUP BY PB.TENPHG
end
go
cau19


--cau20
drop proc if exists cau20
create procedure cau20
@PHAI nvarchar(3)
as
begin
	SELECT AVG(LUONG) LUONG_TRUNG_BINH_TAT_CA_NU_NHAN_VIEN
	FROM NHANVIEN 
	WHERE PHAI = @PHAI
end
go
cau20 nữ



--cau21
drop proc if exists cau21
create procedure cau21
@LUONGTB float
as
begin
	SELECT PB.TENPHG,COUNT(MANV) SO_LUONG_NHAN_VIEN
	FROM PHONGBAN PB
	JOIN NHANVIEN NV
	ON PB.MAPHG = NV.PHG
	GROUP BY PB.TENPHG
	HAVING AVG(LUONG) > @LUONGTB
	ORDER BY SO_LUONG_NHAN_VIEN
end
go
cau21 30000