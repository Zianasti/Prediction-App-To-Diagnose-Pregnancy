-- phpMyAdmin SQL Dump
-- version 5.2.0
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Waktu pembuatan: 04 Feb 2023 pada 10.55
-- Versi server: 10.4.27-MariaDB
-- Versi PHP: 8.2.0

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `intelli3_clinics`
--

-- --------------------------------------------------------

--
-- Struktur dari tabel `categories`
--

CREATE TABLE `categories` (
  `cid` int(11) NOT NULL,
  `service` varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data untuk tabel `categories`
--

INSERT INTO `categories` (`cid`, `service`) VALUES
(1, 'VIP'),
(2, 'Umum'),
(3, 'BPJS'),
(4, 'Khusus');

-- --------------------------------------------------------

--
-- Struktur dari tabel `doctor`
--

CREATE TABLE `doctor` (
  `did` int(11) NOT NULL,
  `nip` varchar(20) NOT NULL,
  `dname` varchar(50) NOT NULL,
  `dob` date NOT NULL,
  `gender` varchar(50) NOT NULL,
  `medical_specialty` varchar(50) NOT NULL,
  `email` varchar(50) NOT NULL,
  `number` varchar(12) NOT NULL,
  `address` text NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data untuk tabel `doctor`
--

INSERT INTO `doctor` (`did`, `nip`, `dname`, `dob`, `gender`, `medical_specialty`, `email`, `number`, `address`) VALUES
(6, '1271973248348', 'Fahmi', '2023-01-12', 'male', 'S3', 'mfahmipamungkas123@gmail.com', '081234567893', 'Medan');

-- --------------------------------------------------------

--
-- Struktur dari tabel `information`
--

CREATE TABLE `information` (
  `fid` int(11) NOT NULL,
  `result` int(11) NOT NULL,
  `desc` varchar(2000) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data untuk tabel `information`
--

INSERT INTO `information` (`fid`, `result`, `desc`) VALUES
(1, 1, 'Resiko kehamilan rendah dapat dijelaskan melalui faktor tekanan darah, gula darah, detak jantung, dan temperatur tubuh yang stabil. Tekanan darah yang normal dapat menghindari komplikasi seperti pre-eklampsia dan eklampsia yang dapat menyebabkan kerusakan pada otak dan ginjal bayi. Gula darah yang normal dapat mencegah komplikasi seperti diabetes gestasional yang dapat menyebabkan komplikasi pada bayi dan ibu. Detak jantung yang normal dapat memastikan bahwa bayi mendapatkan oksigen yang cukup. Temperatur tubuh yang normal dapat menjamin kondisi kesehatan yang baik bagi ibu dan bayi. Oleh karena itu, sangat penting untuk menjaga kondisi kesehatan secara stabil selama kehamilan.'),
(2, 2, 'Resiko kehamilan sedang dapat diterangkan melalui faktor tekanan darah, gula darah, detak jantung, dan temperatur tubuh yang tidak stabil. Peningkatan tekanan darah pada trimester kehamilan yang dikenal sebagai pre-eklampsia dapat menyebabkan komplikasi seperti kerusakan ginjal dan otak pada bayi. Gula darah yang tidak stabil dapat menyebabkan diabetes gestasional yang dapat menyebabkan komplikasi pada bayi dan ibu. Detak jantung yang tidak stabil dapat menyebabkan kurangnya oksigen yang diterima oleh bayi. Temperatur tubuh yang tidak stabil dapat menyebabkan kondisi kesehatan yang buruk bagi ibu dan bayi. Oleh karena itu, sangat penting untuk melakukan pemeriksaan dan pemantauan kondisi kesehatan secara rutin selama kehamilan.'),
(3, 3, 'Resiko kehamilan yang tinggi dapat disebabkan oleh beberapa faktor, salah satunya adalah masalah kesehatan yang meliputi gula darah, tekanan darah, detak jantung, dan temperatur tubuh yang tidak stabil. Gula darah yang tidak stabil dapat menyebabkan masalah seperti diabetes gestasional yang dapat meningkatkan resiko keguguran atau kelahiran prematur. Tekanan darah yang tinggi dapat menyebabkan preeclampsia yang dapat menyebabkan masalah seperti kerusakan ginjal, pendarahan, atau stroke pada ibu. Detak jantung yang tidak stabil dapat menyebabkan masalah seperti keguguran atau kelahiran prematur. Temperatur tubuh yang tidak stabil dapat menyebabkan masalah seperti infeksi yang dapat menyebabkan keguguran atau kelahiran prematur. ');

-- --------------------------------------------------------

--
-- Struktur dari tabel `patient`
--

CREATE TABLE `patient` (
  `id` int(11) NOT NULL,
  `nik` varchar(20) NOT NULL,
  `pname` varchar(50) NOT NULL,
  `dob` date NOT NULL,
  `gender` varchar(50) NOT NULL,
  `service` varchar(50) NOT NULL,
  `email` varchar(50) NOT NULL,
  `number` varchar(12) NOT NULL,
  `address` text NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data untuk tabel `patient`
--

INSERT INTO `patient` (`id`, `nik`, `pname`, `dob`, `gender`, `service`, `email`, `number`, `address`) VALUES
(4, '1271085406032789', 'Fahira', '2003-06-14', 'female', 'VIP', 'fahira1678@gmail.com', '085262774378', 'bandung');

--
-- Trigger `patient`
--
DELIMITER $$
CREATE TRIGGER `DELETE` BEFORE DELETE ON `patient` FOR EACH ROW INSERT INTO trig VALUES(null,OLD.nik,'PATIENT DELETED',NOW())
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `INSERT` AFTER INSERT ON `patient` FOR EACH ROW INSERT INTO trig VALUES(null,NEW.nik,'PATIENT INSERTED',NOW())
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `UPDATE` AFTER UPDATE ON `patient` FOR EACH ROW INSERT INTO trig VALUES(null,NEW.nik,'PATIENT UPDATED',NOW())
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Struktur dari tabel `prediction`
--

CREATE TABLE `prediction` (
  `pid` int(11) NOT NULL,
  `nik` varchar(20) NOT NULL,
  `age` int(11) NOT NULL,
  `sistole` int(11) NOT NULL,
  `diastole` int(11) NOT NULL,
  `bs` decimal(4,2) NOT NULL,
  `bod_temp` decimal(4,1) NOT NULL,
  `heart_rate` int(11) NOT NULL,
  `result` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data untuk tabel `prediction`
--

INSERT INTO `prediction` (`pid`, `nik`, `age`, `sistole`, `diastole`, `bs`, `bod_temp`, `heart_rate`, `result`) VALUES
(24, '1271678656789876', 22, 120, 75, '11.00', '88.0', 98, 3),
(25, '1271678656789876', 25, 120, 60, '9.00', '75.0', 98, 2),
(34, '1271678656789876', 25, 120, 60, '6.00', '98.0', 80, 1),
(35, '1271085406032789', 24, 120, 60, '7.00', '75.1', 99, 2),
(36, '1271085406032789', 20, 120, 78, '6.00', '96.0', 75, 1),
(37, '1271085406032789', 20, 120, 78, '6.00', '96.0', 75, 1),
(38, '1271085406032789', 1, 1, 1, '1.00', '1.0', 1, 1);

-- --------------------------------------------------------

--
-- Struktur dari tabel `prediction_user`
--

CREATE TABLE `prediction_user` (
  `pid` int(11) NOT NULL DEFAULT 0,
  `email` varchar(50) NOT NULL,
  `age` int(11) NOT NULL,
  `sistole` int(11) NOT NULL,
  `diastole` int(11) NOT NULL,
  `bs` decimal(4,2) NOT NULL,
  `bod_temp` decimal(4,1) NOT NULL,
  `heart_rate` int(11) NOT NULL,
  `result` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data untuk tabel `prediction_user`
--

INSERT INTO `prediction_user` (`pid`, `email`, `age`, `sistole`, `diastole`, `bs`, `bod_temp`, `heart_rate`, `result`) VALUES
(24, '1271678656789876', 22, 120, 75, '11.00', '88.0', 98, 3),
(25, '1271678656789876', 25, 120, 60, '9.00', '75.0', 98, 2),
(34, '1271678656789876', 25, 120, 60, '6.00', '98.0', 80, 1),
(35, '1271085406032789', 24, 120, 60, '7.00', '75.1', 99, 2),
(36, '1271085406032789', 20, 120, 78, '6.00', '96.0', 75, 1),
(37, '1271085406032789', 20, 120, 78, '6.00', '96.0', 75, 1),
(38, '1271085406032789', 1, 1, 1, '1.00', '1.0', 1, 1),
(0, 'fahira1678@gmail.com', 11, 1, 11, '1.00', '1.0', 1, 1),
(0, 'fahira1678@gmail.com', 11, 1, 11, '1.00', '1.0', 1, 1),
(0, 'fahira1678@gmail.com', 35, 100, 80, '99.99', '38.0', 60, 3),
(0, 'fahira1678@gmail.com', 16, 100, 80, '5.56', '38.0', 80, 1),
(0, 'fahira1678@gmail.com', 16, 100, 80, '5.56', '38.0', 80, 1),
(0, 'fahira1678@gmail.com', 16, 100, 80, '5.56', '38.0', 80, 1),
(0, 'fahira1678@gmail.com', 16, 100, 80, '5.56', '35.0', 100, 2);

-- --------------------------------------------------------

--
-- Struktur dari tabel `recommendation`
--

CREATE TABLE `recommendation` (
  `rid` int(11) NOT NULL,
  `result` int(11) NOT NULL,
  `saran` varchar(2000) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data untuk tabel `recommendation`
--

INSERT INTO `recommendation` (`rid`, `result`, `saran`) VALUES
(1, 1, 'Untuk menjaga resiko kehamilan rendah, beberapa saran yang dapat dilakukan adalah menjaga kondisi kesehatan secara stabil selama kehamilan. Salah satu cara untuk mencapai ini adalah dengan mengatur pola makan yang sehat dan teratur, melakukan aktivitas fisik yang sesuai dengan kondisi kesehatan dan rekomendasi dokter, menghindari merokok dan minum alkohol, menjaga berat badan dalam batas normal dan menjaga kondisi kesehatan mental yang baik dengan cara beristirahat cukup, tidak terlalu stress dan jangan lupa untuk bermeditasi. Selain itu, sangat penting untuk melakukan kontrol rutin ke dokter untuk memantau kondisi kesehatan selama kehamilan. Menghindari faktor risiko yang dapat menyebabkan komplikasi selama kehamilan seperti merokok, minum alkohol, dan mengonsumsi obat-obatan yang tidak direkomendasikan oleh dokter juga sangat penting. Menjaga kondisi kesehatan mental yang baik dengan cara menjaga stres dalam batas normal juga penting untuk kondisi kesehatan yang baik bagi ibu dan bayi.'),
(2, 2, 'Untuk mengurangi resiko kehamilan sedang, beberapa saran yang dapat dilakukan adalah melakukan pemeriksaan kesehatan secara rutin dan segera melaporkan setiap perubahan pada kondisi kesehatan kepada dokter. Mengatur pola makan yang sehat dan teratur, melakukan aktivitas fisik yang sesuai dengan kondisi kesehatan dan rekomendasi dokter, menghindari merokok dan minum alkohol, menjaga berat badan dalam batas normal. Selain itu, menjaga kondisi kesehatan mental yang baik dengan cara beristirahat cukup, tidak terlalu stress dan jangan lupa untuk bermeditasi. Hal lain yang perlu diperhatikan adalah menghindari faktor risiko lain yang dapat meningkatkan risiko kehamilan sedang seperti paparan terhadap bahan kimia dan radiasi.'),
(3, 3, 'Untuk mengurangi resiko kehamilan yang tinggi karena masalah kesehatan seperti gula darah, tekanan darah, detak jantung, dan temperatur tubuh yang tidak stabil, ada beberapa saran yang dapat dilakukan. Pertama, selalu jaga kesehatan dengan melakukan olahraga secara teratur dan menjaga pola makan yang sehat. Kedua, rutin memantau gula darah, tekanan darah, detak jantung dan temperatur tubuh. Ketiga, jangan merokok dan hindari minuman beralkohol. Keempat, konsultasikan dengan dokter kandungan dan jangan ragu untuk mengikuti rekomendasi dan saran dari dokter untuk menjaga kesehatan selama kehamilan. Kelima, jangan lupa untuk melakukan pemeriksaan prenatal secara teratur dan mengikuti terapi jika diperlukan.');

-- --------------------------------------------------------

--
-- Struktur dari tabel `schedule_doctor`
--

CREATE TABLE `schedule_doctor` (
  `sid` int(11) NOT NULL,
  `day` date NOT NULL,
  `start_time` time NOT NULL,
  `end_time` time NOT NULL,
  `nip` varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data untuk tabel `schedule_doctor`
--

INSERT INTO `schedule_doctor` (`sid`, `day`, `start_time`, `end_time`, `nip`) VALUES
(1, '2023-01-12', '11:20:00', '01:20:00', '127108456782'),
(2, '2023-01-16', '08:00:00', '17:00:00', '127108456782'),
(3, '2023-01-17', '08:00:00', '17:00:00', '127108456782'),
(4, '2023-01-04', '18:54:00', '18:55:00', '127108456782'),
(5, '2023-01-04', '18:54:00', '18:55:00', '127108456782'),
(6, '2023-01-03', '19:05:00', '19:04:00', '127108456782');

-- --------------------------------------------------------

--
-- Struktur dari tabel `train`
--

CREATE TABLE `train` (
  `Age` int(11) NOT NULL,
  `SystolicBP` int(11) NOT NULL,
  `DiastolicBP` int(11) NOT NULL,
  `BS` decimal(4,2) NOT NULL,
  `BodyTemp` decimal(4,1) NOT NULL,
  `HeartRate` int(11) NOT NULL,
  `RiskLevel` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data untuk tabel `train`
--

INSERT INTO `train` (`Age`, `SystolicBP`, `DiastolicBP`, `BS`, `BodyTemp`, `HeartRate`, `RiskLevel`) VALUES
(25, 130, 80, '15.00', '98.0', 86, 3),
(35, 140, 90, '13.00', '98.0', 70, 3),
(29, 90, 70, '8.00', '100.0', 80, 3),
(30, 140, 85, '7.00', '98.0', 70, 3),
(35, 120, 60, '6.10', '98.0', 76, 1),
(23, 140, 80, '7.01', '98.0', 70, 3),
(23, 130, 70, '7.01', '98.0', 78, 2),
(35, 85, 60, '11.00', '102.0', 86, 3),
(32, 120, 90, '6.90', '98.0', 70, 2),
(42, 130, 80, '18.00', '98.0', 70, 3),
(23, 90, 60, '7.01', '98.0', 76, 1),
(19, 120, 80, '7.00', '98.0', 70, 2),
(25, 110, 89, '7.01', '98.0', 77, 1),
(20, 120, 75, '7.01', '100.0', 70, 2),
(48, 120, 80, '11.00', '98.0', 88, 2),
(16, 120, 80, '7.01', '98.0', 70, 1),
(50, 140, 90, '15.00', '98.0', 90, 3),
(25, 140, 100, '7.01', '98.0', 80, 3),
(30, 120, 80, '6.90', '101.0', 76, 2),
(16, 70, 50, '6.90', '98.0', 70, 1),
(40, 140, 100, '18.00', '98.0', 90, 3),
(50, 140, 80, '6.70', '98.0', 70, 2),
(21, 90, 65, '7.50', '98.0', 76, 1),
(18, 90, 60, '7.50', '98.0', 70, 1),
(21, 120, 80, '7.50', '98.0', 76, 1),
(16, 100, 70, '7.20', '98.0', 80, 1),
(19, 120, 75, '7.20', '98.0', 66, 1),
(22, 100, 65, '7.20', '98.0', 70, 1),
(49, 120, 90, '7.20', '98.0', 77, 1),
(28, 90, 60, '7.20', '98.0', 82, 1),
(20, 100, 90, '7.10', '98.0', 88, 1),
(23, 100, 85, '7.10', '98.0', 66, 1),
(22, 120, 90, '7.10', '98.0', 82, 1),
(21, 120, 80, '7.10', '98.0', 77, 1),
(21, 75, 50, '6.10', '98.0', 70, 1),
(16, 95, 60, '6.10', '102.0', 60, 1),
(60, 120, 80, '6.10', '98.0', 75, 1),
(55, 100, 65, '6.10', '98.0', 66, 1),
(45, 120, 95, '6.10', '98.0', 66, 1),
(35, 100, 70, '6.10', '98.0', 66, 1),
(22, 120, 85, '6.10', '98.0', 88, 1),
(23, 120, 90, '6.10', '98.0', 60, 1),
(25, 90, 70, '6.10', '98.0', 80, 1),
(30, 120, 80, '6.10', '98.0', 70, 1),
(23, 120, 90, '6.10', '98.0', 70, 1),
(32, 120, 90, '7.50', '98.0', 70, 1),
(42, 120, 80, '7.50', '98.0', 70, 1),
(23, 90, 60, '7.50', '98.0', 76, 1),
(16, 76, 49, '7.50', '98.0', 77, 1),
(16, 120, 80, '7.00', '98.0', 70, 1),
(25, 120, 80, '7.00', '98.0', 66, 1),
(22, 100, 65, '7.00', '98.0', 80, 1),
(35, 100, 70, '7.00', '98.0', 60, 1),
(19, 120, 85, '7.00', '98.0', 60, 1),
(60, 90, 65, '7.00', '98.0', 77, 1),
(23, 120, 90, '6.70', '98.0', 70, 1),
(32, 120, 90, '6.40', '98.0', 70, 1),
(42, 120, 80, '6.40', '98.0', 70, 1),
(23, 90, 60, '6.40', '98.0', 76, 1),
(16, 76, 49, '6.40', '98.0', 77, 1),
(16, 120, 80, '7.20', '98.0', 70, 1),
(16, 80, 60, '7.00', '98.0', 80, 1),
(16, 95, 60, '7.20', '98.0', 77, 1),
(29, 90, 70, '6.70', '98.0', 80, 2),
(31, 120, 60, '6.10', '98.0', 76, 2),
(29, 130, 70, '6.70', '98.0', 78, 2),
(17, 85, 60, '9.00', '102.0', 86, 2),
(20, 110, 60, '7.00', '100.0', 70, 2),
(32, 120, 65, '6.00', '101.0', 76, 2),
(26, 85, 60, '6.00', '101.0', 86, 2),
(29, 130, 70, '7.70', '98.0', 78, 2),
(54, 130, 70, '12.00', '98.0', 67, 2),
(44, 120, 90, '16.00', '98.0', 80, 2),
(23, 130, 70, '6.90', '98.0', 70, 2),
(22, 85, 60, '6.90', '98.0', 76, 2),
(55, 120, 90, '12.00', '98.0', 70, 2),
(35, 120, 80, '6.90', '98.0', 78, 2),
(21, 90, 60, '6.90', '98.0', 86, 2),
(16, 90, 65, '6.90', '98.0', 76, 2),
(33, 115, 65, '7.00', '98.0', 70, 2),
(16, 95, 60, '6.90', '98.0', 65, 2),
(28, 120, 90, '6.90', '98.0', 70, 2),
(21, 90, 65, '6.90', '98.0', 76, 2),
(18, 90, 60, '6.90', '98.0', 70, 2),
(21, 120, 80, '6.90', '98.0', 76, 2),
(16, 100, 70, '6.90', '98.0', 80, 2),
(19, 120, 75, '6.90', '98.0', 66, 2),
(23, 100, 85, '6.90', '98.0', 66, 2),
(22, 120, 90, '7.80', '98.0', 82, 2),
(60, 120, 85, '15.00', '98.0', 60, 2),
(16, 90, 65, '7.80', '101.0', 80, 2),
(23, 120, 90, '7.80', '98.0', 60, 2),
(28, 115, 60, '7.80', '101.0', 86, 2),
(50, 120, 80, '7.80', '98.0', 70, 2),
(29, 130, 70, '7.80', '98.0', 78, 2),
(19, 120, 85, '7.80', '98.0', 60, 2),
(60, 90, 65, '6.80', '98.0', 77, 2),
(55, 120, 90, '6.80', '98.0', 66, 2),
(25, 120, 80, '6.80', '98.0', 66, 2),
(48, 140, 90, '15.00', '98.0', 90, 3),
(25, 140, 100, '6.80', '98.0', 80, 3),
(23, 140, 90, '6.80', '98.0', 70, 3),
(34, 85, 60, '11.00', '102.0', 86, 3),
(42, 140, 100, '18.00', '98.0', 90, 3),
(32, 140, 100, '7.90', '98.0', 78, 3),
(50, 140, 95, '17.00', '98.0', 60, 3),
(38, 135, 60, '7.90', '101.0', 86, 3),
(39, 90, 70, '9.00', '98.0', 80, 3),
(30, 140, 100, '15.00', '98.0', 70, 3),
(63, 140, 90, '15.00', '98.0', 90, 3),
(25, 140, 100, '7.90', '98.0', 80, 3),
(30, 120, 80, '7.90', '101.0', 76, 3),
(55, 140, 100, '18.00', '98.0', 90, 3),
(48, 120, 80, '11.00', '98.0', 88, 3),
(49, 140, 90, '15.00', '98.0', 90, 3),
(25, 140, 100, '7.50', '98.0', 80, 3),
(40, 160, 100, '19.00', '98.0', 77, 3),
(32, 140, 90, '18.00', '98.0', 88, 3),
(35, 140, 100, '7.50', '98.0', 66, 3),
(54, 140, 100, '15.00', '98.0', 66, 3),
(55, 140, 95, '19.00', '98.0', 77, 3),
(29, 120, 70, '9.00', '98.0', 80, 3),
(40, 120, 95, '11.00', '98.0', 80, 3),
(22, 90, 60, '7.50', '102.0', 60, 3),
(40, 120, 85, '15.00', '98.0', 60, 3),
(50, 130, 100, '16.00', '98.0', 75, 3),
(18, 120, 80, '6.90', '102.0', 76, 2),
(32, 140, 100, '6.90', '98.0', 78, 3),
(17, 90, 60, '6.90', '101.0', 76, 2),
(17, 90, 63, '6.90', '101.0', 70, 2),
(25, 120, 90, '6.70', '101.0', 80, 2),
(17, 120, 80, '6.70', '102.0', 76, 2),
(16, 90, 65, '7.00', '101.0', 70, 3),
(16, 80, 60, '6.70', '98.0', 80, 1),
(16, 100, 65, '6.70', '98.0', 76, 1),
(16, 95, 60, '6.70', '98.0', 77, 1),
(37, 120, 90, '11.00', '98.0', 88, 3),
(18, 100, 70, '6.70', '98.0', 76, 1),
(21, 100, 85, '6.70', '98.0', 70, 1),
(17, 110, 75, '12.00', '101.0', 76, 3),
(25, 120, 90, '7.50', '98.0', 80, 1),
(23, 85, 65, '7.50', '98.0', 70, 1),
(16, 95, 60, '7.50', '98.0', 65, 1),
(28, 120, 90, '7.50', '98.0', 70, 1),
(40, 120, 90, '12.00', '98.0', 80, 3),
(55, 129, 85, '7.50', '98.0', 88, 1),
(25, 100, 90, '7.50', '98.0', 76, 1),
(35, 120, 80, '7.50', '98.0', 80, 1),
(16, 90, 60, '7.90', '102.0', 66, 3),
(35, 140, 100, '8.00', '98.0', 66, 3),
(60, 120, 85, '15.00', '98.0', 60, 3),
(16, 90, 65, '7.90', '101.0', 80, 2),
(17, 90, 65, '6.10', '103.0', 67, 3),
(28, 83, 60, '8.00', '101.0', 86, 3),
(50, 120, 80, '15.00', '98.0', 70, 3),
(29, 130, 70, '6.10', '98.0', 78, 2),
(17, 85, 60, '9.00', '102.0', 86, 3),
(33, 120, 75, '10.00', '98.0', 70, 3),
(28, 85, 60, '9.00', '101.0', 86, 2),
(29, 120, 75, '7.20', '100.0', 70, 3),
(50, 140, 90, '15.00', '98.0', 77, 3),
(25, 140, 100, '7.20', '98.0', 80, 3),
(55, 140, 80, '7.20', '101.0', 76, 3),
(40, 140, 100, '18.00', '98.0', 77, 3),
(28, 120, 80, '9.00', '102.0', 76, 3),
(32, 140, 100, '8.00', '98.0', 70, 3),
(17, 90, 60, '11.00', '101.0', 78, 3),
(17, 90, 63, '8.00', '101.0', 70, 3),
(25, 120, 90, '12.00', '101.0', 80, 3),
(17, 120, 80, '7.00', '102.0', 76, 3),
(19, 90, 65, '11.00', '101.0', 70, 3),
(18, 100, 70, '6.80', '98.0', 76, 1),
(21, 100, 85, '6.90', '98.0', 70, 1),
(17, 110, 75, '13.00', '101.0', 76, 3),
(25, 120, 90, '15.00', '98.0', 80, 3),
(16, 85, 65, '6.90', '98.0', 70, 1),
(16, 95, 60, '6.90', '98.0', 65, 1),
(28, 120, 90, '6.90', '98.0', 70, 1),
(40, 120, 90, '6.90', '98.0', 80, 1),
(55, 110, 85, '6.90', '98.0', 88, 1),
(25, 100, 90, '6.90', '98.0', 76, 1),
(35, 120, 80, '6.90', '98.0', 80, 1),
(21, 90, 65, '6.90', '98.0', 76, 1),
(18, 90, 60, '6.90', '98.0', 70, 1),
(21, 120, 80, '6.90', '98.0', 76, 1),
(16, 100, 70, '6.90', '98.0', 80, 1),
(19, 120, 75, '6.90', '98.0', 66, 1),
(22, 100, 65, '6.90', '98.0', 70, 1),
(49, 120, 90, '6.90', '98.0', 77, 1),
(28, 90, 60, '6.90', '98.0', 82, 1),
(16, 90, 60, '8.00', '102.0', 66, 3),
(20, 100, 90, '7.00', '98.0', 88, 1),
(23, 100, 85, '7.00', '98.0', 66, 1),
(22, 120, 90, '7.00', '98.0', 82, 1),
(21, 120, 80, '7.00', '98.0', 77, 1),
(35, 140, 100, '9.00', '98.0', 66, 3),
(21, 75, 50, '7.70', '98.0', 60, 1),
(16, 90, 60, '11.00', '102.0', 60, 3),
(50, 130, 100, '16.00', '98.0', 76, 3),
(60, 120, 80, '7.70', '98.0', 75, 1),
(55, 100, 65, '7.70', '98.0', 66, 1),
(45, 120, 95, '7.70', '98.0', 66, 1),
(35, 100, 70, '7.70', '98.0', 66, 1),
(22, 120, 85, '7.70', '98.0', 88, 1),
(16, 90, 65, '9.00', '101.0', 80, 3),
(23, 120, 90, '7.70', '98.0', 60, 1),
(17, 90, 65, '7.70', '103.0', 67, 3),
(50, 120, 80, '7.70', '98.0', 70, 1),
(19, 90, 70, '7.70', '98.0', 80, 1),
(30, 120, 80, '7.70', '98.0', 70, 1),
(31, 120, 60, '6.10', '98.0', 76, 1),
(23, 120, 80, '7.70', '98.0', 70, 1),
(17, 85, 60, '6.30', '102.0', 86, 3),
(32, 120, 90, '7.70', '98.0', 70, 1),
(42, 120, 80, '7.70', '98.0', 70, 1),
(23, 90, 60, '7.70', '98.0', 76, 1),
(16, 75, 49, '7.70', '98.0', 77, 1),
(40, 120, 75, '7.70', '98.0', 70, 3),
(16, 120, 80, '7.70', '98.0', 70, 1),
(25, 120, 80, '7.70', '98.0', 66, 1),
(22, 100, 65, '6.90', '98.0', 80, 1),
(16, 120, 95, '6.90', '98.0', 60, 1),
(35, 100, 70, '6.90', '98.0', 60, 1),
(19, 120, 85, '6.90', '98.0', 60, 1),
(60, 90, 65, '6.90', '98.0', 77, 1),
(55, 120, 90, '6.90', '98.0', 76, 1),
(35, 90, 65, '6.90', '98.0', 75, 1),
(51, 85, 60, '6.90', '98.0', 66, 1),
(62, 120, 80, '6.90', '98.0', 66, 1),
(25, 90, 70, '6.90', '98.0', 66, 1),
(21, 120, 80, '6.90', '98.0', 88, 1),
(22, 120, 60, '15.00', '98.0', 80, 3),
(55, 120, 90, '18.00', '98.0', 60, 3),
(35, 85, 60, '19.00', '98.0', 86, 3),
(43, 120, 90, '18.00', '98.0', 70, 3),
(16, 120, 80, '6.90', '98.0', 80, 1),
(65, 90, 60, '6.90', '98.0', 70, 1),
(60, 120, 80, '6.90', '98.0', 76, 1),
(25, 120, 90, '6.90', '98.0', 70, 1),
(22, 90, 65, '6.90', '98.0', 78, 1),
(66, 85, 60, '6.90', '98.0', 86, 1),
(56, 120, 80, '13.00', '98.0', 70, 3),
(35, 90, 70, '6.90', '98.0', 70, 1),
(43, 120, 80, '15.00', '98.0', 76, 3),
(35, 120, 60, '6.90', '98.0', 70, 1),
(45, 120, 80, '6.90', '103.0', 70, 1),
(70, 85, 60, '6.90', '102.0', 70, 1),
(65, 120, 90, '6.90', '103.0', 76, 1),
(55, 120, 80, '6.90', '102.0', 80, 1),
(45, 90, 60, '18.00', '101.0', 70, 3),
(22, 120, 80, '6.90', '103.0', 76, 1),
(16, 95, 60, '6.90', '98.0', 77, 1),
(18, 100, 70, '6.90', '98.0', 76, 1),
(17, 110, 75, '6.90', '101.0', 76, 3),
(25, 120, 90, '6.90', '98.0', 80, 1),
(40, 120, 90, '6.90', '98.0', 80, 3),
(55, 110, 85, '6.90', '98.0', 88, 3),
(25, 100, 90, '6.90', '98.0', 76, 3),
(35, 120, 80, '6.90', '98.0', 80, 3),
(21, 120, 80, '7.80', '98.0', 77, 1),
(35, 140, 100, '7.80', '98.0', 66, 3),
(21, 75, 50, '7.80', '98.0', 60, 1),
(16, 90, 60, '7.80', '102.0', 60, 3),
(60, 120, 80, '7.80', '98.0', 75, 3),
(55, 100, 65, '7.80', '98.0', 66, 1),
(45, 120, 95, '7.80', '98.0', 66, 1),
(35, 100, 70, '7.80', '98.0', 66, 1),
(22, 120, 85, '7.80', '98.0', 88, 1),
(17, 90, 65, '7.80', '103.0', 67, 3),
(19, 90, 70, '7.80', '98.0', 80, 1),
(30, 120, 80, '7.80', '98.0', 70, 1),
(23, 120, 70, '7.80', '98.0', 70, 1),
(17, 85, 69, '7.80', '102.0', 86, 3),
(32, 120, 90, '7.80', '98.0', 70, 1),
(42, 120, 80, '7.80', '98.0', 70, 1),
(23, 90, 60, '7.80', '98.0', 76, 1),
(16, 76, 49, '7.80', '98.0', 77, 1),
(20, 120, 75, '7.80', '98.0', 70, 1),
(16, 120, 80, '7.80', '98.0', 70, 1),
(25, 120, 80, '7.80', '98.0', 66, 1),
(22, 100, 65, '7.80', '98.0', 80, 1),
(16, 120, 95, '7.80', '98.0', 60, 1),
(35, 100, 70, '7.80', '98.0', 60, 1),
(22, 100, 65, '6.80', '98.0', 88, 1),
(16, 120, 95, '6.80', '98.0', 60, 2),
(35, 100, 70, '6.80', '98.0', 60, 2),
(19, 120, 90, '6.80', '98.0', 60, 2),
(55, 120, 90, '6.80', '98.0', 78, 1),
(50, 130, 80, '16.00', '102.0', 76, 2),
(27, 120, 90, '6.80', '102.0', 68, 2),
(60, 140, 90, '12.00', '98.0', 77, 3),
(55, 100, 70, '6.80', '101.0', 80, 2),
(60, 140, 80, '16.00', '98.0', 66, 3),
(16, 120, 90, '6.80', '98.0', 80, 2),
(17, 140, 100, '6.80', '103.0', 80, 3),
(60, 120, 80, '6.80', '98.0', 77, 2),
(36, 140, 100, '6.80', '102.0', 76, 3),
(22, 90, 60, '6.80', '98.0', 77, 1),
(25, 120, 100, '6.80', '98.0', 60, 2),
(35, 100, 60, '15.00', '98.0', 80, 3),
(40, 140, 100, '13.00', '101.0', 66, 3),
(27, 120, 70, '6.80', '98.0', 77, 1),
(22, 90, 60, '6.80', '98.0', 77, 2),
(25, 120, 100, '6.80', '98.0', 60, 1),
(65, 130, 80, '15.00', '98.0', 86, 3),
(35, 140, 80, '13.00', '98.0', 70, 3),
(29, 90, 70, '10.00', '98.0', 80, 3),
(30, 120, 80, '6.80', '98.0', 70, 2),
(35, 120, 60, '6.10', '98.0', 76, 2),
(23, 130, 70, '6.80', '98.0', 78, 2),
(32, 120, 90, '6.80', '98.0', 70, 1),
(43, 130, 80, '18.00', '98.0', 70, 2),
(23, 99, 60, '6.80', '98.0', 76, 1),
(16, 76, 49, '6.80', '98.0', 77, 1),
(30, 120, 75, '6.80', '98.0', 70, 2),
(16, 120, 80, '6.80', '98.0', 70, 1),
(29, 100, 70, '6.80', '98.0', 80, 1),
(32, 120, 80, '6.80', '98.0', 70, 2),
(42, 130, 80, '18.00', '98.0', 70, 2),
(23, 90, 60, '6.80', '98.0', 76, 1),
(20, 120, 75, '6.80', '98.0', 70, 1),
(48, 120, 80, '11.00', '98.0', 88, 1),
(30, 120, 80, '6.80', '101.0', 76, 1),
(31, 110, 90, '6.80', '100.0', 70, 2),
(18, 120, 80, '6.80', '102.0', 76, 1),
(17, 90, 60, '7.90', '101.0', 76, 1),
(16, 76, 49, '7.90', '98.0', 77, 1),
(19, 120, 75, '7.90', '98.0', 70, 1),
(16, 120, 80, '7.90', '98.0', 70, 1),
(25, 120, 80, '7.90', '98.0', 66, 2),
(22, 100, 65, '7.90', '98.0', 80, 1),
(35, 100, 70, '7.90', '98.0', 60, 1),
(19, 120, 85, '7.90', '98.0', 60, 1),
(60, 90, 65, '7.90', '98.0', 77, 1),
(50, 120, 80, '7.90', '98.0', 70, 1),
(23, 120, 90, '7.90', '98.0', 70, 2),
(29, 130, 70, '7.90', '98.0', 78, 2),
(17, 85, 60, '7.90', '102.0', 86, 1),
(32, 120, 90, '7.90', '98.0', 70, 1),
(42, 120, 80, '7.90', '98.0', 70, 1),
(23, 90, 60, '7.90', '98.0', 76, 1),
(19, 120, 80, '7.00', '98.0', 70, 1),
(16, 120, 75, '7.90', '98.0', 7, 1),
(17, 70, 50, '7.90', '98.0', 70, 1),
(18, 120, 80, '7.90', '102.0', 76, 2),
(17, 90, 60, '7.50', '101.0', 76, 1),
(17, 90, 63, '7.50', '101.0', 70, 1),
(25, 120, 90, '7.50', '101.0', 80, 1),
(17, 120, 80, '7.50', '102.0', 76, 1),
(19, 90, 65, '7.50', '101.0', 70, 1),
(16, 80, 60, '7.50', '98.0', 80, 1),
(60, 90, 65, '7.50', '98.0', 77, 1),
(18, 85, 60, '7.50', '101.0', 86, 2),
(50, 120, 80, '7.50', '98.0', 70, 1),
(19, 90, 70, '7.50', '98.0', 80, 1),
(23, 120, 90, '7.50', '98.0', 70, 1),
(29, 130, 70, '7.50', '98.0', 78, 2),
(17, 85, 60, '7.50', '102.0', 86, 1),
(42, 90, 60, '7.50', '98.0', 76, 1),
(16, 78, 49, '7.50', '98.0', 77, 1),
(23, 120, 75, '8.00', '98.0', 70, 2),
(16, 120, 80, '7.50', '98.0', 70, 2),
(30, 120, 80, '7.50', '101.0', 76, 2),
(16, 70, 50, '7.50', '100.0', 70, 1),
(16, 100, 70, '7.50', '98.0', 80, 1),
(19, 120, 75, '7.50', '98.0', 66, 1),
(22, 100, 65, '7.50', '98.0', 70, 1),
(49, 120, 90, '7.50', '98.0', 77, 1),
(28, 90, 60, '7.50', '98.0', 82, 1),
(16, 90, 60, '7.50', '102.0', 66, 1),
(20, 100, 90, '7.50', '98.0', 88, 1),
(23, 100, 85, '7.50', '98.0', 66, 1),
(22, 120, 90, '7.50', '98.0', 82, 1),
(21, 120, 80, '7.50', '98.0', 77, 1),
(40, 120, 95, '11.00', '98.0', 80, 2),
(21, 75, 50, '7.50', '98.0', 60, 1),
(16, 90, 60, '7.50', '102.0', 60, 1),
(50, 130, 100, '16.00', '98.0', 75, 2),
(60, 120, 80, '7.50', '98.0', 75, 1),
(55, 100, 65, '7.50', '98.0', 66, 1),
(45, 120, 95, '7.50', '98.0', 66, 1),
(35, 100, 70, '7.50', '98.0', 66, 1),
(22, 120, 85, '7.50', '98.0', 88, 1),
(16, 90, 65, '7.50', '101.0', 80, 1),
(23, 120, 90, '7.50', '98.0', 60, 1),
(17, 90, 65, '7.50', '103.0', 67, 1),
(28, 115, 60, '7.50', '101.0', 86, 2),
(59, 120, 80, '7.50', '98.0', 70, 1),
(23, 120, 80, '7.50', '98.0', 70, 1),
(23, 120, 80, '7.50', '98.0', 70, 2),
(20, 120, 75, '7.50', '98.0', 70, 1),
(16, 120, 80, '7.50', '98.0', 70, 1),
(24, 120, 80, '7.50', '98.0', 66, 1),
(19, 120, 76, '7.50', '98.0', 66, 1),
(22, 100, 65, '7.50', '98.0', 70, 2),
(49, 120, 90, '7.50', '98.0', 77, 2),
(28, 90, 60, '7.50', '98.0', 82, 2),
(16, 90, 60, '7.50', '102.0', 66, 2),
(20, 100, 90, '7.50', '98.0', 88, 2),
(23, 100, 85, '7.50', '98.0', 66, 2),
(22, 120, 90, '7.50', '98.0', 82, 2),
(21, 120, 80, '7.50', '98.0', 77, 2),
(60, 120, 80, '7.50', '98.0', 75, 2),
(41, 120, 80, '7.50', '98.0', 75, 1),
(16, 90, 65, '7.50', '101.0', 80, 3),
(17, 90, 65, '7.50', '103.0', 67, 2),
(27, 135, 60, '7.50', '101.0', 86, 3),
(34, 110, 70, '7.00', '98.0', 80, 3),
(32, 120, 80, '7.50', '98.0', 70, 1),
(17, 85, 60, '7.50', '101.0', 86, 3),
(20, 120, 76, '7.50', '98.0', 70, 1),
(22, 100, 65, '12.00', '98.0', 80, 3),
(35, 100, 70, '11.00', '98.0', 60, 3),
(19, 120, 85, '9.00', '98.0', 60, 2),
(30, 90, 65, '8.00', '98.0', 77, 2),
(50, 130, 80, '15.00', '98.0', 86, 3),
(29, 90, 70, '11.00', '100.0', 80, 3),
(19, 120, 60, '7.00', '98.4', 70, 1),
(46, 140, 100, '12.00', '99.0', 90, 3),
(28, 95, 60, '10.00', '101.0', 86, 3),
(50, 120, 80, '7.00', '98.0', 70, 2),
(39, 110, 70, '7.90', '98.0', 80, 2),
(25, 140, 100, '15.00', '98.6', 70, 3),
(23, 120, 85, '8.00', '98.0', 70, 1),
(29, 130, 70, '8.00', '98.0', 78, 2),
(17, 90, 60, '9.00', '102.0', 86, 2),
(32, 120, 90, '7.00', '100.0', 70, 2),
(42, 120, 90, '9.00', '98.0', 70, 2),
(23, 90, 60, '6.70', '98.0', 76, 1),
(16, 76, 68, '7.00', '98.0', 77, 1),
(34, 120, 75, '8.00', '98.0', 70, 1),
(16, 120, 80, '6.60', '99.0', 70, 1),
(27, 140, 90, '15.00', '98.0', 90, 3),
(25, 140, 100, '12.00', '99.0', 80, 3),
(36, 120, 90, '7.00', '98.0', 82, 2),
(30, 120, 80, '9.00', '101.0', 76, 2),
(16, 70, 50, '6.00', '98.0', 70, 2),
(40, 120, 95, '7.00', '98.0', 70, 3),
(16, 90, 60, '6.00', '98.0', 80, 1),
(21, 90, 50, '6.90', '98.0', 60, 1),
(16, 90, 49, '6.00', '98.0', 77, 1),
(21, 90, 50, '6.50', '98.0', 60, 1),
(16, 90, 49, '6.70', '99.0', 77, 1),
(16, 90, 49, '6.00', '99.0', 77, 1),
(16, 100, 50, '6.00', '99.0', 70, 2),
(16, 100, 49, '6.80', '99.0', 77, 1),
(16, 100, 49, '6.00', '99.0', 77, 1),
(16, 100, 50, '6.40', '98.0', 70, 2),
(16, 100, 60, '6.00', '98.0', 80, 1),
(16, 100, 49, '7.60', '98.0', 77, 1),
(16, 100, 50, '6.00', '98.0', 70, 2),
(21, 100, 50, '6.80', '98.0', 60, 1);

-- --------------------------------------------------------

--
-- Struktur dari tabel `trig`
--

CREATE TABLE `trig` (
  `tid` int(11) NOT NULL,
  `nik` varchar(50) NOT NULL,
  `action` varchar(50) NOT NULL,
  `timestamp` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data untuk tabel `trig`
--

INSERT INTO `trig` (`tid`, `nik`, `action`, `timestamp`) VALUES
(3, '1271678656789876', 'PATIENT INSERTED', '2023-01-13 21:11:09'),
(4, '1271678656789876', 'PATIENT DELETED', '2023-01-13 21:44:28'),
(5, '1271678656789876', 'PATIENT INSERTED', '2023-01-13 21:46:43'),
(6, '1271678656789876', 'PATIENT DELETED', '2023-01-14 17:40:09'),
(7, '1271678656789876', 'PATIENT INSERTED', '2023-01-14 17:42:47'),
(8, '1271678656789876', 'PATIENT UPDATED', '2023-01-15 20:30:50'),
(9, '1271678656789876', 'PATIENT UPDATED', '2023-01-15 20:36:43'),
(10, '1271678656789876', 'PATIENT UPDATED', '2023-01-15 20:36:50'),
(11, '1271678656789876', 'PATIENT UPDATED', '2023-01-15 20:37:03'),
(12, '1271085406032789', 'PATIENT UPDATED', '2023-01-15 20:38:38'),
(13, '1271085406032789', 'PATIENT UPDATED', '2023-01-15 20:52:17'),
(14, '1271085406032789', 'PATIENT UPDATED', '2023-01-15 23:33:42'),
(15, '1271085406032789', 'PATIENT UPDATED', '2023-01-15 23:33:52');

-- --------------------------------------------------------

--
-- Struktur dari tabel `user`
--

CREATE TABLE `user` (
  `id` int(11) NOT NULL,
  `username` varchar(50) NOT NULL,
  `email` varchar(50) NOT NULL,
  `password` varchar(500) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data untuk tabel `user`
--

INSERT INTO `user` (`id`, `username`, `email`, `password`) VALUES
(1, 'disha', 'disha16122001@gmail.com', '12345'),
(6, 'aku', 'aku@gmail.com', 'pbkdf2:sha256:260000$05pyKBxVL0C4FA5m$a7f34c7b2a54ccffbf2aeaccb862fa6be6483dc2b6b7ab2539ce8e0dc377df1e'),
(7, 'fahira', 'fahira1678@gmail.com', 'pbkdf2:sha256:260000$kyVFvYVZGlmEJOkP$337297d5b86ffed1ec09ce6a88b05c462aae391ca02d3693078f75e2ac8acfef'),
(8, 'Zian Asti Dwiyanti', 'ziandwiasti23@gmail.com', 'pbkdf2:sha256:260000$FPOHhDmUPL6AXQAC$3c180ab116bf0125d20f29f84cf37cef286d2e99201e28e6dacb89f9135403af'),
(9, 'admin', 'admin@admin.com', 'pbkdf2:sha256:260000$8lAKBEaGolpshuMp$37535800142b2e4b9e9ada0f7d22a33ffe49cef22b1a21fc5bc1322a9d7f367a');

--
-- Indexes for dumped tables
--

--
-- Indeks untuk tabel `categories`
--
ALTER TABLE `categories`
  ADD PRIMARY KEY (`cid`);

--
-- Indeks untuk tabel `doctor`
--
ALTER TABLE `doctor`
  ADD PRIMARY KEY (`did`);

--
-- Indeks untuk tabel `information`
--
ALTER TABLE `information`
  ADD PRIMARY KEY (`fid`);

--
-- Indeks untuk tabel `patient`
--
ALTER TABLE `patient`
  ADD PRIMARY KEY (`id`);

--
-- Indeks untuk tabel `prediction`
--
ALTER TABLE `prediction`
  ADD PRIMARY KEY (`pid`);

--
-- Indeks untuk tabel `recommendation`
--
ALTER TABLE `recommendation`
  ADD PRIMARY KEY (`rid`);

--
-- Indeks untuk tabel `schedule_doctor`
--
ALTER TABLE `schedule_doctor`
  ADD PRIMARY KEY (`sid`);

--
-- Indeks untuk tabel `trig`
--
ALTER TABLE `trig`
  ADD PRIMARY KEY (`tid`);

--
-- Indeks untuk tabel `user`
--
ALTER TABLE `user`
  ADD PRIMARY KEY (`id`);

--
-- AUTO_INCREMENT untuk tabel yang dibuang
--

--
-- AUTO_INCREMENT untuk tabel `categories`
--
ALTER TABLE `categories`
  MODIFY `cid` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT untuk tabel `doctor`
--
ALTER TABLE `doctor`
  MODIFY `did` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT untuk tabel `information`
--
ALTER TABLE `information`
  MODIFY `fid` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT untuk tabel `patient`
--
ALTER TABLE `patient`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT untuk tabel `prediction`
--
ALTER TABLE `prediction`
  MODIFY `pid` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=39;

--
-- AUTO_INCREMENT untuk tabel `recommendation`
--
ALTER TABLE `recommendation`
  MODIFY `rid` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT untuk tabel `schedule_doctor`
--
ALTER TABLE `schedule_doctor`
  MODIFY `sid` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT untuk tabel `trig`
--
ALTER TABLE `trig`
  MODIFY `tid` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=16;

--
-- AUTO_INCREMENT untuk tabel `user`
--
ALTER TABLE `user`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
