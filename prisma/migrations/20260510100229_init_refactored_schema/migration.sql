-- CreateTable
CREATE TABLE `Patient` (
    `id` INTEGER NOT NULL AUTO_INCREMENT,
    `fullName` VARCHAR(191) NOT NULL,
    `dob` DATE NOT NULL,
    `sex` ENUM('MALE', 'FEMALE', 'NON_BINARY', 'UNKNOWN') NOT NULL DEFAULT 'UNKNOWN',
    `address1` VARCHAR(191) NULL,
    `address2` VARCHAR(191) NULL,
    `city` VARCHAR(191) NULL,
    `totalVisits` INTEGER NOT NULL DEFAULT 0,

    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `PatientPhone` (
    `id` INTEGER NOT NULL AUTO_INCREMENT,
    `number` VARCHAR(191) NOT NULL,
    `patientId` INTEGER NOT NULL,

    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `Department` (
    `id` INTEGER NOT NULL AUTO_INCREMENT,
    `name` VARCHAR(191) NOT NULL,
    `hodName` VARCHAR(191) NULL,
    `budget` DOUBLE NOT NULL,

    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `Doctor` (
    `id` INTEGER NOT NULL AUTO_INCREMENT,
    `fullName` VARCHAR(191) NOT NULL,
    `speciality` VARCHAR(191) NOT NULL,
    `contactNo` VARCHAR(191) NOT NULL,
    `joinDate` DATE NOT NULL,
    `salary` DOUBLE NOT NULL,
    `isActive` BOOLEAN NOT NULL DEFAULT true,
    `departmentId` INTEGER NOT NULL,

    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `Appointment` (
    `id` INTEGER NOT NULL AUTO_INCREMENT,
    `date` DATETIME(3) NOT NULL,
    `status` ENUM('PENDING', 'COMPLETE', 'CANCEL', 'HOLD', 'RESCHEDULED') NOT NULL DEFAULT 'PENDING',
    `fee` DOUBLE NOT NULL,
    `discount` DOUBLE NOT NULL DEFAULT 0,
    `roomNumber` VARCHAR(191) NOT NULL,
    `blockName` VARCHAR(191) NOT NULL,
    `patientId` INTEGER NOT NULL,
    `doctorId` INTEGER NOT NULL,

    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `Billing` (
    `billNo` VARCHAR(191) NOT NULL,
    `svcCost` DOUBLE NOT NULL,
    `taxPct` DOUBLE NOT NULL,
    `paid` DOUBLE NOT NULL DEFAULT 0,
    `createdAt` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
    `createdBy` VARCHAR(191) NOT NULL,
    `patientId` INTEGER NOT NULL,

    PRIMARY KEY (`billNo`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `CatalogService` (
    `id` INTEGER NOT NULL AUTO_INCREMENT,
    `serviceName` VARCHAR(191) NOT NULL,
    `basePrice` DOUBLE NOT NULL,

    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `BillingService` (
    `billNo` VARCHAR(191) NOT NULL,
    `serviceId` INTEGER NOT NULL,

    PRIMARY KEY (`billNo`, `serviceId`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- AddForeignKey
ALTER TABLE `PatientPhone` ADD CONSTRAINT `PatientPhone_patientId_fkey` FOREIGN KEY (`patientId`) REFERENCES `Patient`(`id`) ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `Doctor` ADD CONSTRAINT `Doctor_departmentId_fkey` FOREIGN KEY (`departmentId`) REFERENCES `Department`(`id`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `Appointment` ADD CONSTRAINT `Appointment_patientId_fkey` FOREIGN KEY (`patientId`) REFERENCES `Patient`(`id`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `Appointment` ADD CONSTRAINT `Appointment_doctorId_fkey` FOREIGN KEY (`doctorId`) REFERENCES `Doctor`(`id`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `Billing` ADD CONSTRAINT `Billing_patientId_fkey` FOREIGN KEY (`patientId`) REFERENCES `Patient`(`id`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `BillingService` ADD CONSTRAINT `BillingService_billNo_fkey` FOREIGN KEY (`billNo`) REFERENCES `Billing`(`billNo`) ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `BillingService` ADD CONSTRAINT `BillingService_serviceId_fkey` FOREIGN KEY (`serviceId`) REFERENCES `CatalogService`(`id`) ON DELETE CASCADE ON UPDATE CASCADE;
