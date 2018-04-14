--
-- libraries
--

Class = require 'lib/class'
Event = require 'lib/knife.event'
push = require 'lib/push'
Timer = require 'lib/knife.timer'

require 'src/constants'
require 'src/Util'
require 'src/Animation'

require 'src/gui/Menu'
require 'src/gui/Panel'
require 'src/gui/ProgressBar'
require 'src/gui/Selection'
require 'src/gui/Textbox'

require 'src/world/Map'
require 'src/world/TileMap'
require 'src/world/overworld_def'
require 'src/world/village_def'

require 'src/entity/Entity'
require 'src/entity/Player'
require 'src/entity/player_defs'
require 'src/entity/NPC'
require 'src/entity/NPC_defs'

require 'src/states/BaseState'
require 'src/states/StateMachine'
require 'src/states/StateStack'

require 'src/states/entity/EntityBaseState'
require 'src/states/entity/EntityIdleState'
require 'src/states/entity/EntityWalkState'
require 'src/states/entity/PlayerIdleState'
require 'src/states/entity/PlayerWalkState'

require 'src/states/game/FadeState'
require 'src/states/game/VillageState'
require 'src/states/game/OverworldState'
require 'src/states/game/StartState'
require 'src/states/game/CharacterSelectState'

require 'src/states/text/DialogueState'

gTextures = {
    ['tiles'] = love.graphics.newImage('graphics/updatedtiles.png'),
    ['enimies'] = love.graphics.newImage('graphics/enimies.png'),
    ['cursor'] = love.graphics.newImage('graphics/cursor.png'),
    ['sword'] = love.graphics.newImage('graphics/sword.png'),
    ['background'] = love.graphics.newImage('graphics/background.png'),
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
    ['enimies'] = GenerateQuads(gTextures['enimies'], 16, 16),
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
    ['field-music'] = love.audio.newSource('sounds/field_music.wav'),
    ['battle-music'] = love.audio.newSource('sounds/battle_music.mp3'),
    ['blip'] = love.audio.newSource('sounds/blip.wav'),
    ['powerup'] = love.audio.newSource('sounds/powerup.wav'),
    ['hit'] = love.audio.newSource('sounds/hit.wav'),
    ['run'] = love.audio.newSource('sounds/run.wav'),
    ['heal'] = love.audio.newSource('sounds/heal.wav'),
    ['exp'] = love.audio.newSource('sounds/exp.wav'),
    ['levelup'] = love.audio.newSource('sounds/levelup.wav'),
    ['victory-music'] = love.audio.newSource('sounds/victory.wav'),
    ['intro-music'] = love.audio.newSource('sounds/intro.mp3')
}
