

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+05:30";

-- Table structure for table `contact`
CREATE TABLE IF NOT EXISTS `contact` (
  `id` int(10) unsigned NOT NULL,
  `fullname` varchar(100) DEFAULT NULL,
  `phoneno` int(10) DEFAULT NULL,
  `email` text,
  `cdate` date DEFAULT NULL,
  `approval` varchar(12) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1;

-- Dumping data for table `contact`
INSERT INTO `contact` (`id`, `fullname`, `phoneno`, `email`, `cdate`, `approval`) VALUES
(1, 'John Doe', 1234567890, 'john.doe@example.com', '2023-01-01', 'Approved');

-- Table structure for table `login`
CREATE TABLE IF NOT EXISTS `login` (
  `id` int(10) unsigned NOT NULL,
  `usname` varchar(30) DEFAULT NULL,
  `pass` varchar(30) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=3;

-- Dumping data for table `login`
INSERT INTO `login` (`id`, `usname`, `pass`) VALUES
(1, 'admin', '1234');



-- Table structure for table `payment`
CREATE TABLE IF NOT EXISTS `payment` (
  `id` int(10) ,
  `title` varchar(5) DEFAULT NULL,
  `fname` varchar(30) DEFAULT NULL,
  `lname` varchar(30) DEFAULT NULL,
  `troom` varchar(30) DEFAULT NULL,
  `tbed` varchar(30) DEFAULT NULL,
  `nroom` int(10) DEFAULT NULL,
  `cin` date DEFAULT NULL,
  `cout` date DEFAULT NULL,
  `ttot` double(8,2) DEFAULT NULL,
  `fintot` double(8,2) DEFAULT NULL,
  `mepr` double(8,2) DEFAULT NULL,
  `meal` varchar(30) DEFAULT NULL,
  `btot` double(8,2) DEFAULT NULL,
  `noofdays` int(10) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- Table structure for table `room`
CREATE TABLE IF NOT EXISTS `room` (
  `id` int(10) unsigned NOT NULL,
  `type` varchar(15) DEFAULT NULL,
  `bedding` varchar(10) DEFAULT NULL,
  `place` varchar(10) DEFAULT NULL,
  `cusid` int(10) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=16;

-- Dumping data for table `room`
INSERT INTO `room` (`id`, `type`, `bedding`, `place`, `cusid`) VALUES
(1, 'Superior Room', 'Single', 'Free', NULL),
(2, 'Superior Room', 'Double', 'Free', NULL),
(3, 'Superior Room', 'Triple', 'Free', NULL),
(4, 'Single Room', 'Quad', 'Free', NULL),
(5, 'Superior Room', 'Quad', 'Free', NULL),
(6, 'Deluxe Room', 'Single', 'Free', NULL),
(7, 'Deluxe Room', 'Double', 'Free', NULL),
(8, 'Deluxe Room', 'Triple', 'Free', NULL),
(9, 'Deluxe Room', 'Quad', 'Free', NULL),
(10, 'Guest House', 'Single', 'Free', NULL),
(11, 'Guest House', 'Double', 'Free', NULL),
(12, 'Guest House', 'Quad', 'Free', NULL),
(13, 'Single Room', 'Single', 'Free', NULL),
(14, 'Single Room', 'Double', 'Free', NULL),
(15, 'Single Room', 'Triple', 'Free', NULL);

-- Table structure for table `roombook`
CREATE TABLE IF NOT EXISTS `roombook` (
  `id` int(10) unsigned NOT NULL,
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
  `nodays` int(10) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=2;


-- Table structure for table `audit_table`
CREATE TABLE IF NOT EXISTS `audit_table` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `action` varchar(50) DEFAULT NULL,
  `table_name` varchar(50) DEFAULT NULL,
  `record_id` int(10) unsigned DEFAULT NULL,
  `timestamp` timestamp DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- Indexes for dumped tables

-- Indexes for table `contact`
ALTER TABLE `contact`
 ADD PRIMARY KEY (`id`);

-- Indexes for table `login`
ALTER TABLE `login`
 ADD PRIMARY KEY (`id`);

-- Indexes for table `newsletterlog`

-- Indexes for table `room`
ALTER TABLE `room`
 ADD PRIMARY KEY (`id`);

-- Indexes for table `roombook`
ALTER TABLE `roombook`
 ADD PRIMARY KEY (`id`);

-- Indexes for table `payment`
ALTER TABLE `payment`
 ADD PRIMARY KEY (`id`);

-- AUTO_INCREMENT for dumped tables

-- AUTO_INCREMENT for table `contact`
ALTER TABLE `contact`
MODIFY `id` int(10) unsigned NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

-- AUTO_INCREMENT for table `login`
ALTER TABLE `login`
MODIFY `id` int(10) unsigned NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;


-- AUTO_INCREMENT for table `room`
ALTER TABLE `room`
MODIFY `id` int(10) unsigned NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=16;

-- AUTO_INCREMENT for table `roombook`
ALTER TABLE `roombook`
MODIFY `id` int(10) unsigned NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

-- AUTO_INCREMENT for table `payment`
ALTER TABLE `payment`
MODIFY `id` int(10) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

ALTER TABLE `room` MODIFY COLUMN `cusid` int(10) unsigned DEFAULT NULL;

-- Add the foreign key constraint
ALTER TABLE `room`
ADD CONSTRAINT `room_ibfk_1` FOREIGN KEY (`cusid`) REFERENCES `contact` (`id`) ON DELETE SET NULL;

-- Alter the column in 'payment' to match the data type and attributes of 'room'
ALTER TABLE `payment` MODIFY COLUMN `id` int(10) unsigned NOT NULL;

-- Add the foreign key constraint between 'payment' and 'room'
ALTER TABLE `payment`
ADD CONSTRAINT `fk_payment_room_id` FOREIGN KEY (`id`) REFERENCES `room` (`id`) ON DELETE CASCADE;

ALTER TABLE `roombook`
ADD CONSTRAINT `fk_roombook_room_id` FOREIGN KEY (`id`) REFERENCES `room` (`id`) ON DELETE CASCADE;

-- ALTER TABLE `roombook`
-- ADD CONSTRAINT `fk_roombook_payment_id` FOREIGN KEY (`id`) REFERENCES `payment` (`id`) ON DELETE CASCADE;

ALTER TABLE `login`
ADD CONSTRAINT `fk_login_contact_id` FOREIGN KEY (`id`) REFERENCES `contact` (`id`) ON DELETE CASCADE;



-- Triggers
DELIMITER //

-- Trigger before inserting into payment table
CREATE TRIGGER before_payment_insert
BEFORE INSERT
ON payment FOR EACH ROW
BEGIN
    SET NEW.fintot = NEW.ttot * 1.1; -- Assuming a 10% increase for demonstration purposes
END;
//

-- Trigger after inserting into payment table
CREATE TRIGGER after_payment_insert
AFTER INSERT
ON payment FOR EACH ROW
BEGIN
    -- Logging the insertion in the audit table
    INSERT INTO audit_table (action, table_name, record_id)
    VALUES ('INSERT', 'payment', NEW.id);
END;
//

DELIMITER ;


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

DELIMITER ;

DELIMITER //

CREATE FUNCTION get_approval_status_from_roombook(roombook_id INT) RETURNS VARCHAR(20)
DETERMINISTIC
NO SQL
BEGIN
    DECLARE approval_status VARCHAR(20);

    -- Using a nested query to concatenate 'Approval: ' with the approval status
    SELECT CONCAT('Approval: ', stat)
    INTO approval_status
    FROM roombook
    WHERE id = roombook_id;

    RETURN approval_status;
END;
//

DELIMITER ;
