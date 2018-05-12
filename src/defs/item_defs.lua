ITEM_DEFS = {
    ['potion'] = {
        name = 'potion',
        article = 'a',
        onConsume = function(player)
            gStateStack:push(BattleMessageState(player.name .. ' gains 100 HP!', function() end, 1.5))
            gSounds['heal']:play()
            player.HP = math.min(player.maxHP, player.HP + 100)
        end
    },
    ['ether'] = {
        name = 'ether',
        article = 'an',
        onConsume = function(player)
            if player.MP then
                gStateStack:push(BattleMessageState(player.name .. ' gains 50 MP!', function() end, 1.5))
                gSounds['heal']:play()
                player.MP = math.min(player.maxMP, player.MP + 50)
            elseif player.AP then
                gStateStack:push(BattleMessageState(player.name .. ' gains 50 AP!', function() end, 1.5))
                gSounds['heal']:play()
                player.AP = math.min(player.maxAP, player.AP + 50)
            else
                gStateStack:push(BattleMessageState('The ether has no effect on ' .. player.name .. '.', function() end, 1.5))
            end
        end
    },
    ['elixir'] = {
        name = 'elixir',
        article = 'an',
        onConsume = function(player)
            if player.MP then
                gStateStack:push(BattleMessageState(player.name.. '\'s HP and MP are maxed out!', function() end, 1.5))
                gSounds['heal']:play()
                player.HP = player.maxHP
                player.MP = player.maxMP
            elseif player.AP then
                gStateStack:push(BattleMessageState(player.name .. '\'s HP and AP are maxed out!', function() end, 1.5))
                gSounds['heal']:play()
                player.HP = player.maxHP
                player.AP = player.maxAP
            else
                gStateStack:push(BattleMessageState(player.name .. '\'s HP is maxed out!', function() end, 1.5))
                gSounds['heal']:play()
                player.HP = player.maxHP
            end
        end
    }
}
