--[[
    GD50
    Pokemon

    Author: Colton Ogden
    cogden@cs50.harvard.edu
]]

PLAYER_IDS = {
    'healer_m', 'healer_f', 'mage_m', 'mage_f', 'ninja_m', 'ninja_f', 'ranger_m', 'ranger_f', 'warrior_m', 'warrior_f'
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
    ['healer_m'] = {
        type = 'Healer',
        description = 'Can heal allies',
        offset = 0,
        baseHP = 14,
        baseAttack = 9,
        baseDefense = 5,
        baseSpeed = 6,
    },
    ['healer_f'] = {
        type = 'Healer',
        description = 'Can heal allies',
        offset = 0,
        baseHP = 12,
        baseAttack = 7,
        baseDefense = 3,
        baseSpeed = 7,
    },
    ['mage_m'] = {
        type = 'Mage',
        description = 'Can cast offensive spells',
        offset = 0,
        baseHP = 11,
        baseAttack = 5,
        baseDefense = 5,
        baseSpeed = 6,
    },
    ['mage_f'] = {
        type = 'Mage',
        description = 'Can cast offensive spells',
        offset = -0.5,
        baseHP = 13,
        baseAttack = 6,
        baseDefense = 4,
        baseSpeed = 7,
    },
    ['ninja_m'] = {
        name = 'ninja_m',
        type = 'Ninja',
        description = 'Can steal from enemies',
        offset = -0.5,
        baseHP = 11,
        baseAttack = 5,
        baseDefense = 5,
        baseSpeed = 6,
    },
    ['ninja_f'] = {
        type = 'Ninja',
        description = 'Can steal from enemies',
        offset = 0,
        baseHP = 13,
        baseAttack = 6,
        baseDefense = 4,
        baseSpeed = 7,
    },
    ['ranger_m'] = {
        type = 'Ranger',
        description = 'Good ranged attack',
        offset = -0.5,
        baseHP = 11,
        baseAttack = 5,
        baseDefense = 5,
        baseSpeed = 6,
    },
    ['ranger_f'] = {
        type = 'Ranger',
        description = 'Good ranged attack',
        offset = 0,
        baseHP = 13,
        baseAttack = 6,
        baseDefense = 4,
        baseSpeed = 7,
    },
    ['warrior_m'] = {
        type = 'Warrior',
        description = 'High offense & defense',
        offset = -0.5,
        baseHP = 11,
        baseAttack = 5,
        baseDefense = 5,
        baseSpeed = 6,
    },
    ['warrior_f'] = {
        type = 'Warrior',
        description = 'High offense & defense',
        offset = 0,
        baseHP = 13,
        baseAttack = 6,
        baseDefense = 4,
        baseSpeed = 7,
    }
}
