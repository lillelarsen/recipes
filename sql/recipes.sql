-- phpMyAdmin SQL Dump
-- version 4.3.11
-- http://www.phpmyadmin.net
--
-- Vært: 127.0.0.1
-- Genereringstid: 07. 01 2019 kl. 10:12:14
-- Serverversion: 5.6.24
-- PHP-version: 5.6.8

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;

--
-- Database: `recipes`
--

-- --------------------------------------------------------

--
-- Struktur-dump for tabellen `comments`
--

CREATE TABLE IF NOT EXISTS `comments` (
  `id` int(11) NOT NULL,
  `content` text NOT NULL,
  `author` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Struktur-dump for tabellen `ingredients`
--

CREATE TABLE IF NOT EXISTS `ingredients` (
  `id` int(11) NOT NULL,
  `name` varchar(45) NOT NULL,
  `amount` int(11) NOT NULL,
  `measure` decimal(6,2) DEFAULT NULL,
  `recipes_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Struktur-dump for tabellen `photos`
--

CREATE TABLE IF NOT EXISTS `photos` (
  `id` int(11) NOT NULL,
  `name` varchar(120) NOT NULL
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;

--
-- Data dump for tabellen `photos`
--

INSERT INTO `photos` (`id`, `name`) VALUES
(1, 'default.jpg');

-- --------------------------------------------------------

--
-- Struktur-dump for tabellen `profiles`
--

CREATE TABLE IF NOT EXISTS `profiles` (
  `id` int(11) NOT NULL,
  `firstname` varchar(45) DEFAULT NULL,
  `lastname` varchar(45) DEFAULT NULL,
  `bio` text,
  `users_id` int(11) NOT NULL,
  `photos_id` int(11) NOT NULL
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;

--
-- Data dump for tabellen `profiles`
--

INSERT INTO `profiles` (`id`, `firstname`, `lastname`, `bio`, `users_id`, `photos_id`) VALUES
(1, NULL, NULL, NULL, 1, 1);

-- --------------------------------------------------------

--
-- Struktur-dump for tabellen `recipes`
--

CREATE TABLE IF NOT EXISTS `recipes` (
  `id` int(11) NOT NULL,
  `description` text,
  `procedure` text NOT NULL,
  `author` int(11) NOT NULL,
  `published` tinyint(1) DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Struktur-dump for tabellen `recipe_comment`
--

CREATE TABLE IF NOT EXISTS `recipe_comment` (
  `id` int(11) NOT NULL,
  `recipes_id` int(11) NOT NULL,
  `comments_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Struktur-dump for tabellen `recipe_photo`
--

CREATE TABLE IF NOT EXISTS `recipe_photo` (
  `id` int(11) NOT NULL,
  `recipes_id` int(11) NOT NULL,
  `photos_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Struktur-dump for tabellen `roles`
--

CREATE TABLE IF NOT EXISTS `roles` (
  `id` int(11) NOT NULL,
  `name` varchar(15) NOT NULL,
  `level` int(11) NOT NULL
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8;

--
-- Data dump for tabellen `roles`
--

INSERT INTO `roles` (`id`, `name`, `level`) VALUES
(1, 'Super admin', 100),
(2, 'Admin', 90),
(3, 'Moderator', 80),
(4, 'Author', 20),
(5, 'User', 10),
(6, 'Guest', 1);

-- --------------------------------------------------------

--
-- Stand-in-struktur for visning `userprofiles`
--
CREATE TABLE IF NOT EXISTS `userprofiles` (
`id` int(11)
,`username` varchar(100)
,`firstname` varchar(45)
,`lastname` varchar(45)
,`fullname` varchar(90)
,`bio` text
,`photo` varchar(120)
,`role` varchar(15)
);

-- --------------------------------------------------------

--
-- Struktur-dump for tabellen `users`
--

CREATE TABLE IF NOT EXISTS `users` (
  `id` int(11) NOT NULL,
  `username` varchar(100) NOT NULL,
  `password` varchar(76) NOT NULL,
  `roles_id` int(11) NOT NULL
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;

--
-- Data dump for tabellen `users`
--

INSERT INTO `users` (`id`, `username`, `password`, `roles_id`) VALUES
(1, 'admin', '1234', 1);

--
-- Triggers/udløsere `users`
--
DELIMITER $$
CREATE TRIGGER `createprofile` AFTER INSERT ON `users`
 FOR EACH ROW BEGIN
	INSERT INTO profiles SET users_id = NEW.id, photos_id = 1;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Struktur-dump for tabellen `votes`
--

CREATE TABLE IF NOT EXISTS `votes` (
  `id` int(11) NOT NULL,
  `recipes_id` int(11) NOT NULL,
  `users_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Struktur for visning `userprofiles`
--
DROP TABLE IF EXISTS `userprofiles`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `userprofiles` AS select `users`.`id` AS `id`,`users`.`username` AS `username`,`profiles`.`firstname` AS `firstname`,`profiles`.`lastname` AS `lastname`,concat(`profiles`.`firstname`,'',`profiles`.`lastname`) AS `fullname`,`profiles`.`bio` AS `bio`,`photos`.`name` AS `photo`,`roles`.`name` AS `role` from (((`users` join `profiles` on((`users`.`id` = `profiles`.`id`))) join `photos` on((`profiles`.`photos_id` = `photos`.`id`))) join `roles` on((`users`.`roles_id` = `roles`.`id`)));

--
-- Begrænsninger for dumpede tabeller
--

--
-- Indeks for tabel `comments`
--
ALTER TABLE `comments`
  ADD PRIMARY KEY (`id`);

--
-- Indeks for tabel `ingredients`
--
ALTER TABLE `ingredients`
  ADD PRIMARY KEY (`id`);

--
-- Indeks for tabel `photos`
--
ALTER TABLE `photos`
  ADD PRIMARY KEY (`id`);

--
-- Indeks for tabel `profiles`
--
ALTER TABLE `profiles`
  ADD PRIMARY KEY (`id`);

--
-- Indeks for tabel `recipes`
--
ALTER TABLE `recipes`
  ADD PRIMARY KEY (`id`);

--
-- Indeks for tabel `recipe_comment`
--
ALTER TABLE `recipe_comment`
  ADD PRIMARY KEY (`id`);

--
-- Indeks for tabel `recipe_photo`
--
ALTER TABLE `recipe_photo`
  ADD PRIMARY KEY (`id`);

--
-- Indeks for tabel `roles`
--
ALTER TABLE `roles`
  ADD PRIMARY KEY (`id`);

--
-- Indeks for tabel `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`);

--
-- Indeks for tabel `votes`
--
ALTER TABLE `votes`
  ADD PRIMARY KEY (`id`);

--
-- Brug ikke AUTO_INCREMENT for slettede tabeller
--

--
-- Tilføj AUTO_INCREMENT i tabel `comments`
--
ALTER TABLE `comments`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;
--
-- Tilføj AUTO_INCREMENT i tabel `ingredients`
--
ALTER TABLE `ingredients`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;
--
-- Tilføj AUTO_INCREMENT i tabel `photos`
--
ALTER TABLE `photos`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT,AUTO_INCREMENT=2;
--
-- Tilføj AUTO_INCREMENT i tabel `profiles`
--
ALTER TABLE `profiles`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT,AUTO_INCREMENT=2;
--
-- Tilføj AUTO_INCREMENT i tabel `recipes`
--
ALTER TABLE `recipes`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;
--
-- Tilføj AUTO_INCREMENT i tabel `recipe_comment`
--
ALTER TABLE `recipe_comment`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;
--
-- Tilføj AUTO_INCREMENT i tabel `recipe_photo`
--
ALTER TABLE `recipe_photo`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;
--
-- Tilføj AUTO_INCREMENT i tabel `roles`
--
ALTER TABLE `roles`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT,AUTO_INCREMENT=7;
--
-- Tilføj AUTO_INCREMENT i tabel `users`
--
ALTER TABLE `users`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT,AUTO_INCREMENT=2;
--
-- Tilføj AUTO_INCREMENT i tabel `votes`
--
ALTER TABLE `votes`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
