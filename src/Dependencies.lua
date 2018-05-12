Class = require 'lib/class'
Event = require 'lib/knife.event'
push = require 'lib/push'
Timer = require 'lib/knife.timer'

require 'src/constants'
require 'src/Util'
require 'src/Animation'

require 'src/defs/enemy_defs'
require 'src/defs/NPC_defs'
require 'src/defs/player_defs'
require 'src/defs/item_defs'
require 'src/defs/object_defs'
require 'src/defs/location_defs'

require 'src/entity/BattleSprite'
require 'src/entity/Enemy'
require 'src/entity/Entity'
require 'src/entity/NPC'
require 'src/entity/Player'

require 'src/gui/Menu'
require 'src/gui/Panel'
require 'src/gui/Selection'
require 'src/gui/Textbox'

require 'src/other/Camera'
require 'src/other/Item'
require 'src/other/Chest'
require 'src/other/Object'
require 'src/other/Dragon'

require 'src/world/Map'
require 'src/world/TileMap'
require 'src/world/overworld_def'
require 'src/world/town_def'
require 'src/world/cave_def'
require 'src/world/dungeon_lv1_def'
require 'src/world/dungeon_lv2_def'
require 'src/world/dungeon_lv3_def'

require 'src/states/BaseState'
require 'src/states/StateMachine'
require 'src/states/StateStack'

require 'src/states/entity/EntityBaseState'
require 'src/states/entity/EntityIdleState'
require 'src/states/entity/EntityWalkState'
require 'src/states/entity/PlayerIdleState'
require 'src/states/entity/PlayerWalkState'

require 'src/states/game/FadeState'
require 'src/states/game/OverworldState'
require 'src/states/game/StartState'
require 'src/states/game/CharacterSelectState'
require 'src/states/game/BattleState'
require 'src/states/game/GameOverState'
require 'src/states/game/VictoryState'

require 'src/states/text/AbilitiesMenuState'
require 'src/states/text/BattleMenuState'
require 'src/states/text/BattleMessageState'
require 'src/states/text/ChooseCombatantState'
require 'src/states/text/DialogueState'
require 'src/states/text/ItemMenuState'

gTextures = {
    ['tiles'] = love.graphics.newImage('graphics/updatedtiles.png'),
    ['enemies'] = love.graphics.newImage('graphics/enemies.png'),
    ['cursor'] = love.graphics.newImage('graphics/cursor.png'),
    ['sword'] = love.graphics.newImage('graphics/sword.png'),
    ['background'] = love.graphics.newImage('graphics/background.png'),
    ['grass_background'] = love.graphics.newImage('graphics/grass.png'),
    ['cave_background'] = love.graphics.newImage('graphics/cave.png'),
    ['fortress_background'] = love.graphics.newImage('graphics/fortress.png'),
    ['dragon'] = love.graphics.newImage('graphics/dragon.png'),
    ['healer_f'] = love.graphics.newImage('graphics/players/healer_f.png'),
    ['healer_m'] = love.graphics.newImage('graphics/players/healer_m.png'),
    ['mage_f'] = love.graphics.newImage('graphics/players/mage_m.png'),
    ['mage_m'] = love.graphics.newImage('graphics/players/mage_f.png'),
    ['ninja_f'] = love.graphics.newImage('graphics/players/ninja_f.png'),
    ['ninja_m'] = love.graphics.newImage('graphics/players/ninja_m.png'),
    ['ranger_f'] = love.graphics.newImage('graphics/players/ranger_f.png'),
    ['ranger_m'] = love.graphics.newImage('graphics/players/ranger_m.png'),
    ['warrior_f'] = love.graphics.newImage('graphics/players/warrior_f.png'),
    ['warrior_m'] = love.graphics.newImage('graphics/players/warrior_m.png'),
    ['townfolk1_f'] = love.graphics.newImage('graphics/NPCs/townfolk1_f.png'),
    ['townfolk1_m'] = love.graphics.newImage('graphics/NPCs/townfolk1_m.png')
}

gFrames = {
    ['tiles'] = GenerateQuads(gTextures['tiles'], 16, 16),
    ['enemies'] = GenerateQuads(gTextures['enemies'], 16, 16),
    ['healer_f'] = GenerateQuads(gTextures['healer_f'], 32, 36),
    ['healer_m'] = GenerateQuads(gTextures['healer_m'], 32, 36),
    ['mage_f'] = GenerateQuads(gTextures['mage_f'], 32, 36),
    ['mage_m'] = GenerateQuads(gTextures['mage_m'], 32, 36),
    ['ninja_f'] = GenerateQuads(gTextures['ninja_f'], 32, 36),
    ['ninja_m'] = GenerateQuads(gTextures['ninja_m'], 32, 36),
    ['ranger_f'] = GenerateQuads(gTextures['ranger_f'], 32, 36),
    ['ranger_m'] = GenerateQuads(gTextures['ranger_m'], 32, 36),
    ['warrior_f'] = GenerateQuads(gTextures['warrior_f'], 32, 36),
    ['warrior_m'] = GenerateQuads(gTextures['warrior_m'], 32, 36),
    ['townfolk1_f'] = GenerateQuads(gTextures['townfolk1_f'], 32, 36),
    ['townfolk1_m'] = GenerateQuads(gTextures['townfolk1_m'], 32, 36)
}

gFonts = {
    ['small'] = love.graphics.newFont('fonts/pixChicago.ttf', 8),
    ['medium'] = love.graphics.newFont('fonts/pixChicago.ttf', 16),
    ['large'] = love.graphics.newFont('fonts/pixChicago.ttf', 32),
    ['extra-large'] = love.graphics.newFont('fonts/pixChicago.ttf', 48),
    ['finalf'] = love.graphics.newFont('fonts/finalf.ttf', 56)
}

gSounds = {
    ['intro-theme'] = love.audio.newSource('sounds/main.mp3'),
    ['town-theme'] = love.audio.newSource('sounds/town.mp3'),
    ['overworld-theme'] = love.audio.newSource('sounds/main.mp3'),
    ['dungeon-theme'] = love.audio.newSource('sounds/dungeon.wav'),
    ['victory-theme'] = love.audio.newSource('sounds/victory.wav'),
    ['battle-theme'] = love.audio.newSource('sounds/battle.wav'),
    ['dragon-theme'] = love.audio.newSource('sounds/dragon.wav'),
    ['gameover'] = love.audio.newSource('sounds/gameover.wav'),
    ['endcredits'] = love.audio.newSource('sounds/endcredits.mp3'),
    ['blip'] = love.audio.newSource('sounds/blip.wav'),
    ['powerup'] = love.audio.newSource('sounds/powerup.wav'),
    ['hit'] = love.audio.newSource('sounds/hit.wav'),
    ['run'] = love.audio.newSource('sounds/run.wav'),
    ['heal'] = love.audio.newSource('sounds/heal.wav'),
    ['fire'] = love.audio.newSource('sounds/fire.wav'),
    ['spell'] = love.audio.newSource('sounds/spell.wav'),
    ['death'] = love.audio.newSource('sounds/death.wav'),
    ['freeze'] = love.audio.newSource('sounds/freeze.wav')
}
