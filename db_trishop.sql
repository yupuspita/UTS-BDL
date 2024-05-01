-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Waktu pembuatan: 01 Bulan Mei 2024 pada 10.46
-- Versi server: 10.4.28-MariaDB
-- Versi PHP: 8.2.4

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `db_trishop`
--

-- --------------------------------------------------------

--
-- Struktur dari tabel `t_customer`
--

CREATE TABLE `t_customer` (
  `ID_customer` varchar(20) NOT NULL,
  `nama_customer` varchar(225) DEFAULT NULL,
  `alamat_cus` text DEFAULT NULL,
  `tlp_cus` varchar(20) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data untuk tabel `t_customer`
--

INSERT INTO `t_customer` (`ID_customer`, `nama_customer`, `alamat_cus`, `tlp_cus`) VALUES
('c01', 'Dina', 'Karangasem', '08116252715'),
('c02', 'Intan', 'Binong', '085162535201'),
('c03', 'Kila', 'Denkayu', '08419575366'),
('c04', 'Tina', 'Sunia', '08916253029'),
('c05', 'Tyas', 'Tabanan', '087162566750');

-- --------------------------------------------------------

--
-- Struktur dari tabel `t_distributor`
--

CREATE TABLE `t_distributor` (
  `ID_distributor` varchar(20) NOT NULL,
  `nama` varchar(225) DEFAULT NULL,
  `info_kontak` varchar(225) DEFAULT NULL,
  `alamat_dis` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data untuk tabel `t_distributor`
--

INSERT INTO `t_distributor` (`ID_distributor`, `nama`, `info_kontak`, `alamat_dis`) VALUES
('s1', 'Yanto', '087860201654', 'Madura'),
('s2', 'solikin', '087883001456', 'Jatim'),
('s3', 'Sudarmanto', '089860201445', 'Malang'),
('s4', 'Febri', '08886020451', 'Surabaya'),
('s5', 'Degus', '08986020444', 'Jakarta');

-- --------------------------------------------------------

--
-- Struktur dari tabel `t_karyawan`
--

CREATE TABLE `t_karyawan` (
  `ID_karyawan` varchar(20) NOT NULL,
  `nama_karyawan` varchar(225) DEFAULT NULL,
  `alamat` text DEFAULT NULL,
  `email` varchar(50) DEFAULT NULL,
  `tlp_kar` varchar(20) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data untuk tabel `t_karyawan`
--

INSERT INTO `t_karyawan` (`ID_karyawan`, `nama_karyawan`, `alamat`, `email`, `tlp_kar`) VALUES
('n01', 'Kora', 'Mengwi', 'Kora@gmail.com', '08716252515'),
('n02', 'Ceri', 'Sayan', 'Ceri@gmail.com', '0871625201'),
('n03', 'Bibib', 'Ubud', 'Bibib@gmail.com', '08716225366'),
('n04', 'Amin', 'Puri', 'Amin@gmail.com', '08716253043');

-- --------------------------------------------------------

--
-- Struktur dari tabel `t_pembelian`
--

CREATE TABLE `t_pembelian` (
  `ID_pembelian` varchar(20) NOT NULL,
  `tgl_beli` date DEFAULT NULL,
  `ID_produk` varchar(20) DEFAULT NULL,
  `ID_karyawan` varchar(20) DEFAULT NULL,
  `ID_distributor` varchar(20) DEFAULT NULL,
  `jml_beli` int(11) DEFAULT NULL,
  `totalharga_beli` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data untuk tabel `t_pembelian`
--

INSERT INTO `t_pembelian` (`ID_pembelian`, `tgl_beli`, `ID_produk`, `ID_karyawan`, `ID_distributor`, `jml_beli`, `totalharga_beli`) VALUES
('b01', '2024-01-02', 'p01', 'n04', 's2', 2, 3200000),
('b02', '2024-01-22', 'p02', 'n02', 's4', 3, 1050000),
('b03', '2024-02-24', 'p03', 'n03', 's5', 1, 12000000);

-- --------------------------------------------------------

--
-- Struktur dari tabel `t_penjualan`
--

CREATE TABLE `t_penjualan` (
  `ID_penjualan` varchar(20) NOT NULL,
  `tgl_jual` date DEFAULT NULL,
  `ID_produk` varchar(20) DEFAULT NULL,
  `ID_karyawan` varchar(20) DEFAULT NULL,
  `ID_customer` varchar(20) DEFAULT NULL,
  `jml_jual` int(10) DEFAULT NULL,
  `totalharga_jual` int(20) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data untuk tabel `t_penjualan`
--

INSERT INTO `t_penjualan` (`ID_penjualan`, `tgl_jual`, `ID_produk`, `ID_karyawan`, `ID_customer`, `jml_jual`, `totalharga_jual`) VALUES
('j01', '2024-03-10', 'p01', 'n01', 'c03', 2, 3200000),
('j02', '2024-02-12', 'p02', 'n02', 'c04', 3, 1050000),
('j03', '2024-03-20', 'p03', 'n03', 'c01', 1, 10800000),
('j04', '2024-04-25', 'p02', 'n01', 'c05', 2, 700000),
('j05', '2024-04-25', 'p03', 'n03', 'c04', 3, 32400000);

--
-- Trigger `t_penjualan`
--
DELIMITER $$
CREATE TRIGGER `diskon_otomatis` BEFORE INSERT ON `t_penjualan` FOR EACH ROW BEGIN
    DECLARE total_penjualan INT;
    SELECT COALESCE(SUM(totalharga_jual), 0) INTO total_penjualan FROM T_Penjualan WHERE ID_customer = NEW.ID_customer;
    SET total_penjualan = total_penjualan + NEW.totalharga_jual;
    IF total_penjualan > 10000000 THEN
        SET NEW.totalharga_jual = NEW.totalharga_jual * 0.9;
    END IF;
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `hitung_total_harga_penjualan` BEFORE INSERT ON `t_penjualan` FOR EACH ROW BEGIN

    SET NEW.totalharga_jual = (
        SELECT COALESCE(harga_jual * NEW.jml_jual, 0)
        FROM T_Produk
        WHERE ID_produk = NEW.ID_produk
    );
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Struktur dari tabel `t_produk`
--

CREATE TABLE `t_produk` (
  `ID_produk` varchar(20) NOT NULL,
  `nama_produk` varchar(225) DEFAULT NULL,
  `kategori` varchar(50) DEFAULT NULL,
  `berat` varchar(20) DEFAULT NULL,
  `harga_beli` int(10) DEFAULT NULL,
  `harga_jual` int(10) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data untuk tabel `t_produk`
--

INSERT INTO `t_produk` (`ID_produk`, `nama_produk`, `kategori`, `berat`, `harga_beli`, `harga_jual`) VALUES
('p01', 'kalung', 'emas', '10gr', 1500000, 1600000),
('p02', 'gelang', 'perak', '8gr', 250000, 350000),
('p03', 'cincin', 'berlian', '5gr', 11000000, 12000000),
('p04', 'gelang', 'emas', '8gr', 900000, 1000000),
('p05', 'kalung', 'berlian', '10gr', 20000000, 21000000);

-- --------------------------------------------------------

--
-- Stand-in struktur untuk tampilan `v_customer_diskon`
-- (Lihat di bawah untuk tampilan aktual)
--
CREATE TABLE `v_customer_diskon` (
`ID_customer` varchar(20)
,`nama_customer` varchar(225)
,`alamat_cus` text
,`tlp_cus` varchar(20)
);

-- --------------------------------------------------------

--
-- Stand-in struktur untuk tampilan `v_penjualan_kategori_sama`
-- (Lihat di bawah untuk tampilan aktual)
--
CREATE TABLE `v_penjualan_kategori_sama` (
`ID_penjualan` varchar(20)
,`tgl_jual` date
,`ID_produk` varchar(20)
,`nama_produk` varchar(225)
,`kategori` varchar(50)
,`ID_karyawan` varchar(20)
,`ID_customer` varchar(20)
,`jml_jual` int(10)
,`totalharga_jual` int(20)
);

-- --------------------------------------------------------

--
-- Struktur untuk view `v_customer_diskon`
--
DROP TABLE IF EXISTS `v_customer_diskon`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `v_customer_diskon`  AS SELECT `t_customer`.`ID_customer` AS `ID_customer`, `t_customer`.`nama_customer` AS `nama_customer`, `t_customer`.`alamat_cus` AS `alamat_cus`, `t_customer`.`tlp_cus` AS `tlp_cus` FROM (`t_customer` join `t_penjualan` on(`t_customer`.`ID_customer` = `t_penjualan`.`ID_customer`)) GROUP BY `t_customer`.`ID_customer` HAVING sum(`t_penjualan`.`totalharga_jual`) > 10000000 ;

-- --------------------------------------------------------

--
-- Struktur untuk view `v_penjualan_kategori_sama`
--
DROP TABLE IF EXISTS `v_penjualan_kategori_sama`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `v_penjualan_kategori_sama`  AS SELECT `p`.`ID_penjualan` AS `ID_penjualan`, `p`.`tgl_jual` AS `tgl_jual`, `p`.`ID_produk` AS `ID_produk`, `pr`.`nama_produk` AS `nama_produk`, `pr`.`kategori` AS `kategori`, `p`.`ID_karyawan` AS `ID_karyawan`, `p`.`ID_customer` AS `ID_customer`, `p`.`jml_jual` AS `jml_jual`, `p`.`totalharga_jual` AS `totalharga_jual` FROM ((`t_penjualan` `p` join `t_produk` `pr` on(`p`.`ID_produk` = `pr`.`ID_produk`)) join (select `t_produk`.`ID_produk` AS `ID_produk`,`t_produk`.`kategori` AS `kategori` from `t_produk` group by `t_produk`.`kategori` having count(0) > 1) `pk` on(`pr`.`kategori` = `pk`.`kategori`)) ;

--
-- Indexes for dumped tables
--

--
-- Indeks untuk tabel `t_customer`
--
ALTER TABLE `t_customer`
  ADD PRIMARY KEY (`ID_customer`);

--
-- Indeks untuk tabel `t_distributor`
--
ALTER TABLE `t_distributor`
  ADD PRIMARY KEY (`ID_distributor`);

--
-- Indeks untuk tabel `t_karyawan`
--
ALTER TABLE `t_karyawan`
  ADD PRIMARY KEY (`ID_karyawan`);

--
-- Indeks untuk tabel `t_pembelian`
--
ALTER TABLE `t_pembelian`
  ADD PRIMARY KEY (`ID_pembelian`),
  ADD KEY `ID_produk` (`ID_produk`),
  ADD KEY `ID_karyawan` (`ID_karyawan`),
  ADD KEY `ID_distributor` (`ID_distributor`);

--
-- Indeks untuk tabel `t_penjualan`
--
ALTER TABLE `t_penjualan`
  ADD PRIMARY KEY (`ID_penjualan`),
  ADD KEY `ID_produk` (`ID_produk`),
  ADD KEY `ID_karyawan` (`ID_karyawan`),
  ADD KEY `ID_customer` (`ID_customer`);

--
-- Indeks untuk tabel `t_produk`
--
ALTER TABLE `t_produk`
  ADD PRIMARY KEY (`ID_produk`);

--
-- Ketidakleluasaan untuk tabel pelimpahan (Dumped Tables)
--

--
-- Ketidakleluasaan untuk tabel `t_pembelian`
--
ALTER TABLE `t_pembelian`
  ADD CONSTRAINT `t_pembelian_ibfk_1` FOREIGN KEY (`ID_produk`) REFERENCES `t_produk` (`ID_produk`),
  ADD CONSTRAINT `t_pembelian_ibfk_2` FOREIGN KEY (`ID_karyawan`) REFERENCES `t_karyawan` (`ID_karyawan`),
  ADD CONSTRAINT `t_pembelian_ibfk_3` FOREIGN KEY (`ID_distributor`) REFERENCES `t_distributor` (`ID_distributor`);

--
-- Ketidakleluasaan untuk tabel `t_penjualan`
--
ALTER TABLE `t_penjualan`
  ADD CONSTRAINT `t_penjualan_ibfk_1` FOREIGN KEY (`ID_produk`) REFERENCES `t_produk` (`ID_produk`),
  ADD CONSTRAINT `t_penjualan_ibfk_2` FOREIGN KEY (`ID_karyawan`) REFERENCES `t_karyawan` (`ID_karyawan`),
  ADD CONSTRAINT `t_penjualan_ibfk_3` FOREIGN KEY (`ID_customer`) REFERENCES `t_customer` (`ID_customer`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
