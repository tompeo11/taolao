USE QLDA
GO
 
--1. Tìm những nhân viên làm việc ở phòng số 4
SELECT HONV+' '+TENLOT+' '+TENNV HO_TEN,PHG
FROM NHANVIEN
WHERE PHG=4
GO

--2. Tìm những nhân viên có mức lương trên 30000
SELECT HONV+' '+TENLOT+' '+TENNV HO_TEN,LUONG 
FROM NHANVIEN
WHERE LUONG > 30000
ORDER BY LUONG
GO

--3. Tìm các nhân viên có mức lương trên 25,000 ở phòng 4 hoặc các nhân viên có mức lương trên 30,000 ở phòng 5
SELECT HONV+' '+TENLOT+' '+TENNV HO_TEN,PHG,LUONG
FROM NHANVIEN
WHERE LUONG > 30000 AND PHG = 5
ORDER BY LUONG
GO

--4. Cho biết họ tên đầy đủ của các nhân viên ở TP HCM
SELECT HONV+' '+TENLOT+' '+TENNV HO_TEN,DCHI
FROM NHANVIEN
WHERE DCHI LIKE N'%TP HCM%'
GO

--5. Cho biết ngày sinh và địa chỉ của nhân viên Dinh Ba Tien
SELECT HONV+' '+TENLOT+' '+TENNV FULLNAME,NGAYSINH,DCHI
FROM NHANVIEN
WHERE HONV collate sql_Latin1_General_CP1_CI_AI =N'Dinh' collate sql_Latin1_General_CP1_CI_AI 
AND TENLOT collate sql_Latin1_General_CP1_CI_AI =N'Ba' collate sql_Latin1_General_CP1_CI_AI 
AND TENNV collate sql_Latin1_General_CP1_CI_AI =N'Tien' collate sql_Latin1_General_CP1_CI_AI 
GO

--6. Với mỗi phòng ban, cho biết tên phòng ban và địa điểm phòng
SELECT PB.TENPHG, DDP.DIADIEM
FROM PHONGBAN PB 
JOIN DIADIEM_PHG DDP
ON PB.MAPHG = DDP.MAPHG
GO

--7. Tìm tên những người trưởng phòng của từng phòng ban
SELECT TENNV,PB.TENPHG
FROM NHANVIEN NV 
JOIN PHONGBAN PB
ON NV.MANV = PB.TRPHG
GO

--8. Tìm TENDA, MADA, DDIEM_DA, PHONG, TENPHG, MAPHG, TRPHG, NG_NHANCHUC
SELECT TENDA,MADA,DDIEM_DA,DA.PHONG,TENPHG,PB.MAPHG,TRPHG,NG_NHANCHUC
FROM DEAN DA
JOIN PHONGBAN PB
ON DA.PHONG = PB.MAPHG
ORDER BY MAPHG
GO

--10. Tìm tên và địa chỉ của tất cả các nhân viên của phòng "Nghien cuu".
SELECT TENNV,NV.DCHI,PB.TENPHG
FROM NHANVIEN NV
JOIN PHONGBAN PB
ON NV.PHG = PB.MAPHG
WHERE PHG = 5
GO

--11. Tìm tên những nữ nhân viên và tên người thân của họ
SELECT NV.TENNV,NV.PHAI,TN.TENTN
FROM NHANVIEN NV
JOIN THANNHAN TN
ON NV.MANV = TN.MA_NVIEN
WHERE NV.PHAI = N'NỮ'
GO

--12. Với mọi đề án ở "Ha Noi", liệt kê các mã số đề án (MADA), mã số phòng ban chủ trì đề án (PHONG), họ tên trưởng phòng (HONV, TENLOT, TENNV) cũng như địa chỉ (DCHI) và ngày sinh (NGSINH) của người ấy.
SELECT DA.MADA,DA.PHONG,HONV+' '+TENLOT+' '+TENNV HO_TEN_TRUONG_PHONG,NV.DCHI,NV.NGAYSINH
FROM NHANVIEN NV
JOIN PHONGBAN PB
ON NV.PHG = PB.MAPHG
JOIN DEAN DA
ON PB.MAPHG = DA.PHONG
WHERE NV.MANV = PB.TRPHG 
AND PB.MAPHG = DA.PHONG
AND DA.DDIEM_DA collate sql_Latin1_General_CP1_CI_AI =N'Ha Noi' collate sql_Latin1_General_CP1_CI_AI
GO

--13. Với mỗi nhân viên, cho biết họ tên nhân viên và họ tên người quản lý trực tiếp của nhân viên đó
SELECT NV.HONV+' '+NV.TENLOT+' '+NV.TENNV HO_TEN_NHAN_VIEN,QL.HONV+' '+QL.TENLOT+' '+QL.TENNV HO_TEN_NGUOI_QUAN_LY
FROM NHANVIEN NV
LEFT JOIN NHANVIEN QL
ON QL.MANV = NV.MA_NQL
ORDER BY HO_TEN_NGUOI_QUAN_LY
GO

