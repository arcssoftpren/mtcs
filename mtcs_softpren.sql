-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Waktu pembuatan: 13 Jun 2025 pada 01.26
-- Versi server: 10.4.32-MariaDB
-- Versi PHP: 8.2.12

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

-- --------------------------------------------------------

--
-- Struktur dari tabel `config`
--

CREATE TABLE `config` (
  `configKey` varchar(255) NOT NULL,
  `configValue` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data untuk tabel `config`
--

INSERT INTO `config` (`configKey`, `configValue`) VALUES
('dailyControlFileNameTemplate', 'Daily Control [regNum] [month-year]'),
('montlyCheckDocNumber', 'Format-I7603-001');

-- --------------------------------------------------------

--
-- Struktur dari tabel `division`
--

CREATE TABLE `division` (
  `divId` int(11) NOT NULL,
  `divName` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data untuk tabel `division`
--

INSERT INTO `division` (`divId`, `divName`) VALUES
(1, 'it developer'),
(2, 'Production'),
(3, 'Quality Control');

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
(20, 2, '0-30kg', 5),
(21, 3, '0.002 kg', 5),
(22, 12, '2025-10-16', 5),
(24, 10, 'PT. Sentral Tehnologi Managemen', 5),
(25, 4, 'LOP Report (Good)', 5),
(26, 6, '2016-12-01', 5),
(27, 8, 'Hydrolik Press 1', 5),
(28, 9, 'External 1/Year', 5),
(29, 5, 'HTL-0468', 5),
(30, 7, 'Dickson', 5),
(31, 11, '2024-10-25', 5),
(163, 13, NULL, 4),
(174, 13, NULL, 5);

-- --------------------------------------------------------

--
-- Struktur dari tabel `t_abnormalreports`
--

CREATE TABLE `t_abnormalreports` (
  `reportId` int(11) NOT NULL,
  `abnormalDetail` text DEFAULT NULL,
  `approvalAuthor` varchar(64) DEFAULT NULL,
  `approvalNote` text DEFAULT NULL,
  `cause` text DEFAULT NULL,
  `approvalPIC` varchar(64) DEFAULT NULL,
  `confirmationNote` text DEFAULT NULL,
  `confirmator` varchar(64) DEFAULT NULL,
  `countermeasure` text DEFAULT NULL,
  `findingDate` date DEFAULT NULL,
  `founderAuthor` varchar(64) DEFAULT NULL,
  `founderPIC` varchar(64) DEFAULT NULL,
  `handlingAuthor` varchar(64) DEFAULT NULL,
  `handlingNote` text DEFAULT NULL,
  `handlingOfProduct` text DEFAULT NULL,
  `handlingOfTool` text DEFAULT NULL,
  `handlingPIC` varchar(64) DEFAULT NULL,
  `lastCalibrationDate` date DEFAULT NULL,
  `place` varchar(128) DEFAULT NULL,
  `regNumber` varchar(64) DEFAULT NULL,
  `reportType` varchar(64) DEFAULT NULL,
  `toolId` int(11) NOT NULL,
  `toolName` varchar(64) NOT NULL,
  `userDiv` varchar(64) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data untuk tabel `t_abnormalreports`
--

INSERT INTO `t_abnormalreports` (`reportId`, `abnormalDetail`, `approvalAuthor`, `approvalNote`, `cause`, `approvalPIC`, `confirmationNote`, `confirmator`, `countermeasure`, `findingDate`, `founderAuthor`, `founderPIC`, `handlingAuthor`, `handlingNote`, `handlingOfProduct`, `handlingOfTool`, `handlingPIC`, `lastCalibrationDate`, `place`, `regNumber`, `reportType`, `toolId`, `toolName`, `userDiv`) VALUES
(3, 'tettest', '', '', 'tests', '', '', '', 'test', '2025-04-09', '', 'system', '', '', '', '', '', '2024-10-25', 'Inspection', 'CAL-001', 'Daily Finding', 4, 'Digital Caliper', 'Production'),
(4, 'test', '', '', 'test', '', '', '', 'test', '2025-04-09', '', 'system', '', '', '', '', '', '2024-10-25', 'Hydrolik Press 1', 'SPI-BAL 1', 'Daily Finding', 5, 'Balance Dickson', 'Production');

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
(10, 1, 'Apakah kondisi Outside Jaws tidak berkarat ,tdk lecet , rusak?', 1, '{\"name\":\"matchString\",\"arg\":[\"OK\"]}'),
(11, 9, 'a. Apakah panel masih terbaca?', 1, '{\"name\":\"matchString\",\"arg\":[\"OK\"]}'),
(12, 9, 'b. Apakah panel berfungsi?', 1, '{\"name\":\"matchString\",\"arg\":[\"OK\"]}'),
(13, 10, 'a. Apakah lcd tidak kotor?', 1, '{\"name\":\"matchString\",\"arg\":[\"OK\"]}'),
(14, 10, 'b. Apakah lcd menyala saat power on?', 1, '{\"name\":\"matchString\",\"arg\":[\"OK\"]}'),
(15, 11, 'Apakah meja timbangan tidak kotor?', 1, '{\"name\":\"matchString\",\"arg\":[\"OK\"]}'),
(16, 12, 'Apakah display menunjukkan 0 saat tombol ditekan?', 1, '{\"name\":\"matchString\",\"arg\":[\"OK\"]}'),
(17, 13, 'Letakkan bandul 1Kg (992g) pada timbangan, pastikan perbedaan nilai aktual yang tertera dengan nilai pada bandul adalah normal 1Kg (942～1042g)', 4, '{\"name\":\"numberRange\",\"arg\":[\"942\",\"1042\"]}'),
(18, 14, 'a. Apakah tanggal next kalibrasi pada sticker masih berlaku ?', 1, '{\"name\":\"matchString\",\"arg\":[\"OK\"]}'),
(19, 14, 'b. Apakah sticker kalibrasi ulang masih utuh dan dapat dibaca dengan jelas ?', 1, '{\"name\":\"matchString\",\"arg\":[\"OK\"]}');

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
(4, 'Calibration Standard Accuracy (±）', '校正規格精度 (±）', 1, 'text'),
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
  `instData` varchar(2048) NOT NULL,
  `checker` varchar(255) NOT NULL,
  `checkDate` date NOT NULL,
  `judgement` varchar(32) NOT NULL DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data untuk tabel `t_dailyinspection`
--

INSERT INTO `t_dailyinspection` (`insId`, `toolId`, `instData`, `checker`, `checkDate`, `judgement`) VALUES
(1, 4, 'H4sIAAAAAAAACtXVTW/aQBAG4L8ymkNPVkWBkJRL1SiXFKkc0vbQmMPgHa2XXS/WfrRNEf+9sgEL49JcYtreWFvLO++D1zxusFwrGz7GYskOp/gGE8xyzvS92K/q+w/BKStxivMYvBIMH+i7xwQLDvlaeJw+btAHsoJctW+ToqWCU5ymWFDI8t3+FJMUyckUp48pzmcpLrbNl+wCB826iXxfkqYc9NoK5RUcTwBBCdKwZKfJUYAkCA2GMw6QgIue9DtM0LGPJnx6Kvm3lWZk1NKRV4c7DUY1zDcysdo3n2GCqygkF2zD7sJ2sU1OAYctwGEn7d726Td8lu8o/1TvFTR8f0tv1NIbddLuuAw53JLrwW70rF2T/g/KjVty466c8qWhJ/hsVegBb3wWj6zUBCUJArGfIVoVQFBJAQK7JWUEKzbkL4521UKbdNK+slvD3CmpbA9mV2fNVkoT/KzC13U4CBVYk4WCbbSrqKvPO9gUByl2eS9OOWlRXnfSHjQZgi/srOI+Tu/kLOYtSUUWWgPsnz6hJPtqxVaSBUM2I3dxukGL7uaPaS/Ndt1lo9ewl6ufqjslVSADGRlVsqtObEY2xAJ8UJmurpCVkgzow5wQDVkJ/UImLwNw0wVYNgCHZpZ/hKN6tcuhfUFe5dVfgSEd/4/Ob7uds6bzodfpr7nrGUPMQZBtDlD99t6fn/ol3jPBYrv4BXEvJUm1CgAA', 'system', '2025-04-08', 'OK'),
(2, 5, 'H4sIAAAAAAAACtVWy27TQBT9lau7opKFkjQtTTYINgilahFUYhFncey52BOPx9Z4DISqv8Kf8E38ArKdFFyXCKGmUnf2PO6552HPLK+5LLT1F3UeieM5jzngOJU4e6t4zjMOuvkP3mmb8JzfwYqhohSHSnPAufi0UBXPl9dceVgF12y8Dtkil5DnIefwcdoVCDkIGS4Jeb4M+XIR8urmtkiLOB7fvt9i4jm9KpEhpbJFz1HplLy4CDFecsBOqtr4q00pWwb9nhcwOtr222c74oA/w9TNvssFB7yuVSK5WN8N3AQPxGoyZBXdYRWJ+1TbpNKHZbRqOPX3THqej0cDuPNYkdJVabA5hOXH+yw3sSKvFTLKCl+4p2H3dJ/dDaNc7AYGVAGeyuKLOCrsoxt/3Dd+CPcaBjYWilDJIZw/Geq0FSmXNcjrPIJNYB8vAfeoNO2rNBnAXRV5VBj6Jq44hEinfxVp+002aartus4yWBp1mfJdT0p7yfD4yTrpa3Y8gPsoOkk9tWv+TTTb1n4Pm0hftNl00g6MR83DQL4XQ/nOxaMVK4JVtaHxIqFns9kkOaIS6o/cBVSi8rpZWoqLRAGWrDbQhMzXMLSBTZqjyIsDKWnD2i1oK20BoGCQki1cjh3cdPLzx/em5+TorjvT/3TnbDS6Y8/Fm3vtOe3bsx/vwQN9tu9/72GTBIasfPWU7dro1Ky8jjNx2wtAJM4gq+lpHAmzfUfCjthvvrVpgtURrX2dkoIlhRKelG7uPbuwrcWgOrAGq5vVL1LhEa4pCgAA', 'system', '2025-04-08', 'NG'),
(3, 4, 'H4sIAAAAAAAACtXVTW/aQBAG4L8ymkNPVkWBkJRL1ShSlCLBIW0PxRwG78pedj1Y+9E2Rfz3ygYsjENzwWl783q1fmce79rzDRZrxX4a8qW0OMZ3GGGSyUQ/iP2omn/0VnGKY5wF75SQ8Il+OIwwlz5bC4fj+QadJxZky3WbGJlyGeM4xpx8ku3WxxjFSDaNcTyPcTaJcbGtH7IL7NXjOvJjQZoy0GsWyik4rgC8EqRhKa0mSx4iLzQYmUgPEdjgSH/ACK10wfjPT4V8tqUJGbW05NRhpsYoi/lOJpTrZhOMcBVEKnPJfndju9hGp4D9BmC/lfbAXfr1X+Q7yj/VewM139/SGzT0Bq20O1n4DG7JdmA3eNGuTv8H5YYNuWFbTrnC0BN8YeU7wBuexSNONUFBgkDsawisPAgqyIOXdkkJwUoachdDm96foE3vn0W7aqCNWmnfpF3DzKpUcQdmV2fNVkoT/CrD11U4COWlJoZccuBV0OX1DjbGXoxt3lfff6MG5XUr7VGTIfgqLSvZxekdncW8pVQRQ6OA/e4TKpWuHElOicEQJ2Rfna7XoLv5Y9ql2a7bbPQW9nLVrrpTqfJkICGjCmnLE5sQ+5CD8yrR5R3iNCUD+lAnBEOcQreQ0WUAbtoAyxrg0BnLn/6ovcrl0H1OTmXlr8CQDv9Hz+/bPSd1z4e+Tt/mrs/gQwaCuD5A1dd7f36qj3jHBIvt4jfYl4potQoAAA==', 'system', '2025-04-10', 'NG'),
(4, 5, 'H4sIAAAAAAAACtVW3W7TMBR+laNzxaQItV02aG8Q3Eyo04YAiYulF1/iQ+LGcSLHAcq0V+FNeCZeASVpB1mgmtCKtLvEsc93vh/HvrrmqtTWXzRFLI4XPOWAk0yS/LXiBc856L+/807blBf8BlYMlZU41JoDLsRnpap5cXXNtYdVcO3C64gtCol4EXEBn2R9gYiDiOHSiBdXEV8uI17d3BbpEKfT2/dbTDyllxVyZFR16AVqnZEXFyPBCw7YSd0Y/35TyZbBsOcljI63/Q7ZTjjgTzBNu+5yyQGvG5VKIdb3AzfBA7GajVnFd1jF4j42Nq31YRmtWk7DNbOB59PJCO48UaR0XRlsDmH58T7LTaLIa4Wc8tKX7nHYHe6zu2VUiN3AgGrAU1V+Fkel/e/GHw+NH8O9goFNhGLUcgjnT8Y6bUUqZA3yuohhU9iDJODi7I5KF2d/VCkcqjQbwb0vi7g09FVceQiRTv8q0nZPtmlq7LrJc1ia9JnyfU9Ke8nxcMm6r2YnQ82OR3AfRKeZp27O/USzXe23sKkMRZuHs25gOmkfRvI9G8t3Lh6dWDGsagxNlyk9mc9n6RFVUL/lLqAKtdft1EpcLAqwZLWBJuS+gaENbNoeRV4cSEkX1n5CV2kLAAWDjGzpCuzgwtmP79/antOju+6E/+jOPAzvt/FPh/bsx3vwQD/f97/3sGkKQ1a+eMp3bfRq1l4nubjtBSAWZ5A39DiOhPm+I2FH7BffxrTB6ok2vslIwZJCBU9Kt/eeXdjWYlAfWIPVzeon9A5WUikKAAA=', 'system', '2025-04-10', 'NG'),
(5, 4, 'H4sIAAAAAAAACtXVTW/aQBAG4L8ymkNPVkWBkJRL1ShSlCLBIW0PxRwG78pedj1Y+9E2Rfz3ygYsjENzwWl789pavzOPPfZ8g8VasZ+GfCktjvEdRphkMtEPYr+qrj96qzjFMc6Cd0pI+EQ/HEaYS5+thcPxfIPOEwuy5b5NjEy5jHEcY04+yXb7Y4xiJJvGOJ7HOJvEuNjWN9kF9up1HfmxIE0Z6DUL5RQcVwBeCdKwlFaTJQ+RFxqMTKSHCGxwpD9ghFa6YPznp0I+29KEjFpacupwpcYoi/lOJpT7ZhOMcBVEKnPJfndiu9hGp4D9BmC/lfbAXfr1X+Q7yj/VewM139/SGzT0Bq20O1n4DG7JdmA3eNGuTv8H5YYNuWFbTrnC0BN8YeU7wBuexSNONUFBgkDsawisPAgqyIOXdkkJwUoachdDm96foE3vn0W7aqCNWmnfpF3DzKpUcQdmV2fNVkoT/CrD11U4COWlJoZccuBV0OXxDjbGXoxt3lenHDUor1tpj5oMwVdpWckupnd0FvOWUkUMjQL2b59QqXTlSnJKDIY4Ifvqo9tr0N38Me3SbNdtNnoLe7nqrbpTqfJkICGjCmnLiU2IfcjBeZXo8gxxmpIBfagTgiFOoVvI6DIAN22AZQ1w6IzlT3/UXuVy6D4np7LyV2BIh/+j5/ftnpO650Nfp09z12fwIQNBXA9Q9fXez0/1Ee+YYLFd/AbqI+DftQoAAA==', 'system', '2025-04-09', 'NG'),
(6, 4, 'H4sIAAAAAAAACtXVTW/aQBAG4L8ymkNPVkWBkJRL1ChSlCLBIW0PxRwG78hedr1Y+9E2Rfz3ygYsjENzial683q1fmce79rzDRZrafw05Eu2OMYPGGGScaIexX5UzT95K02KY5wF76Rg+Ew/HUaYs8/WwuF4vkHnyQiy5bpNjIZyjnEcY04+yXbrY4xiJJvGOJ7HOJvEuNjWD9kF9upxHfmpIEUZqLUR0kk4rgC8FKRgyVaRJQ+RFwo0J+whAhscqVuM0LIL2n95LvjFliak5dKSk4eZGqMs5gfpUK6bTTDCVRAp52z87sZ2sY1OAfsNwH4r7dF06dd/le8o/1TvHdR8/0pv0NAbtNLuufAZ3JHtwG7wql2dfkG56cOJ3PThRblhQ27YlpOu0PQMX430HeANz+KRSRVBQYJA7GsIRnoQVJAHz3ZJCcGKNbmLb7erBtqolfad7RpmVqbSdGB2ddZsJRXB7zJ8XYWDkJ4VGcjZBLMKqrzewcbYi7HNe3HKUYPyupX2pEgTfGNrJHdxekdnMe8olWSgUcB+9wmZsitHbFIyoMkkZC9O12vQ3fw17a3Zrtts9B72ctWuupep9KQhIS0LtuWJTcj4kIPzMlHlHTJpShrUoU4ImkwK3UJGbwNw0wZY1gCHzgz/8kftVS6H7nNyMit/BZpU+D96/tjuOal7PvR1+jZ3fQYfMhBk6gNUfb3356f6iHdMsNgu/gCTqKUjtQoAAA==', 'system', '2025-04-03', 'NG'),
(7, 5, 'H4sIAAAAAAAACtVWy27TQBT9lau7opKFkjQpJBsEmwqlahFUYlF3cey52BOPx9Z4DISqv8Kf8E38ArKdFFxDVKGkUnf2PO6552HPXN1wWWjrz+s8EscLHnPAcSpx9lbxguccdPMfvNM24QW/gxVDRSkOleaAc/FpoSpeXN1w5WEVXLPxJmSLXEJehJzDx2lXIOQgZLgk5MVVyBfLkK9v74q0iOPx3fsdJp7T6xIZUipb9ByVTsmLixDjFQfspKqNv1yXsmHQ73kJo6NNv322Iw74M0zd7LtYcsCrWiWSi/XdwG2wJ1aTIavoHqtI3KfaJpU+LKPrhlN/z6Tn+Xg0gDuLFSldlQbrQ1h+vMtyEyvyWiGjrPCFexp2T3fZ3TDKxa5hQBXgqSy+iKPCPrrxx33jh3BvYGBjoQiVHML52VCnjUi5rEBe5xFsAvt4CfiLStO+SpMB3GWRR4Whb+KKQ4h08k+RNt9kk6baruosg6VRlynf9aS0lwyPn6xZX7PjAdxH0UnqqV3zMNFsW/s9bCJ90ebTSTswHjUPA/leDOU7E49WrAhW1YbGy4SezeeT5IhKqD9yF1CJyutmaSkuEgVYstpAEzJfw9AaNmmOIi8OpKQNa7egrbQBgIJBSrZwObZw08nPH9+bnpOj++5M/9Od+Wz0MHtO+vbsxtt7oF/u+t972CSBIStfPWXbNjo1K6/jTNzmAhCJM8hqehpHwnzXkbAl9ptvbZpgdURrX6ekYEmhhCelm3vPNmwrMaj2p8H56T0Nzk+bBF3/Akv+s44pCgAA', 'system', '2025-04-09', 'NG'),
(8, 5, 'H4sIAAAAAAAAClOKjlUCAAUb45EEAAAA', 'system', '2025-04-07', 'NOT USED'),
(9, 5, 'H4sIAAAAAAAAClOKjlUCAAUb45EEAAAA', 'system', '2025-04-02', 'NOT USED'),
(10, 4, 'H4sIAAAAAAAACtXVTW/aQBAG4L8ymkNPVkWBkJRL1ShSlCLBIW0PxRwG78pedj1Y+9E2Rfz3ygYsjENzwWl783q1fmce79rzDRZrxX4a8qW0OMZ3GGGSyUQ/iP2omn/0VnGKY5wF75SQ8Il+OIwwlz5bC4fj+QadJxZky3WbGJlyGeM4xpx8ku3WxxjFSDaNcTyPcTaJcbGtH7IL7NXjOvJjQZoy0GsWyik4rgC8EqRhKa0mSx4iLzQYmUgPEdjgSH/ACK10wfjPT4V8tqUJGbW05NRhpsYoi/lOJpTrZhOMcBVEKnPJfndju9hGp4D9BmC/lfbAXfr1X+Q7yj/VewM139/SGzT0Bq20O1n4DG7JdmA3eNGuTv8H5YYNuWFbTrnC0BN8YeU7wBuexSNONUFBgkDsawisPAgqyIOXdkkJwUoacq+OdtVAG7XSvkm7hplVqeIOzK7Omq2UJvhVhq+rcBDKS00MueTAq6DL6x1sjL0Y27yvTjlqUF630h41GYKv0rKSXZze0VnMW0oVMTQK2O8+oVLpypHklBgMcUL2YnTT+xO66f2zdL0G3c0f0y7Ndt1mo7ewl6t21Z1KlScDCRlVSFue2ITYhxycV4ku7xCnKRnQhzohGOIUut2D0WUAbtoAyxrg0BnLn/6ovcrl0H1OTmXlr8CQDv9Hz+/bPSd1z4e+Tt/mrs/gQwaCuD5A1dd7f36qj3jHBIvt4jcGz176tQoAAA==', 'system', '2025-04-12', 'NG'),
(11, 5, 'H4sIAAAAAAAACtVWy27TQBT9lau7opKFktQtJBsEO5SKIqjEos7i2HOxJx6PrfEYCFV/hT/hm/iFynZScA1RhZpK3dnzuOeehz1zecVVqa1/1xSxOF7wlANOMknyt4oXPOegn//onbYpL/g9rBgqK3GoNQdciM9KVfPi8oprD6vg2o1XEVsUEvEi4gI+yfoCEQcRw6URLy4jPl9GvLq+LdIhTqe377eYeE6vK+TIqOrQC9Q6Iy8uRoJXHLCTujH+YlPJlsGw5yWMjrf9DtlOOOAvME2773zJAa8blUoh1vcD18EDsZqNWcV3WMXiPjc2rfVhGa1aTsM9s4Hn08kI7ixRpHRdGWwOYfnxPstNoshrhZzy0pfuadgd7rO7ZVSI3cCAasBTVX4VR6V9dOOPh8aP4d7AwCZCMWo5hPMnY522IhWyBnldxLAp7OMl4C8qhUOVZiO4i7KIS0PfxZWHEOn0nyJtv8k2TY1dN3kOS5M+U77vSWkvOR4/WSdDzY5HcJ9Ep5mnbs39RLNd7Q+wqQxFm4ezbmA6aR9G8r0Yy3cmHp1YMaxqDE2XKT2bz2fpEVVQf+QuoAq11+3SSlwsCrBktYEm5L6BoQ1s2h5FXhxISRfWfkFXaQsABYOMbOkK7ODC2a+fP9qe06O77oT/6c48DO9nz+nQnv14Dx7ol/v+9x42TWHIyjdP+a6NXs3a6yQXt70AxOIM8oaexpEw33ck7Ij95tuYNlg90cY3GSlYUqjgSen23rML21oM6gNrsLpe3QDzuBdKKQoAAA==', 'system', '2025-04-14', 'OK'),
(12, 5, 'H4sIAAAAAAAACtVWy27TQBT9lau7opKFEjctJBsEO5SKIqjEos7i2HOxJx6PrfEYCFV/hT/hm/iFynZScA1RhZpK3dnzuOeehz1zecVVqa1/1xSxOF7wlANOMknyt4oXPOegn//onbYpL/g9rBgqK3GoNQdciM9KVfPi8oprD6vg2o1XEVsUEvEi4gI+yfoCEQcRw6URLy4jPl9GvLq+LdIhTqe377eYeE6vK+TIqOrQC9Q6Iy8uRoJXHLCTujH+YlPJlsGw5yWMjrf9DtlOOOAvME2773zJAa8blUoh1vcD18EDsQrHrOI7rGJxnxub1vqwjFYtp+GecOD5dDKCO0sUKV1XBptDWH68z3KTKPJaIae89KV7GnbP9tndMirEbmBANeCpKr+Ko9I+uvHHQ+PHcG9gYBOhGLUcwvmTsU5bkQpZg7wuYtgU9vES8BeVZkOVwhHcRVnEpaHv4spDiHT6T5G232SbpsaumzyHpUmfKd/3pLSXHI+frJOhZscjuE+i08xTt+Z+otmu9gfYVIaizWdhNzCdtA8j+V6M5TsTj06sGFY1hqbLlJ7N52F6RBXUH7kLqELtdbu0EheLAixZbaAJuW9gaAObtkeRFwdS0oW1X9BV2gJAwSAjW7oCO7hZ+Ovnj7bn9OiuO7P/dGd+Et7PntOhPfvxHjzQL/f97z1smsKQlW+e8l0bvZq110kubnsBiMUZ5A09jSNhvu9I2BH7zbcxbbB6oo1vMlKwpFDBk9LtvWcXtrUY1AfWYHW9ugH8dc0fKQoAAA==', 'system', '2025-04-12', 'OK'),
(13, 4, 'H4sIAAAAAAAACtXVTW/aQBAG4L8ymkNPVkWBkJRL1SiXFKkc0vbQmMPgHa2XXS/WfrRNEf+9sgEL49JcYtreWFvLO++D1zxusFwrGz7GYskOp/gGE8xyzvS92K/q+w/BKStxivMYvBIMH+i7xwQLDvlaeJw+btAHsoJctW+ToqWCU5ymWFDI8t3+FJMUyckUp48pzmcpLrbNl+wCB826iXxfkqYc9NoK5RUcTwBBCdKwZKfJUYAkCA2GMw6QgIue9DtM0LGPJnx6Kvm3lWZk1NKRV4c7DUY1zDcysdo3n2GCqygkF2zD7sJ2sU1OAYctwGEn7d726Td8lu8o/1TvFTR8f0tv1NIbddLuuAw53JLrwW70rF2T/g/KjVty466c8qWhJ/hsVegBb3wWj6zUBCUJArGfIVoVQFBJAQK7JWUEKzbkL4521UKbdNK+slvD3CmpbA9mV2fNVkoT/KzC13U4CBVYk4WCbbSrqKvPO9gUByl2eS9OOWlRXnfSHjQZgi/srOI+Tu/kLOYtSUUWWgPsnz6hJPtqxVaSBUM2I3dxukGL7uaPaS/Ndt1lo9ewl6ufqjslVSADGRlVsqtObEY2xAJ8UJmurpCVkgzow5wQDVkJ/UImLwNw0wVYNgCHZpZ/hKN6tcuhfUFe5dVfgSEd/4/Ob7uds6bzodfpr7nrGUPMQZBtDlD99t6fn/ol3jPBYrv4BXEvJUm1CgAA', 'system', '2025-02-12', 'OK'),
(14, 5, 'H4sIAAAAAAAAClOKjlUCAAUb45EEAAAA', 'system', '2025-02-12', 'NOT USED'),
(15, 4, 'H4sIAAAAAAAACtXVTW/aQBAG4L8ymkNPVkWBkJRL1SiXFKkc0vbQmMPgHa2XXS/WfrRNEf+9sgEL49JcYtreWFvLO++D1zxusFwrGz7GYskOp/gGE8xyzvS92K/q+w/BKStxivMYvBIMH+i7xwQLDvlaeJw+btAHsoJctW+ToqWCU5ymWFDI8t3+FJMUyckUp48pzmcpLrbNl+wCB826iXxfkqYc9NoK5RUcTwBBCdKwZKfJUYAkCA2GMw6QgIue9DtM0LGPJnx6Kvm3lWZk1NKRV4c7DUY1zDcysdo3n2GCqygkF2zD7sJ2sU1OAYctwGEn7d726Td8lu8o/1TvFTR8f0tv1NIbddLuuAw53JLrwW70rF2T/g/KjVty466c8qWhJ/hsVegBb3wWj6zUBCUJArGfIVoVQFBJAQK7JWUEKzbkL4521UKbdNK+slvD3CmpbA9mV2fNVkoT/KzC13U4CBVYk4WCbbSrqKvPO9gUByl2eS9OOWlRXnfSHjQZgi/srOI+Tu/kLOYtSUUWWgPsnz6hJPtqxVaSBUM2I3dxukGL7uaPaS/Ndt1lo9ewl6ufqjslVSADGRlVsqtObEY2xAJ8UJmurpCVkgzow5wQDVkJ/UImLwNw0wVYNgCHZpZ/hKN6tcuhfUFe5dVfgSEd/4/Ob7uds6bzodfpr7nrGUPMQZBtDlD99t6fn/ol3jPBYrv4BXEvJUm1CgAA', 'system', '2025-05-11', 'OK'),
(16, 4, 'H4sIAAAAAAAACtXVTW/aQBAG4L8ymkNPVkWBkJRL1SiXFKkc0vbQmMPgHa2XXS/WfrRNEf+9sgEL49JcYtreWFvLO++D1zxusFwrGz7GYskOp/gGE8xyzvS92K/q+w/BKStxivMYvBIMH+i7xwQLDvlaeJw+btAHsoJctW+ToqWCU5ymWFDI8t3+FJMUyckUp48pzmcpLrbNl+wCB826iXxfkqYc9NoK5RUcTwBBCdKwZKfJUYAkCA2GMw6QgIue9DtM0LGPJnx6Kvm3lWZk1NKRV4c7DUY1zDcysdo3n2GCqygkF2zD7sJ2sU1OAYctwGEn7d726Td8lu8o/1TvFTR8f0tv1NIbddLuuAw53JLrwW70rF2T/g/KjVty466c8qWhJ/hsVegBb3wWj6zUBCUJArGfIVoVQFBJAQK7JWUEKzbkL4521UKbdNK+slvD3CmpbA9mV2fNVkoT/KzC13U4CBVYk4WCbbSrqKvPO9gUByl2eS9OOWlRXnfSHjQZgi/srOI+Tu/kLOYtSUUWWgPsnz6hJPtqxVaSBUM2I3dxukGL7uaPaS/Ndt1lo9ewl6ufqjslVSADGRlVsqtObEY2xAJ8UJmurpCVkgzow5wQDVkJ/UImLwNw0wVYNgCHZpZ/hKN6tcuhfUFe5dVfgSEd/4/Ob7uds6bzodfpr7nrGUPMQZBtDlD99t6fn/ol3jPBYrv4BXEvJUm1CgAA', 'system', '2025-06-12', 'OK'),
(17, 5, 'H4sIAAAAAAAAClOKjlUCAAUb45EEAAAA', 'system', '2025-06-12', 'NOT USED'),
(18, 4, 'H4sIAAAAAAAACtXVTW/aQBAG4L8ymkNPVkWBkJRL1ChSlCLBIW0PxRwG78hedr1Y+9E2jfjvlQ1YGIemB4zUm9er9TvzeNeev2CxlsZPQ75ki2P8gBEmGSfqUexG1fyTt9KkOMZZ8E4Khs/002GEOftsLRyO5y/oPBlBtlz3EqOhnGMcx5iTT7Lt+hijGMmmMY7nMc4mMS429UO2gb16XEd+KkhRBmpthHQSDisALwUpWLJVZMlD5IUCzQl7iMAGR+oWI7TsgvZfngt+taUJabm05OR+psYoi/lBOpTrZhOMcBVEyjkbv72xWWyiY8B+A7DfSns0Xfr13+Q7yD/Wewc137n1pg9HetOHV/UGDb1BK+2eC5/BHdkO7AZv2tXpF5T71303bMgN23LSFZqe4auRvgO84Uk8MqkiKEgQiF0NwUgPggry4NkuKSFYsSZ3cbSrBtqolfad7RpmVqbSdGB2ddJsJRXB7zJ8XYWDkJ4VGcjZBLMKqrzewsbYi7HNe3HKUYPyupX2pEgTfGNrJHdxekcnMe8olWSgUcBu9wmZsitHbFIyoMkkZC9O12vQ3fw17dxs1202eg87uWpX3ctUetKQkJYF2/LEJmR8yMF5majyDpk0JQ1qXycETSaFbiGj8wDctAGWNcC+M8O//EF7lcu++5yczMpfgSYV/o+eP7Z7Tuqe930dv81tn8GHDASZ+gBVX+/d+ak+4h0TLDaLP1MwnOe1CgAA', 'system', '2025-06-11', 'NG');

-- --------------------------------------------------------

--
-- Struktur dari tabel `t_monthlyinspection`
--

CREATE TABLE `t_monthlyinspection` (
  `insId` int(11) NOT NULL,
  `toolId` int(11) NOT NULL,
  `month` varchar(8) NOT NULL,
  `checkerId` varchar(64) NOT NULL,
  `checkDate` date NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data untuk tabel `t_monthlyinspection`
--

INSERT INTO `t_monthlyinspection` (`insId`, `toolId`, `month`, `checkerId`, `checkDate`) VALUES
(1, 5, '2025-04', 'system', '2025-04-12'),
(3, 4, '2025-04', 'system', '2025-04-12'),
(4, 4, '2025-02', 'system', '2025-04-12'),
(5, 5, '2025-02', 'system', '2025-04-12'),
(6, 4, '2025-05', 'system', '2025-05-11'),
(7, 5, '2025-05', 'system', '2025-05-11'),
(8, 4, '2025-06', 'system', '2025-06-12');

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
(8, 4, 'Kalibrasi', 0),
(9, 5, 'Panel operasi', 1),
(10, 5, 'Lcd display', 2),
(11, 5, 'Balance base', 3),
(12, 5, 'Tombol zero', 4),
(13, 5, 'Weight check', 5),
(14, 5, 'Kalibrasi', 6);

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
(1, 'administrator', '/home/list'),
(5, 'Operator', '/home/daily'),
(6, 'SPV', '/home/weekly'),
(7, 'MANAGER', '/home/monthly');

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
(4, 'Digital Caliper', 16, 14, 0, 'CAL-001'),
(5, 'Balance Dickson', 17, 14, 0, 'SPI-BAL 1');

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
(16, 'Scale dimention'),
(17, 'Scale Weight');

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
  `lastIP` varchar(255) DEFAULT NULL,
  `divId` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data untuk tabel `t_user`
--

INSERT INTO `t_user` (`userId`, `userName`, `roleId`, `userPassword`, `active`, `lastLogin`, `lastIP`, `divId`) VALUES
('MIIT-001', 'Adnan', 1, 'U2FsdGVkX18rlrA1wjilQj3V7EJ5nzscN5dsCMWZDjs=', 1, '2025-03-28 05:47:28', '192.168.1.188', 1),
('system', 'MIIT DEVELOPER', 1, 'U2FsdGVkX1/rkR8/1pL6MUJvxfVtSk7Nd+lC8x3y08s=', 1, '2025-05-16 14:11:10', '192.168.1.188', 1),
('trial', 'trial', 6, 'U2FsdGVkX1+pzOfSqHxn5Qzg+ZWYgSb0dKctjQUcdrw=', 1, '2025-05-16 13:59:50', '192.168.1.188', 2);

-- --------------------------------------------------------

--
-- Struktur dari tabel `t_weeklyinspection`
--

CREATE TABLE `t_weeklyinspection` (
  `inspectionId` int(11) NOT NULL,
  `weekCode` varchar(64) NOT NULL,
  `toolId` int(11) NOT NULL,
  `checkerID` varchar(255) NOT NULL,
  `signDate` date NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data untuk tabel `t_weeklyinspection`
--

INSERT INTO `t_weeklyinspection` (`inspectionId`, `weekCode`, `toolId`, `checkerID`, `signDate`) VALUES
(1, '2025-W15', 4, 'system', '0000-00-00'),
(2, '2025-W15', 5, 'system', '0000-00-00'),
(4, '2025-W14', 5, 'system', '0000-00-00'),
(5, '2025-W16', 5, 'system', '0000-00-00'),
(6, '2025-W07', 4, 'system', '0000-00-00'),
(7, '2025-W07', 5, 'system', '0000-00-00'),
(8, '2025-W19', 4, 'system', '0000-00-00'),
(9, '2025-W24', 4, 'system', '0000-00-00'),
(10, '2025-W24', 5, 'system', '0000-00-00');

--
-- Indexes for dumped tables
--

--
-- Indeks untuk tabel `config`
--
ALTER TABLE `config`
  ADD PRIMARY KEY (`configKey`);

--
-- Indeks untuk tabel `division`
--
ALTER TABLE `division`
  ADD PRIMARY KEY (`divId`);

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
-- Indeks untuk tabel `t_abnormalreports`
--
ALTER TABLE `t_abnormalreports`
  ADD PRIMARY KEY (`reportId`);

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
-- Indeks untuk tabel `t_monthlyinspection`
--
ALTER TABLE `t_monthlyinspection`
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
-- Indeks untuk tabel `t_weeklyinspection`
--
ALTER TABLE `t_weeklyinspection`
  ADD PRIMARY KEY (`inspectionId`);

--
-- AUTO_INCREMENT untuk tabel yang dibuang
--

--
-- AUTO_INCREMENT untuk tabel `division`
--
ALTER TABLE `division`
  MODIFY `divId` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT untuk tabel `resulttype`
--
ALTER TABLE `resulttype`
  MODIFY `typeId` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT untuk tabel `tooldata`
--
ALTER TABLE `tooldata`
  MODIFY `dataId` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=175;

--
-- AUTO_INCREMENT untuk tabel `t_abnormalreports`
--
ALTER TABLE `t_abnormalreports`
  MODIFY `reportId` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT untuk tabel `t_checkmethod`
--
ALTER TABLE `t_checkmethod`
  MODIFY `methodId` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=20;

--
-- AUTO_INCREMENT untuk tabel `t_collumns`
--
ALTER TABLE `t_collumns`
  MODIFY `collumnId` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=14;

--
-- AUTO_INCREMENT untuk tabel `t_dailyinspection`
--
ALTER TABLE `t_dailyinspection`
  MODIFY `insId` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=19;

--
-- AUTO_INCREMENT untuk tabel `t_monthlyinspection`
--
ALTER TABLE `t_monthlyinspection`
  MODIFY `insId` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- AUTO_INCREMENT untuk tabel `t_pointcheck`
--
ALTER TABLE `t_pointcheck`
  MODIFY `checkId` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=16;

--
-- AUTO_INCREMENT untuk tabel `t_rank`
--
ALTER TABLE `t_rank`
  MODIFY `rankId` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=17;

--
-- AUTO_INCREMENT untuk tabel `t_roles`
--
ALTER TABLE `t_roles`
  MODIFY `roleId` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT untuk tabel `t_tools`
--
ALTER TABLE `t_tools`
  MODIFY `toolId` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT untuk tabel `t_tooltype`
--
ALTER TABLE `t_tooltype`
  MODIFY `typeId` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=18;

--
-- AUTO_INCREMENT untuk tabel `t_weeklyinspection`
--
ALTER TABLE `t_weeklyinspection`
  MODIFY `inspectionId` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

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
