Enemy = Class{}

function Enemy:init(def)
    self.name = def.name == 'dragon' and 'Dragon' or def.name
    self.HP = ENEMY_DEFS[def.name]['HP']
    self.attack = ENEMY_DEFS[def.name]['attack']
    self.defense = ENEMY_DEFS[def.name]['defense']
    self.speed = ENEMY_DEFS[def.name]['speed']
    self.exp = ENEMY_DEFS[def.name]['exp']

    self.tookTurn = false
    self.dead = false
    self.isPlayer = false
    
    if self.name == 'Dragon' then
        self.battleSprite = BattleSprite(gTextures['dragon'], nil, 5, 30)
    else
        -- define the placement of the enemy's battle sprite based on their number
        local battleX = VIRTUAL_WIDTH / 8 + (def.enemy_num % 2) * 20
        local battleY =  35 + (def.enemy_num - 1) * 25
        self.battleSprite = BattleSprite(gTextures['enemies'], gFrames['enemies'][ENEMY_DEFS[def.name]['frame']], battleX, battleY)
    end
end
