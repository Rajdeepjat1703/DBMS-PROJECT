SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+05:30";

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;

-- Database: `hotel`

-- Table structure for table `contact`
CREATE TABLE IF NOT EXISTS `contact` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `fullname` varchar(100) DEFAULT NULL,
  `phoneno` int(10) DEFAULT NULL,
  `email` text,
  `cdate` date DEFAULT NULL,
  `approval` varchar(12) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

INSERT INTO `contact` (`id`, `fullname`, `phoneno`, `email`, `cdate`, `approval`) VALUES
(1, 'John Doe', 1234567890, 'john.doe@example.com', '2023-01-01', 'Approved');

-- Table structure for table `login`
CREATE TABLE IF NOT EXISTS `login` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `usname` varchar(30) DEFAULT NULL,
  `pass` varchar(30) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=3;

INSERT INTO `login` (`id`, `usname`, `pass`) VALUES
(1, 'admin', '1234');

-- Table structure for table `payment`
CREATE TABLE IF NOT EXISTS `payment` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `title` varchar(5) DEFAULT NULL,
  `fname` varchar(30) DEFAULT NULL,
  `lname` varchar(30) DEFAULT NULL,
  `troom` varchar(30) DEFAULT NULL,
  `tbed` varchar(30) DEFAULT NULL,
  `nroom` int(11) DEFAULT NULL,
  `cin` date DEFAULT NULL,
  `cout` date DEFAULT NULL,
  `ttot` double(8,2) DEFAULT NULL,
  `fintot` double(8,2) DEFAULT NULL,
  `mepr` double(8,2) DEFAULT NULL,
  `meal` varchar(30) DEFAULT NULL,
  `btot` double(8,2) DEFAULT NULL,
  `noofdays` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=2;

-- Table structure for table `room`
CREATE TABLE IF NOT EXISTS `room` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `type` varchar(15) DEFAULT NULL,
  `bedding` varchar(10) DEFAULT NULL,
  `place` varchar(10) DEFAULT NULL,
  `cusid` int(10) DEFAULT NULL,
  PRIMARY KEY (`id`),
  CONSTRAINT `fk_room_contact_id` FOREIGN KEY (`cusid`) REFERENCES `contact` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=16;

INSERT INTO `room` (`id`, `type`, `bedding`, `place`, `cusid`) VALUES
(1, 'Superior Room', 'Single', 'Free', NULL),
(2, 'Superior Room', 'Double', 'Free', NULL);
-- ... (other room records)

-- Table structure for table `roombook`
CREATE TABLE IF NOT EXISTS `roombook` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `Title` varchar(5) DEFAULT NULL,
  `FName` text,
  `LName` text,
  `Email` varchar(50) DEFAULT NULL,
  `National` varchar(30) DEFAULT NULL,
  `Country` varchar(30) DEFAULT NULL,
  `Phone` text,
  `TRoom` varchar(20) DEFAULT NULL,
  `Bed` varchar(10) DEFAULT NULL,
  `NRoom` varchar(2) DEFAULT NULL,
  `Meal` varchar(15) DEFAULT NULL,
  `cin` date DEFAULT NULL,
  `cout` date DEFAULT NULL,
  `stat` varchar(15) DEFAULT NULL,
  `nodays` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  CONSTRAINT `fk_roombook_room_id` FOREIGN KEY (`id`) REFERENCES `room` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=2;

INSERT INTO `roombook` (`id`, `Title`, `FName`, `LName`, `Email`, `National`, `Country`, `Phone`, `TRoom`, `Bed`, `NRoom`, `Meal`, `cin`, `cout`, `stat`, `nodays`) VALUES
(1, 'Mr.', 'John', 'Doe', 'john@example.com', 'American', 'USA', '1234567890', 'Superior Room', 'Single', '1', 'No', '2023-01-01', '2023-01-05', 'Booked', 5);

-- Adding foreign keys
ALTER TABLE `payment`
ADD CONSTRAINT `fk_payment_room_id` FOREIGN KEY (`id`) REFERENCES `room` (`id`) ON DELETE CASCADE;

ALTER TABLE `room`
ADD CONSTRAINT `fk_room_payment_id` FOREIGN KEY (`id`) REFERENCES `payment` (`id`) ON DELETE CASCADE;

ALTER TABLE `room`
ADD CONSTRAINT `fk_room_contact_id` FOREIGN KEY (`cusid`) REFERENCES `contact` (`id`) ON DELETE SET NULL;



-- Table structure for table `audit_table`
CREATE TABLE IF NOT EXISTS `audit_table` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `action` varchar(50) DEFAULT NULL,
  `table_name` varchar(50) DEFAULT NULL,
  `record_id` int(10) unsigned DEFAULT NULL,
  `timestamp` timestamp DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- Triggers
DELIMITER //

CREATE TRIGGER before_payment_insert
BEFORE INSERT
ON payment FOR EACH ROW
BEGIN
    SET NEW.fintot = NEW.ttot * 1.1; -- Assuming a 10% increase for demonstration purposes
END;
//

CREATE TRIGGER after_payment_insert
AFTER INSERT
ON payment FOR EACH ROW
BEGIN
    INSERT INTO audit_table (action, table_name, record_id)
    VALUES ('INSERT', 'payment', NEW.id);
END;
//

DELIMITER ;

-- Functions
DELIMITER //

CREATE FUNCTION calculate_total_cost(nights INT, room_rate DECIMAL(8,2)) RETURNS DECIMAL(8,2)
DETERMINISTIC
NO SQL
BEGIN
    DECLARE total_cost DECIMAL(8,2);
    SET total_cost = nights * room_rate;
    RETURN total_cost;
END;
//

CREATE FUNCTION get_approval_status_from_roombook(roombook_id INT) RETURNS VARCHAR(20)
DETERMINISTIC
NO SQL
BEGIN
    DECLARE approval_status VARCHAR(20);

    SELECT CONCAT('Approval: ', stat)
    INTO approval_status
    FROM roombook
    WHERE id = roombook_id;

    RETURN approval_status;
END;
//

DELIMITER ;

SELECT
    r.type AS room_type,
    COUNT(p.id) AS payment_count,
    SUM(p.ttot) AS total_amount
FROM
    room r
LEFT JOIN
    payment p ON r.id = p.id
GROUP BY
    r.type;




