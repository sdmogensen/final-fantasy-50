Player = Class{__includes = Entity}

function Player:init(def)
    Entity.init(self, def)

    self.width = PLAYER_DEFS['width']
    self.height = PLAYER_DEFS['height']
    self.scale = PLAYER_DEFS['scale']
    self.offset = PLAYER_DEFS[def.player_id]['offset']
    self.animations = self:createAnimations(PLAYER_ANIMATIONS, def.player_id)

    self.name = PLAYER_DEFS[def.player_id]['type']
    self.attack = PLAYER_DEFS[def.player_id]['baseAttack']
    self.defense = PLAYER_DEFS[def.player_id]['baseDefense']
    self.speed = PLAYER_DEFS[def.player_id]['baseSpeed']
    self.HP = PLAYER_DEFS[def.player_id]['baseHP']
    self.maxHP = PLAYER_DEFS[def.player_id]['baseHP']
    self.MP = PLAYER_DEFS[def.player_id]['baseMP']
    self.maxMP = PLAYER_DEFS[def.player_id]['baseMP']
    self.AP = PLAYER_DEFS[def.player_id]['baseAP']
    self.maxAP = PLAYER_DEFS[def.player_id]['baseAP']
    self.abilityType = PLAYER_DEFS[def.player_id]['abilityType']
    self.abilities = PLAYER_DEFS[def.player_id]['abilities']
    self.level = 1
    self.exp = 0
    self.expToLevel = 120
    self.hasLeveled = false

    self.tookTurn = false
    self.dead = false
    self.isPlayer = true

    local battleX = VIRTUAL_WIDTH * 3 / 4 + ((def.player_num + 1) % 2) * 20
    local battleY = 35 + (def.player_num - 1) * 25
    self.battleSprite = BattleSprite(gTextures[def.player_id], gFrames[def.player_id][PLAYER_ANIMATIONS['idle-left']['frames'][1]], battleX, battleY, self.scale, self.offset)
end

function Player:addExp(exp)
    self.exp = self.exp + exp
    -- level the player up if they have enough exp
    if (self.exp >= self.expToLevel) then
        self.exp = self.exp - self.expToLevel
        self.expToLevel = math.floor(self.expToLevel * 1.3)
        self.level = self.level + 1
        self.hasLeveled = true

        -- increase stats
        self.attack = self.attack + math.random(2,3)
        self.defense = self.attack + math.random(1,2)
        self.speed = self.attack + 1
        local HPIncrease = math.random(7,10)
        self.maxHP = self.maxHP + HPIncrease
        self.HP = self.HP + HPIncrease
        local MPIncrease = math.random(5,8)
        if self.MP then
            self.maxMP = self.maxMP + MPIncrease
            self.MP = self.MP + MPIncrease
        elseif self.AP then
            self.maxAP = self.maxAP + MPIncrease
            self.AP = self.AP + MPIncrease
        end
    end
end

function Player:revive()
    -- fully revive the player
    self.HP = self.maxHP
    self.MP = self.maxMP
    self.AP = self.maxAP
    self.dead = false
    self.battleSprite.opacity = 255
end