--14. Với mỗi nhân viên, cho biết họ tên nhân viên và họ tên trưởng phòng của phòng ban mà nhân viên đó làm việc
SELECT NV.HONV+' '+NV.TENLOT+' '+NV.TENNV HO_TEN_NHAN_VIEN,NV.PHG,TP.HONV+' '+TP.TENLOT+' '+TP.TENNV HO_TEN_TRUONG_PHONG
FROM PHONGBAN PB
JOIN NHANVIEN NV
ON PB.MAPHG = NV.PHG
JOIN NHANVIEN TP
ON PB.TRPHG = TP.MANV
ORDER BY PHG
GO

--15. Tên những nhân viên phòng số 5 có tham gia vào đề án "San pham X" và nhân viên này do "Nguyen Thanh Tung" quản lý trực tiếp.
SELECT NV.TENNV,DA.TENDA TEN_DE_AN_DO_NGUYEN_THANN_TUNG_QUAN_LY
FROM NHANVIEN NV
JOIN NHANVIEN QL
ON NV.MA_NQL = QL.MANV
JOIN DEAN DA
ON DA.PHONG = NV.PHG
WHERE NV.PHG = 5 
AND DA.TENDA = N'San pham X'
AND QL.HONV collate sql_Latin1_General_CP1_CI_AI =N'Nguyen' collate sql_Latin1_General_CP1_CI_AI
AND QL.TENLOT collate sql_Latin1_General_CP1_CI_AI =N'Thanh' collate sql_Latin1_General_CP1_CI_AI
AND QL.TENNV collate sql_Latin1_General_CP1_CI_AI =N'Tung' collate sql_Latin1_General_CP1_CI_AI
GO

--16. Cho biết họ tên nhân viên (HONV, TENLOT, TENNV) và tên các đề án mà nhân viên ấy tham gia nếu có.
SELECT NV.HONV+' '+NV.TENLOT+' '+NV.TENNV HO_TEN_NHAN_VIEN,DA.TENDA
FROM NHANVIEN NV
JOIN PHONGBAN PB
ON NV.PHG = PB.MAPHG
JOIN DEAN DA
ON NV.PHG = DA.PHONG
GO

--17. Với mỗi đề án, liệt kê tên đề án (TENDA) và tổng số giờ làm việc một tuần của tất cả các nhân viên tham dự đề án đó.
SELECT DA.TENDA,SUM(THOIGIAN) TONG_SO_GIO_LAM_VIEC_1_TUAN
FROM DEAN DA
JOIN PHANCONG PC
ON DA.MADA = PC.MADA
GROUP BY DA.TENDA
ORDER BY TONG_SO_GIO_LAM_VIEC_1_TUAN
GO

--18. Với mỗi nhân viên, cho biết họ và tên nhân viên và nhân viên đó có bao nhiêu thân nhân
SELECT NV.HONV+' '+NV.TENLOT+' '+NV.TENNV HO_TEN_NHAN_VIEN,COUNT(MA_NVIEN) THAN_NHAN
FROM NHANVIEN NV
LEFT JOIN THANNHAN TN
ON NV.MANV = TN.MA_NVIEN
GROUP BY NV.HONV,NV.TENLOT,NV.TENNV
ORDER BY THAN_NHAN
GO

--19. Với mỗi phòng ban, liệt kê tên phòng ban (TENPHG) và lương trung bình của những nhân viên làm việc cho phòng ban đó.
SELECT PB.TENPHG,AVG(LUONG) LUONG_TRUNG_BINH
FROM PHONGBAN PB
JOIN NHANVIEN NV
ON PB.MAPHG = NV.PHG
GROUP BY PB.TENPHG
GO

--20. Lương trung bình của tất cả các nữ nhân viên
SELECT AVG(LUONG) LUONG_TRUNG_BINH_TAT_CA_NU_NHAN_VIEN
FROM NHANVIEN 
WHERE PHAI = N'NỮ'
GO

--21. Với các phòng ban có mức lương trung bình trên 30,000, liệt kê tên phòng ban và số lượng nhân viên của phòng ban đó.
SELECT PB.TENPHG,COUNT(MANV) SO_LUONG_NHAN_VIEN
FROM PHONGBAN PB
JOIN NHANVIEN NV
ON PB.MAPHG = NV.PHG
GROUP BY PB.TENPHG
HAVING AVG(LUONG) > 30000
ORDER BY SO_LUONG_NHAN_VIEN
GO