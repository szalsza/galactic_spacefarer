
DROP VIEW IF EXISTS GalacticSpacefarerService_SpacefarerAchievements;
DROP VIEW IF EXISTS GalacticSpacefarerService_Positions;
DROP VIEW IF EXISTS GalacticSpacefarerService_Departments;
DROP VIEW IF EXISTS GalacticSpacefarerService_Spacefarers;
DROP TABLE IF EXISTS cds_outbox_Messages;
DROP TABLE IF EXISTS SpacefarerAchievements;
DROP TABLE IF EXISTS Positions;
DROP TABLE IF EXISTS Departments;
DROP TABLE IF EXISTS Spacefarers;

CREATE TABLE Spacefarers (
  ID NVARCHAR(36) NOT NULL,
  createdAt TIMESTAMP_TEXT,
  createdBy NVARCHAR(255),
  modifiedAt TIMESTAMP_TEXT,
  modifiedBy NVARCHAR(255),
  firstName NVARCHAR(80),
  lastName NVARCHAR(80),
  callSign NVARCHAR(60),
  contactEmail NVARCHAR(255),
  originPlanet NVARCHAR(255),
  cosmicSpecies NVARCHAR(255),
  spacesuitColor NVARCHAR(255),
  spacesuitPattern NVARCHAR(80),
  stardustCollection DECIMAL(9, 2) DEFAULT 0,
  wormholeNavigationSkill INTEGER DEFAULT 0,
  gravityToleranceFactor DECIMAL(4, 2) DEFAULT 1.0,
  cosmicAlignment NVARCHAR(255),
  preferredStarshipClass NVARCHAR(255),
  hasQuantumCompanion BOOLEAN DEFAULT FALSE,
  quantumCompanionName NVARCHAR(80),
  languagesSpoken NVARCHAR(255),
  joinedAt DATE_TEXT,
  lastNebulaSurvey DATETIME_TEXT,
  department_ID NVARCHAR(36),
  position_ID NVARCHAR(36),
  PRIMARY KEY(ID)
);


CREATE TABLE Departments (
  ID NVARCHAR(36) NOT NULL,
  createdAt TIMESTAMP_TEXT,
  createdBy NVARCHAR(255),
  modifiedAt TIMESTAMP_TEXT,
  modifiedBy NVARCHAR(255),
  name NVARCHAR(111),
  commandDeck BOOLEAN DEFAULT FALSE,
  description NVARCHAR(255),
  flagshipStarship NVARCHAR(255),
  PRIMARY KEY(ID)
);


CREATE TABLE Positions (
  ID NVARCHAR(36) NOT NULL,
  createdAt TIMESTAMP_TEXT,
  createdBy NVARCHAR(255),
  modifiedAt TIMESTAMP_TEXT,
  modifiedBy NVARCHAR(255),
  title NVARCHAR(111),
  grade NVARCHAR(30),
  missionType NVARCHAR(50),
  requiresTelemetry BOOLEAN DEFAULT FALSE,
  PRIMARY KEY(ID)
);


CREATE TABLE SpacefarerAchievements (
  ID NVARCHAR(36) NOT NULL,
  createdAt TIMESTAMP_TEXT,
  createdBy NVARCHAR(255),
  modifiedAt TIMESTAMP_TEXT,
  modifiedBy NVARCHAR(255),
  spacefarer_ID NVARCHAR(36),
  title NVARCHAR(120),
  narrative NVARCHAR(500),
  awardedOn DATE_TEXT,
  stardustBonus DECIMAL(9, 2),
  missionSector NVARCHAR(60),
  PRIMARY KEY(ID)
);


CREATE TABLE cds_outbox_Messages (
  ID NVARCHAR(36) NOT NULL,
  timestamp TIMESTAMP_TEXT,
  target NVARCHAR(255),
  msg NCLOB,
  attempts INTEGER DEFAULT 0,
  "partition" INTEGER DEFAULT 0,
  lastError NCLOB,
  lastAttemptTimestamp TIMESTAMP_TEXT,
  status NVARCHAR(23),
  PRIMARY KEY(ID)
);


CREATE VIEW GalacticSpacefarerService_Spacefarers AS SELECT
  SpacefarersEntity_0.ID,
  SpacefarersEntity_0.firstName,
  SpacefarersEntity_0.lastName,
  SpacefarersEntity_0.callSign,
  SpacefarersEntity_0.contactEmail,
  SpacefarersEntity_0.originPlanet,
  SpacefarersEntity_0.cosmicSpecies,
  SpacefarersEntity_0.spacesuitColor,
  SpacefarersEntity_0.spacesuitPattern,
  SpacefarersEntity_0.stardustCollection,
  SpacefarersEntity_0.wormholeNavigationSkill,
  SpacefarersEntity_0.gravityToleranceFactor,
  SpacefarersEntity_0.cosmicAlignment,
  SpacefarersEntity_0.preferredStarshipClass,
  SpacefarersEntity_0.hasQuantumCompanion,
  SpacefarersEntity_0.quantumCompanionName,
  SpacefarersEntity_0.languagesSpoken,
  SpacefarersEntity_0.joinedAt,
  SpacefarersEntity_0.lastNebulaSurvey,
  SpacefarersEntity_0.department_ID,
  SpacefarersEntity_0.position_ID,
  SpacefarersEntity_0.createdBy,
  SpacefarersEntity_0.createdAt,
  SpacefarersEntity_0.modifiedBy,
  SpacefarersEntity_0.modifiedAt
FROM Spacefarers AS SpacefarersEntity_0;


CREATE VIEW GalacticSpacefarerService_Departments AS SELECT
  DepartmentsEntity_0.ID,
  DepartmentsEntity_0.name,
  DepartmentsEntity_0.commandDeck,
  DepartmentsEntity_0.description,
  DepartmentsEntity_0.flagshipStarship
FROM Departments AS DepartmentsEntity_0;


CREATE VIEW GalacticSpacefarerService_Positions AS SELECT
  PositionsEntity_0.ID,
  PositionsEntity_0.title,
  PositionsEntity_0.grade,
  PositionsEntity_0.missionType,
  PositionsEntity_0.requiresTelemetry
FROM Positions AS PositionsEntity_0;


CREATE VIEW GalacticSpacefarerService_SpacefarerAchievements AS SELECT
  SpacefarerAchievementsEntity_0.ID,
  SpacefarerAchievementsEntity_0.spacefarer_ID,
  SpacefarerAchievementsEntity_0.title,
  SpacefarerAchievementsEntity_0.narrative,
  SpacefarerAchievementsEntity_0.awardedOn,
  SpacefarerAchievementsEntity_0.stardustBonus,
  SpacefarerAchievementsEntity_0.missionSector,
  SpacefarerAchievementsEntity_0.createdBy,
  SpacefarerAchievementsEntity_0.createdAt,
  SpacefarerAchievementsEntity_0.modifiedBy,
  SpacefarerAchievementsEntity_0.modifiedAt
FROM SpacefarerAchievements AS SpacefarerAchievementsEntity_0;

