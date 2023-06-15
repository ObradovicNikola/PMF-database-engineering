-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema libraryOLAP
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema libraryOLAP
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `libraryOLAP` DEFAULT CHARACTER SET utf8 ;
USE `libraryOLAP` ;

-- -----------------------------------------------------
-- Table `libraryOLAP`.`Book_DW`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `libraryOLAP`.`Book_DW` (
  `idBook` INT NOT NULL AUTO_INCREMENT,
  `title` VARCHAR(45) NOT NULL,
  `publishYear` INT NOT NULL,
  `author` VARCHAR(100) NOT NULL,
  `publisher` VARCHAR(45) NOT NULL,
  `averageNumberOfBookRetentionDays` DOUBLE NULL,
  PRIMARY KEY (`idBook`),
  UNIQUE INDEX `idBook_UNIQUE` (`idBook` ASC) VISIBLE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `libraryOLAP`.`Genre_DW`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `libraryOLAP`.`Genre_DW` (
  `idGenre` INT NOT NULL AUTO_INCREMENT,
  `title` VARCHAR(45) NOT NULL,
  `totalNumberOfBooks` INT NOT NULL,
  PRIMARY KEY (`idGenre`),
  UNIQUE INDEX `idGenre_UNIQUE` (`idGenre` ASC) VISIBLE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `libraryOLAP`.`Book_has_Genre_DW`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `libraryOLAP`.`Book_has_Genre_DW` (
  `idBook` INT NOT NULL,
  `idGenre` INT NOT NULL,
  PRIMARY KEY (`idBook`, `idGenre`),
  INDEX `fk_Book_has_Genre_Genre1_idx` (`idGenre` ASC) VISIBLE,
  INDEX `fk_Book_has_Genre_Book1_idx` (`idBook` ASC) VISIBLE,
  CONSTRAINT `fk_Book_has_Genre_Book1`
    FOREIGN KEY (`idBook`)
    REFERENCES `libraryOLAP`.`Book_DW` (`idBook`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Book_has_Genre_Genre1`
    FOREIGN KEY (`idGenre`)
    REFERENCES `libraryOLAP`.`Genre_DW` (`idGenre`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `libraryOLAP`.`BookStore_DW`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `libraryOLAP`.`BookStore_DW` (
  `idBookStore` INT NOT NULL AUTO_INCREMENT,
  `city` VARCHAR(45) NOT NULL,
  `address` VARCHAR(45) NOT NULL,
  `rentedBooksForPastMonth` INT NOT NULL DEFAULT 0,
  PRIMARY KEY (`idBookStore`),
  UNIQUE INDEX `idBookStore_UNIQUE` (`idBookStore` ASC) VISIBLE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `libraryOLAP`.`Time_DW`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `libraryOLAP`.`Time_DW` (
  `idTime_DW` INT NOT NULL,
  `day` INT NOT NULL,
  `month` VARCHAR(45) NOT NULL,
  `year` INT NOT NULL,
  `monthInYear` INT NOT NULL,
  `date` DATE NOT NULL,
  PRIMARY KEY (`idTime_DW`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `libraryOLAP`.`ActiveMembership_DW`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `libraryOLAP`.`ActiveMembership_DW` (
  `idActiveMembership` INT NOT NULL AUTO_INCREMENT,
  `startDate` DATE NOT NULL,
  `expirationDate` DATE NOT NULL,
  `type` VARCHAR(45) NOT NULL,
  `price` VARCHAR(45) NOT NULL,
  `Time_DW_idTime_DW` INT NOT NULL,
  PRIMARY KEY (`idActiveMembership`),
  UNIQUE INDEX `idActiveMembership_UNIQUE` (`idActiveMembership` ASC) VISIBLE,
  INDEX `fk_ActiveMembership_DW_Time_DW1_idx` (`Time_DW_idTime_DW` ASC) VISIBLE,
  CONSTRAINT `fk_ActiveMembership_DW_Time_DW1`
    FOREIGN KEY (`Time_DW_idTime_DW`)
    REFERENCES `libraryOLAP`.`Time_DW` (`idTime_DW`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `libraryOLAP`.`Book_has_BookStore_DW`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `libraryOLAP`.`Book_has_BookStore_DW` (
  `idBook` INT NOT NULL,
  `idBookStore` INT NOT NULL,
  `rentedCount` INT NOT NULL,
  `availableCount` INT NOT NULL,
  PRIMARY KEY (`idBook`, `idBookStore`),
  INDEX `fk_Book_has_BookStore_BookStore1_idx` (`idBookStore` ASC) VISIBLE,
  INDEX `fk_Book_has_BookStore_Book1_idx` (`idBook` ASC) VISIBLE,
  CONSTRAINT `fk_Book_has_BookStore_Book1`
    FOREIGN KEY (`idBook`)
    REFERENCES `libraryOLAP`.`Book_DW` (`idBook`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Book_has_BookStore_BookStore1`
    FOREIGN KEY (`idBookStore`)
    REFERENCES `libraryOLAP`.`BookStore_DW` (`idBookStore`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `libraryOLAP`.`RentedBook_DW`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `libraryOLAP`.`RentedBook_DW` (
  `idRentedBook` INT NOT NULL AUTO_INCREMENT,
  `startRentDate` DATE NOT NULL,
  `returnDate` DATE NULL,
  `rentLimitDate` DATE NOT NULL,
  `idBook` INT NOT NULL,
  `idBookStore` INT NOT NULL,
  `Time_DW_idTime_DW` INT NOT NULL,
  PRIMARY KEY (`idRentedBook`),
  UNIQUE INDEX `idRentedBook_UNIQUE` (`idRentedBook` ASC) VISIBLE,
  INDEX `fk_RentedBook_Book_has_BookStore1_idx` (`idBook` ASC, `idBookStore` ASC) VISIBLE,
  INDEX `fk_RentedBook_DW_Time_DW1_idx` (`Time_DW_idTime_DW` ASC) VISIBLE,
  CONSTRAINT `fk_RentedBook_Book_has_BookStore1`
    FOREIGN KEY (`idBook` , `idBookStore`)
    REFERENCES `libraryOLAP`.`Book_has_BookStore_DW` (`idBook` , `idBookStore`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_RentedBook_DW_Time_DW1`
    FOREIGN KEY (`Time_DW_idTime_DW`)
    REFERENCES `libraryOLAP`.`Time_DW` (`idTime_DW`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
