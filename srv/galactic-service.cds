using {
  Departments       as DepartmentsEntity,
  Positions         as PositionsEntity,
  Spacefarers       as SpacefarersEntity,
  SpacefarerAchievements as SpacefarerAchievementsEntity
} from '../db/schema';

/**
 * GalacticSpacefarerService exposes the persistency model that is defined in db/schema.cds.
 * The projections below explicitly mirror the database schema to keep both layers aligned
 * while adding security annotations to protect the data from unauthorised access.
 */
service GalacticSpacefarerService @(path: '/galactic-spacefarers') {

  @requires: 'authenticated-user'
  @Capabilities: { Read: true, Insert: true, Update: true, Delete: true }
  @restrict: [
    { grant: ['*'],    to: ['SpacefarerAdmin', 'SpacefarerLieutenant'] },
    { grant: ['READ'], to: ['SpacefarerCadet'], where: 'originPlanet = $user.originPlanet' }
  ]
  entity Spacefarers as projection on SpacefarersEntity {
    key ID,
    firstName,
    lastName,
    callSign,
    contactEmail,
    originPlanet,
    cosmicSpecies,
    spacesuitColor,
    spacesuitPattern,
    stardustCollection,
    wormholeNavigationSkill,
    gravityToleranceFactor,
    cosmicAlignment,
    preferredStarshipClass,
    hasQuantumCompanion,
    quantumCompanionName,
    languagesSpoken,
    joinedAt,
    lastNebulaSurvey,
    department,
    position,
    achievements,
    createdBy,
    createdAt,
    modifiedBy,
    modifiedAt
  };

  @requires: 'authenticated-user'
  @Capabilities: { Read: true }
  @restrict: [
    { grant: ['READ'], to: ['SpacefarerAdmin', 'SpacefarerLieutenant', 'SpacefarerCadet'] }
  ]
  entity Departments as projection on DepartmentsEntity {
    key ID,
    name,
    commandDeck,
    description,
    flagshipStarship
  };

  @requires: 'authenticated-user'
  @Capabilities: { Read: true }
  @restrict: [
    { grant: ['READ'], to: ['SpacefarerAdmin', 'SpacefarerLieutenant', 'SpacefarerCadet'] }
  ]
  entity Positions as projection on PositionsEntity {
    key ID,
    title,
    grade,
    missionType,
    requiresTelemetry
  };

  @requires: 'authenticated-user'
  @Capabilities: { Read: true, Insert: true, Update: true, Delete: true }
  @restrict: [
    { grant: ['*'],    to: ['SpacefarerAdmin', 'SpacefarerLieutenant'] },
    { grant: ['READ'], to: ['SpacefarerCadet'], where: 'spacefarer.originPlanet = $user.originPlanet' }
  ]
  entity SpacefarerAchievements as projection on SpacefarerAchievementsEntity {
    key ID,
    spacefarer,
    title,
    narrative,
    awardedOn,
    stardustBonus,
    missionSector,
    createdBy,
    createdAt,
    modifiedBy,
    modifiedAt
  };
}