using { cuid, managed } from '@sap/cds/common';

type StardustLevel : Decimal(9,2);
type NavigationSkillLevel : Integer;
type GravityTolerance : Decimal(4,2); // multiplier for extreme gravity environments

type SpacesuitColor : String enum {
    MidnightNebula    = 'Midnight Nebula';
    SolarFlare        = 'Solar Flare';
    AuroraWave        = 'Aurora Wave';
    QuantumSilver     = 'Quantum Silver';
    CosmicCoral       = 'Cosmic Coral';
    DarkMatterIndigo  = 'Dark Matter Indigo';
};

type OriginPlanet : String enum {
    TerraNova    = 'Terra Nova';
    Kepler62f    = 'Kepler-62f';
    AndaraPrime  = 'Andara Prime';
    Xenthara     = 'Xenthara';
    LyraStation  = 'Lyra Station';
    UmbraNine    = 'Umbra Nine';
};

type CosmicSpecies : String enum {
    Human          = 'Human';
    Celestian      = 'Celestian';
    Nebulon        = 'Nebulon';
    QuasarMorph    = 'Quasar Morph';
    Chronite       = 'Chronite';
};

type StarshipClass : String enum {
    Pathfinder   = 'Pathfinder';
    Vanguard     = 'Vanguard';
    Luminary     = 'Luminary';
    Eclipse      = 'Eclipse';
    Horizon      = 'Horizon';
};

type CosmicAlignment : String enum {
    Stellar      = 'Stellar';
    Astral       = 'Astral';
    Quantum      = 'Quantum';
    Temporal     = 'Temporal';
};

entity Departments : cuid, managed {
    name             : String(111);
    commandDeck      : Boolean default false;
    description      : String(255);
    flagshipStarship : StarshipClass;
    spacefarers      : Association to many Spacefarers on spacefarers.department = $self;
}

entity Positions : cuid, managed {
    title             : String(111);
    grade             : String(30);
    missionType       : String(50);
    requiresTelemetry : Boolean default false;
    spacefarers       : Association to many Spacefarers on spacefarers.position = $self;
}

entity Spacefarers : cuid, managed {
    firstName                : String(80);
    lastName                 : String(80);
    callSign                 : String(60);
    originPlanet             : OriginPlanet;
    cosmicSpecies            : CosmicSpecies;
    spacesuitColor           : SpacesuitColor;
    spacesuitPattern         : String(80);
    stardustCollection       : StardustLevel default 0;
    wormholeNavigationSkill  : NavigationSkillLevel default 0;
    gravityToleranceFactor   : GravityTolerance default 1.00;
    cosmicAlignment          : CosmicAlignment;
    preferredStarshipClass   : StarshipClass;
    hasQuantumCompanion      : Boolean default false;
    quantumCompanionName     : String(80);
    languagesSpoken          : String(255);
    joinedAt                 : Date;
    lastNebulaSurvey         : DateTime;
    department               : Association to Departments;
    position                 : Association to Positions;
    achievements             : Composition of many SpacefarerAchievements on achievements.spacefarer = $self;
}

entity SpacefarerAchievements : cuid, managed {
    spacefarer      : Association to Spacefarers;
    title           : String(120);
    narrative       : String(500);
    awardedOn       : Date;
    stardustBonus   : StardustLevel;
    missionSector   : String(60);
}