--[[
    GD50
    Legend of Zelda

    Author: Colton Ogden
    cogden@cs50.harvard.edu
]]

NPC_DEFS = {
    ['man'] = {
        width = 32,
        height = 36,
        offset = -0.5,
        texture = 'townfolk1_m',
        animations = {
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
    },
    ['woman'] = {
        width = 32,
        height = 36,
        offset = 0,
        texture = 'townfolk1_f',
        animations = {
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
    }
}
