PLAYER_IDS = {
    'warrior_m', 'healer_m', 'mage_m', 'ninja_m', 'ranger_m', 'warrior_f', 'healer_f', 'mage_f', 'ninja_f', 'ranger_f'
}

PLAYER_ANIMATIONS = {
    ['walk-up'] = {
        frames = {1, 2, 3, 2},
        interval = 0.12
    },
    ['walk-right'] = {
        frames = {4, 5, 6, 5},
        interval = 0.12
    },
    ['walk-down'] = {
        frames = {7, 8, 9, 8},
        interval = 0.12
    },
    ['walk-left'] = {
        frames = {10, 11, 12, 11},
        interval = 0.12
    },
    ['idle-up'] = {
        frames = {2}
    },
    ['idle-right'] = {
        frames = {5}
    },
    ['idle-down'] = {
        frames = {8}
    },
    ['idle-left'] = {
        frames = {11}
    }
}

PLAYER_DEFS = {
    ['width'] = 32,
    ['height'] = 36,
    ['scale'] = 0.5,
    ['healer_m'] = {
        type = 'Healer',
        description = 'Can heal allies',
        abilityType = 'Magic',
        abilities = { {'Cure', 10, 'ally'}, {'Curaga', 30, 'all'} },
        offset = 0,
        baseHP = 120,
        baseMP = 50,
        baseAttack = 10,
        baseDefense = 8,
        baseSpeed = 10
    },
    ['healer_f'] = {
        type = 'Healer',
        description = 'Can heal allies',
        abilityType = 'Magic',
        abilities = { {'Cure', 10, 'ally'}, {'Curaga', 30, 'all'} },
        offset = 0,
        baseHP = 120,
        baseMP = 50,
        baseAttack = 10,
        baseDefense = 8,
        baseSpeed = 10
    },
    ['mage_m'] = {
        type = 'Mage',
        description = 'Can cast offensive spells',
        abilityType = 'Magic',
        abilities = { {'Fire', 10, 'enemy'}, {'Firaga', 30, 'all'}, {'Blizzard', 10, 'enemy'}, {'Blizzaga', 30, 'all'} },
        offset = 0,
        baseHP = 120,
        baseMP = 50,
        baseAttack = 12,
        baseDefense = 8,
        baseSpeed = 12
    },
    ['mage_f'] = {
        type = 'Mage',
        description = 'Can cast offensive spells',
        abilityType = 'Magic',
        abilities = { {'Fire', 10, 'enemy'}, {'Firaga', 30, 'all'}, {'Blizzard', 10, 'enemy'}, {'Blizzaga', 30, 'all'} },
        offset = -0.5,
        baseHP = 120,
        baseMP = 50,
        baseAttack = 12,
        baseDefense = 8,
        baseSpeed = 12
    },
    ['ninja_m'] = {
        name = 'ninja_m',
        type = 'Ninja',
        description = 'Can steal from enemies',
        abilityType = 'Ability',
        abilities = { {'Steal', 5, 'enemy'} },
        offset = -0.5,
        baseHP = 140,
        baseAP = 25,
        baseAttack = 15,
        baseDefense = 10,
        baseSpeed = 20
    },
    ['ninja_f'] = {
        type = 'Ninja',
        description = 'Can steal from enemies',
        abilityType = 'Ability',
        abilities = { {'Steal', 5, 'enemy'} },
        offset = 0,
        baseHP = 140,
        baseAP = 25,
        baseAttack = 15,
        baseDefense = 10,
        baseSpeed = 20
    },
    ['ranger_m'] = {
        type = 'Ranger',
        description = 'Has powerful ranged attacks',
        abilityType = 'Ability',
        abilities = { {'Sidewinder', 10, 'enemy'}, {'Sonic Boom', 30, 'all'} },
        offset = -0.5,
        baseHP = 140,
        baseAP = 30,
        baseAttack = 15,
        baseDefense = 10,
        baseSpeed = 12
    },
    ['ranger_f'] = {
        type = 'Ranger',
        description = 'Has powerful ranged attacks',
        abilityType = 'Ability',
        abilities = { {'Sidewinder', 10, 'enemy'}, {'Sonic Boom', 30, 'all'} },
        offset = 0,
        baseHP = 140,
        baseAP = 30,
        baseAttack = 15,
        baseDefense = 10,
        baseSpeed = 12
    },
    ['warrior_m'] = {
        type = 'Warrior',
        description = 'Has high offense & defense',
        offset = -0.5,
        baseHP = 160,
        baseAttack = 18,
        baseDefense = 12,
        baseSpeed = 10
    },
    ['warrior_f'] = {
        type = 'Warrior',
        description = 'Has high offense & defense',
        offset = 0,
        baseHP = 160,
        baseAttack = 18,
        baseDefense = 12,
        baseSpeed = 10
    }
}
