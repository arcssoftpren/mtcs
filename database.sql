-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Waktu pembuatan: 23 Mar 2025 pada 16.44
-- Versi server: 10.4.32-MariaDB
-- Versi PHP: 8.0.30

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `mtcs_softpren`
--
CREATE DATABASE IF NOT EXISTS `mtcs_softpren` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;
USE `mtcs_softpren`;

-- --------------------------------------------------------

--
-- Struktur dari tabel `resulttype`
--

CREATE TABLE `resulttype` (
  `typeId` int(11) NOT NULL,
  `typeLabel` varchar(255) NOT NULL,
  `typeDesc` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data untuk tabel `resulttype`
--

INSERT INTO `resulttype` (`typeId`, `typeLabel`, `typeDesc`) VALUES
(1, 'OK/NG', 'Hasil pengamatan menghasilkan kesimpulan OK/NG.'),
(2, 'String', 'Hasil pengukuran ditulis dengan text tertentu dan dibandingkan dengan sebuah standar text.'),
(3, 'Exact Match Number', 'Hasil pengukuran ditulis dengan angka dan dibandingkan dengan standar harus sama persis.'),
(4, 'Number Range', 'Hasil pengukuran ditulis dengan angka dan dibandingkan dengan rentang angka standar.'),
(5, 'Number Larger Than', 'Hasil pengukuran ditulis dengan angka dan dibandingkan dengan standar angka minimum.'),
(6, 'Number Less Than', 'Hasil pengukuran ditulis dengan angka dan dibandingkan dengan standar angka maximum.');

-- --------------------------------------------------------

--
-- Struktur dari tabel `tooldata`
--

CREATE TABLE `tooldata` (
  `dataId` int(11) NOT NULL,
  `columId` int(11) NOT NULL,
  `dataValue` varchar(255) DEFAULT NULL,
  `toolId` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data untuk tabel `tooldata`
--

INSERT INTO `tooldata` (`dataId`, `columId`, `dataValue`, `toolId`) VALUES
(1, 2, '0-150mm', 4),
(2, 12, '2025-10-16', 4),
(4, 6, '2017-11-04', 4),
(5, 5, 'B17058947', 4),
(6, 10, 'PT. Sentral Tehnologi Managemen', 4),
(7, 7, 'Mitutoyo', 4),
(8, 11, '2024-10-25', 4),
(9, 3, '0.01mm', 4),
(10, 9, 'External 1/Year', 4),
(11, 4, '0,05 mm', 4),
(12, 8, 'Inspection', 4),
(19, 13, NULL, 4);

-- --------------------------------------------------------

--
-- Struktur dari tabel `t_checkmethod`
--

CREATE TABLE `t_checkmethod` (
  `methodId` int(11) NOT NULL,
  `pointCheckId` int(11) NOT NULL,
  `methodString` varchar(1024) NOT NULL,
  `resultType` int(11) NOT NULL,
  `standard` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data untuk tabel `t_checkmethod`
--

INSERT INTO `t_checkmethod` (`methodId`, `pointCheckId`, `methodString`, `resultType`, `standard`) VALUES
(2, 2, 'Apakah kondisi Inside Jaws tidak berkarat & tdk lecet, rusak?', 1, '{\"name\":\"matchString\",\"arg\":[\"OK\"]}'),
(3, 3, 'Apakah kondisi Depth Bar tidak berkarat & tdk lecet, rusak?', 1, '{\"name\":\"matchString\",\"arg\":[\"OK\"]}'),
(4, 4, 'Apakah angka pada display unit dapat terbaca jelas?', 1, '{\"name\":\"matchString\",\"arg\":[\"OK\"]}'),
(5, 6, 'Apakah jika zero origin ditekan menunjukkan angka \"0\" pada display unit?', 1, '{\"name\":\"matchString\",\"arg\":[\"OK\"]}'),
(6, 7, 'Apakah Bagian Skala Vernier dapat digeser dengan lancar?', 1, '{\"name\":\"matchString\",\"arg\":[\"OK\"]}'),
(7, 8, 'a. Apakah pada Digital caliper tercantum sticker tanggal kalibrasi ulang ?', 1, '{\"name\":\"matchString\",\"arg\":[\"OK\"]}'),
(8, 8, 'b. Apakah tanggal next kalibrasi pada sticker masih berlaku ?', 1, '{\"name\":\"matchString\",\"arg\":[\"OK\"]}'),
(9, 8, 'c. Apakah sticker kalibrasi ulang masih utuh dan dapat dibaca dengan jelas ?', 1, '{\"name\":\"matchString\",\"arg\":[\"OK\"]}'),
(10, 1, 'Apakah kondisi Outside Jaws tidak berkarat ,tdk lecet , rusak?', 1, '{\"name\":\"matchString\",\"arg\":[\"OK\"]}');

-- --------------------------------------------------------

--
-- Struktur dari tabel `t_collumns`
--

CREATE TABLE `t_collumns` (
  `collumnId` int(11) NOT NULL,
  `collumnEnString` varchar(255) NOT NULL,
  `columnJpString` varchar(255) NOT NULL,
  `isDefault` int(11) NOT NULL,
  `dataType` varchar(255) NOT NULL DEFAULT 'text'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data untuk tabel `t_collumns`
--

INSERT INTO `t_collumns` (`collumnId`, `collumnEnString`, `columnJpString`, `isDefault`, `dataType`) VALUES
(2, 'Range of\r\nMeasurement', '測定範囲', 1, 'text'),
(3, 'Resolution', '最小表示量', 1, 'text'),
(4, 'Calibration　Standard Accuracy (±）', '校正規格精度 (±）', 1, 'text'),
(5, 'Serial No.', 'メーカー製造No．', 1, 'text'),
(6, 'Registration Date', '登録日', 1, 'date'),
(7, 'Maker', '製造者名', 1, 'text'),
(8, 'Place', '場所', 1, 'text'),
(9, 'Calibration Interval', '校正間隔', 0, 'text'),
(10, 'Calibrated by', '作業許容精度', 0, 'text'),
(11, 'Last\r\nCalibration', '最終校正日', 0, 'date'),
(12, 'Next Calibration Plan', '次回の校正計画', 0, 'date'),
(13, 'Actual Date Calibration', '実際の校正日', 0, 'date');

-- --------------------------------------------------------

--
-- Struktur dari tabel `t_dailyinspection`
--

CREATE TABLE `t_dailyinspection` (
  `insId` int(11) NOT NULL,
  `toolId` int(11) NOT NULL,
  `instData` varchar(1024) NOT NULL,
  `checker` int(11) NOT NULL,
  `checkDate` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `judgement` int(11) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Struktur dari tabel `t_pointcheck`
--

CREATE TABLE `t_pointcheck` (
  `checkId` int(11) NOT NULL,
  `toolId` int(11) NOT NULL,
  `pointString` varchar(128) NOT NULL,
  `pointNumber` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data untuk tabel `t_pointcheck`
--

INSERT INTO `t_pointcheck` (`checkId`, `toolId`, `pointString`, `pointNumber`) VALUES
(1, 4, 'Outside Jaws', 1),
(2, 4, 'Inside Jaws', 2),
(3, 4, 'Depth Bar', 3),
(4, 4, 'Display Unit', 4),
(6, 4, 'Zero Origin', 5),
(7, 4, 'Skala Vernier', 6),
(8, 4, 'Kalibrasi', 0);

-- --------------------------------------------------------

--
-- Struktur dari tabel `t_rank`
--

CREATE TABLE `t_rank` (
  `rankId` int(11) NOT NULL,
  `rankName` varchar(255) NOT NULL,
  `description` varchar(1024) NOT NULL,
  `collumns` varchar(1024) NOT NULL,
  `rankNameJp` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data untuk tabel `t_rank`
--

INSERT INTO `t_rank` (`rankId`, `rankName`, `description`, `collumns`, `rankNameJp`) VALUES
(14, 'RANK A', 'Rank A Inspection Tool have to be done External Calibration at least once in a year.', '[\"2\",\"3\",\"4\",\"5\",\"6\",\"7\",\"8\",\"9\",\"10\",\"11\",\"12\",\"13\"]', 'Aランク'),
(15, 'RANK B', 'Rank B Inspection Tool have to be done External Calibration at least once in a year or more.', '[\"2\",\"3\",\"4\",\"5\",\"6\",\"7\",\"8\",\"9\",\"10\",\"11\",\"12\",\"13\"]', 'Bランク'),
(16, 'RANK C', 'Rank C Inspection Tool does not have to be done Calibration.', '[\"2\",\"3\",\"4\",\"5\",\"6\",\"7\",\"8\",\"9\"]', 'Cランク');

-- --------------------------------------------------------

--
-- Struktur dari tabel `t_roles`
--

CREATE TABLE `t_roles` (
  `roleId` int(11) NOT NULL,
  `roleName` varchar(255) NOT NULL,
  `dashboardPage` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data untuk tabel `t_roles`
--

INSERT INTO `t_roles` (`roleId`, `roleName`, `dashboardPage`) VALUES
(1, 'administrator', '/home/list');

-- --------------------------------------------------------

--
-- Struktur dari tabel `t_tools`
--

CREATE TABLE `t_tools` (
  `toolId` int(11) NOT NULL,
  `toolName` varchar(255) NOT NULL,
  `typeId` int(11) NOT NULL,
  `rankId` int(11) NOT NULL,
  `disposed` int(11) NOT NULL DEFAULT 0,
  `registerNumber` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data untuk tabel `t_tools`
--

INSERT INTO `t_tools` (`toolId`, `toolName`, `typeId`, `rankId`, `disposed`, `registerNumber`) VALUES
(4, 'Digital Caliper', 16, 14, 0, 'CAL-001');

-- --------------------------------------------------------

--
-- Struktur dari tabel `t_tooltype`
--

CREATE TABLE `t_tooltype` (
  `typeId` int(11) NOT NULL,
  `typeName` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data untuk tabel `t_tooltype`
--

INSERT INTO `t_tooltype` (`typeId`, `typeName`) VALUES
(16, 'Scale dimention');

-- --------------------------------------------------------

--
-- Struktur dari tabel `t_user`
--

CREATE TABLE `t_user` (
  `userId` varchar(255) NOT NULL,
  `userName` varchar(255) NOT NULL,
  `roleId` int(11) NOT NULL,
  `userPassword` varchar(2048) NOT NULL,
  `active` int(11) NOT NULL DEFAULT 1,
  `lastLogin` timestamp NULL DEFAULT NULL,
  `lastIP` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data untuk tabel `t_user`
--

INSERT INTO `t_user` (`userId`, `userName`, `roleId`, `userPassword`, `active`, `lastLogin`, `lastIP`) VALUES
('system', 'MIIT DEVELOPER', 1, 'U2FsdGVkX1/rkR8/1pL6MUJvxfVtSk7Nd+lC8x3y08s=', 1, '2025-03-23 03:43:03', '192.168.1.188'),
('trial', 'trial', 1, 'U2FsdGVkX1/I+yQIHbTVuIx5kV6BmtNzLVVP6Zk/9C0=', 1, NULL, NULL);

--
-- Indexes for dumped tables
--

--
-- Indeks untuk tabel `resulttype`
--
ALTER TABLE `resulttype`
  ADD PRIMARY KEY (`typeId`);

--
-- Indeks untuk tabel `tooldata`
--
ALTER TABLE `tooldata`
  ADD PRIMARY KEY (`dataId`),
  ADD UNIQUE KEY `unique_tool_column` (`toolId`,`columId`),
  ADD KEY `fk_tools_data` (`toolId`);

--
-- Indeks untuk tabel `t_checkmethod`
--
ALTER TABLE `t_checkmethod`
  ADD PRIMARY KEY (`methodId`),
  ADD KEY `fk_checkmethod_pointcheck` (`pointCheckId`);

--
-- Indeks untuk tabel `t_collumns`
--
ALTER TABLE `t_collumns`
  ADD PRIMARY KEY (`collumnId`);

--
-- Indeks untuk tabel `t_dailyinspection`
--
ALTER TABLE `t_dailyinspection`
  ADD PRIMARY KEY (`insId`);

--
-- Indeks untuk tabel `t_pointcheck`
--
ALTER TABLE `t_pointcheck`
  ADD PRIMARY KEY (`checkId`),
  ADD KEY `fk_tools_pc` (`toolId`);

--
-- Indeks untuk tabel `t_rank`
--
ALTER TABLE `t_rank`
  ADD PRIMARY KEY (`rankId`);

--
-- Indeks untuk tabel `t_roles`
--
ALTER TABLE `t_roles`
  ADD PRIMARY KEY (`roleId`);

--
-- Indeks untuk tabel `t_tools`
--
ALTER TABLE `t_tools`
  ADD PRIMARY KEY (`toolId`),
  ADD KEY `fk_tools_tooltype` (`typeId`),
  ADD KEY `fk_tools_rank` (`rankId`);

--
-- Indeks untuk tabel `t_tooltype`
--
ALTER TABLE `t_tooltype`
  ADD PRIMARY KEY (`typeId`),
  ADD KEY `typeId` (`typeId`);

--
-- Indeks untuk tabel `t_user`
--
ALTER TABLE `t_user`
  ADD PRIMARY KEY (`userId`),
  ADD KEY `fk_user_role` (`roleId`);

--
-- AUTO_INCREMENT untuk tabel yang dibuang
--

--
-- AUTO_INCREMENT untuk tabel `resulttype`
--
ALTER TABLE `resulttype`
  MODIFY `typeId` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT untuk tabel `tooldata`
--
ALTER TABLE `tooldata`
  MODIFY `dataId` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=24;

--
-- AUTO_INCREMENT untuk tabel `t_checkmethod`
--
ALTER TABLE `t_checkmethod`
  MODIFY `methodId` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT untuk tabel `t_collumns`
--
ALTER TABLE `t_collumns`
  MODIFY `collumnId` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=14;

--
-- AUTO_INCREMENT untuk tabel `t_dailyinspection`
--
ALTER TABLE `t_dailyinspection`
  MODIFY `insId` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT untuk tabel `t_pointcheck`
--
ALTER TABLE `t_pointcheck`
  MODIFY `checkId` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- AUTO_INCREMENT untuk tabel `t_rank`
--
ALTER TABLE `t_rank`
  MODIFY `rankId` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=17;

--
-- AUTO_INCREMENT untuk tabel `t_roles`
--
ALTER TABLE `t_roles`
  MODIFY `roleId` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT untuk tabel `t_tools`
--
ALTER TABLE `t_tools`
  MODIFY `toolId` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT untuk tabel `t_tooltype`
--
ALTER TABLE `t_tooltype`
  MODIFY `typeId` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=17;

--
-- Ketidakleluasaan untuk tabel pelimpahan (Dumped Tables)
--

--
-- Ketidakleluasaan untuk tabel `tooldata`
--
ALTER TABLE `tooldata`
  ADD CONSTRAINT `fk_tools_data` FOREIGN KEY (`toolId`) REFERENCES `t_tools` (`toolId`) ON DELETE CASCADE;

--
-- Ketidakleluasaan untuk tabel `t_checkmethod`
--
ALTER TABLE `t_checkmethod`
  ADD CONSTRAINT `fk_checkmethod_pointcheck` FOREIGN KEY (`pointCheckId`) REFERENCES `t_pointcheck` (`checkId`) ON DELETE CASCADE;

--
-- Ketidakleluasaan untuk tabel `t_pointcheck`
--
ALTER TABLE `t_pointcheck`
  ADD CONSTRAINT `fk_tools_pc` FOREIGN KEY (`toolId`) REFERENCES `t_tools` (`toolId`) ON DELETE CASCADE;

--
-- Ketidakleluasaan untuk tabel `t_tools`
--
ALTER TABLE `t_tools`
  ADD CONSTRAINT `fk_tools_rank` FOREIGN KEY (`rankId`) REFERENCES `t_rank` (`rankId`) ON DELETE CASCADE,
  ADD CONSTRAINT `fk_tools_tooltype` FOREIGN KEY (`typeId`) REFERENCES `t_tooltype` (`typeId`) ON DELETE CASCADE;

--
-- Ketidakleluasaan untuk tabel `t_user`
--
ALTER TABLE `t_user`
  ADD CONSTRAINT `fk_user_role` FOREIGN KEY (`roleId`) REFERENCES `t_roles` (`roleId`) ON DELETE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
