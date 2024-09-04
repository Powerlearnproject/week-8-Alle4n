-- Create the MzuriFarming database
CREATE DATABASE MzuriFarming;

-- Select MzuriFarming database
USE MzuriFarming;

-- Create the Users table
CREATE TABLE Users (
    UserID INT AUTO_INCREMENT PRIMARY KEY,
    Username VARCHAR(50) UNIQUE NOT NULL,
    PasswordHash CHAR(64) NOT NULL, -- SHA-256 hash
    Email VARCHAR(100) UNIQUE NOT NULL,
    Role ENUM('Farmer', 'Agronomist', 'Researcher', 'Admin') NOT NULL,
    CreatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create the Farmers table
CREATE TABLE Farmers (
    FarmerID INT AUTO_INCREMENT PRIMARY KEY,
    UserID INT,
    FullName VARCHAR(100) NOT NULL,
    PhoneNumber VARCHAR(15),
    Location VARCHAR(255),
    FarmSize DECIMAL(10, 2), -- in hectares
    FOREIGN KEY (UserID) REFERENCES Users(UserID) ON DELETE CASCADE
);

-- Create the Crops table
CREATE TABLE Crops (
    CropID INT AUTO_INCREMENT PRIMARY KEY,
    CropName VARCHAR(100) NOT NULL,
    ScientificName VARCHAR(100),
    AverageYield DECIMAL(10, 2) -- in kg per hectare
);

-- Create the WeatherData table
CREATE TABLE WeatherData (
    WeatherID INT AUTO_INCREMENT PRIMARY KEY,
    Location VARCHAR(255),
    Date DATE,
    Temperature DECIMAL(5, 2), -- in Celsius
    Humidity DECIMAL(5, 2), -- in percentage
    Rainfall DECIMAL(5, 2), -- in mm
    WeatherCondition VARCHAR(100) -- e.g., Sunny, Rainy
);

-- Create the SoilConditions table
CREATE TABLE SoilConditions (
    SoilID INT AUTO_INCREMENT PRIMARY KEY,
    Location VARCHAR(255),
    pH DECIMAL(4, 2),
    OrganicMatter DECIMAL(5, 2), -- in percentage
    Nitrogen DECIMAL(5, 2), -- in percentage
    Phosphorus DECIMAL(5, 2), -- in ppm
    Potassium DECIMAL(5, 2) -- in ppm
);

-- Create the CropYield table
CREATE TABLE CropYield (
    YieldID INT AUTO_INCREMENT PRIMARY KEY,
    FarmerID INT,
    CropID INT,
    Year INT,
    Yield DECIMAL(10, 2), -- in kg
    FOREIGN KEY (FarmerID) REFERENCES Farmers(FarmerID) ON DELETE CASCADE,
    FOREIGN KEY (CropID) REFERENCES Crops(CropID) ON DELETE CASCADE
);

-- Create the Subscriptions table
CREATE TABLE Subscriptions (
    SubscriptionID INT AUTO_INCREMENT PRIMARY KEY,
    UserID INT,
    Plan ENUM('Basic', 'Standard', 'Professional') NOT NULL,
    StartDate DATE NOT NULL,
    EndDate DATE NOT NULL,
    Status ENUM('Active', 'Inactive', 'Expired') NOT NULL,
    FOREIGN KEY (UserID) REFERENCES Users(UserID) ON DELETE CASCADE
);

-- Create the Reports table
CREATE TABLE Reports (
    ReportID INT AUTO_INCREMENT PRIMARY KEY,
    UserID INT,
    ReportType ENUM('Yield', 'Weather', 'Soil', 'Custom') NOT NULL,
    GeneratedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    ReportData TEXT, -- JSON or CSV format data
    FOREIGN KEY (UserID) REFERENCES Users(UserID) ON DELETE CASCADE
);

-- Create the ConsultingRequests table
CREATE TABLE ConsultingRequests (
    RequestID INT AUTO_INCREMENT PRIMARY KEY,
    UserID INT,
    RequestDate TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    Status ENUM('Pending', 'In Progress', 'Completed', 'Cancelled') NOT NULL,
    Description TEXT,
    FOREIGN KEY (UserID) REFERENCES Users(UserID) ON DELETE CASCADE
);

-- Indexes for performance
CREATE INDEX idx_location_weatherdata ON WeatherData(Location);
CREATE INDEX idx_location_soilconditions ON SoilConditions(Location);
CREATE INDEX idx_userid_farmers ON Farmers(UserID);
CREATE INDEX idx_userid_subscriptions ON Subscriptions(UserID);
CREATE INDEX idx_userid_reports ON Reports(UserID);
CREATE INDEX idx_userid_consultingrequests ON ConsultingRequests(UserID);
CREATE INDEX idx_cropid_cropyield ON CropYield(CropID);
CREATE INDEX idx_farmerid_cropyield ON CropYield(FarmerID);
