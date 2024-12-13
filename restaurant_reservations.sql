DROP DATABASE IF EXISTS restaurant_reservations;

CREATE DATABASE restaurant_reservations;
USE restaurant_reservations;

CREATE TABLE Customers (
    customerId INT NOT NULL UNIQUE AUTO_INCREMENT,
    customerName VARCHAR(45) NOT NULL,
    contactInfo VARCHAR(200),
    PRIMARY KEY (customerId)
);

CREATE TABLE Reservations (
    reservationId INT NOT NULL UNIQUE AUTO_INCREMENT,
    customerId INT NOT NULL,
    reservationTime DATETIME NOT NULL,
    numberOfGuests INT NOT NULL,
    specialRequests VARCHAR(200),
    PRIMARY KEY (reservationId),
    FOREIGN KEY (customerId) REFERENCES Customers(customerId)
);

CREATE TABLE DiningPreferences (
    preferenceId INT NOT NULL UNIQUE AUTO_INCREMENT,
    customerId INT NOT NULL,
    favoriteTable VARCHAR(45),
    dietaryRestrictions VARCHAR(200),
    PRIMARY KEY (preferenceId),
    FOREIGN KEY (customerId) REFERENCES Customers(customerId)
);

INSERT INTO Customers (customerName, contactInfo)
VALUES 
    ('Iman Talukder', 'Iman.Talukder@example.com'),
    ('Will Smith', 'Will.smith@example.com'),
    ('Stephen Johnson', 'Stephen.johnson@example.com');

INSERT INTO Reservations (customerId, reservationTime, numberOfGuests, specialRequests)
VALUES 
    (1, '2024-12-08 18:30:00', 4, 'NBA Cup Finals'),
    (2, '2024-12-02 19:00:00', 2, 'NBA'),
    (3, '2024-12-02 20:15:00', 5, 'Birthday celebration');

INSERT INTO DiningPreferences (customerId, favoriteTable, dietaryRestrictions)
VALUES 
    (1, 'Table 32323232', 'MEAT ONLY'),
    (2, 'Table 1123123', 'None'),
    (3, 'Table 1000', 'Gluten-Free');

DELIMITER $$
CREATE PROCEDURE findReservations(IN customerId INT)
BEGIN
    SELECT * FROM Reservations WHERE customerId = customerId;
END $$
DELIMITER ;

DELIMITER $$
CREATE PROCEDURE addSpecialRequest(
    IN reservationId INT,
    IN requests VARCHAR(200)
)
BEGIN
    UPDATE Reservations
    SET specialRequests = requests
    WHERE reservationId = reservationId;
END $$
DELIMITER ;

DELIMITER $$
CREATE PROCEDURE addReservation(
    IN customerName VARCHAR(45),
    IN contactInfo VARCHAR(200),
    IN reservationTime DATETIME,
    IN numberOfGuests INT,
    IN specialRequests VARCHAR(200)
)
BEGIN
    DECLARE customerId INT;

    SELECT customerId INTO customerId FROM Customers
    WHERE customerName = customerName AND contactInfo = contactInfo;

    IF customerId IS NULL THEN
        INSERT INTO Customers (customerName, contactInfo)
        VALUES (customerName, contactInfo);
        SET customerId = LAST_INSERT_ID();
    END IF;

    INSERT INTO Reservations (customerId, reservationTime, numberOfGuests, specialRequests)
    VALUES (customerId, reservationTime, numberOfGuests, specialRequests);
END $$
DELIMITER ;

