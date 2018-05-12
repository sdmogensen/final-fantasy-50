Location_defs = Class{}

function Location_defs:init(players, items)
    self.players = players
    self.items = items
    self['town'] = {
        NPCs = {
            NPC {
                texts = {
                    "Take this for your travels, good luck!",
                    "You can rest here if you'd like."
                },
                afterTalk = {
                    function()
                        table.insert(items, Item('potion'))
                        gSounds['powerup']:play()
                        gStateStack:push(BattleMessageState("The woman gives you a potion!"))
                    end,
                    function()
                        for k, player in pairs(self.players) do
                            player:revive()
                        end
                        gSounds['heal']:play()
                        gStateStack:push(BattleMessageState("Your entire party has been healed!"))
                    end
                },
                mapX = 14,
                mapY = 4,
                NPC_id = 'woman'
            },
            NPC {
                texts = {
                    "Hey, what are you doing? Get out of my house!",
                    "And don't steal my stuff!",
                    "I said don't steal my stuff!"
                },
                mapX = 11,
                mapY = 22,
                NPC_id = 'man'
            }
        },
        chests = {
            Chest(7, 4, 'potion', self.items),
            Chest(10, 20, 'ether', self.items),
            Chest(37, 13, 'ether', self.items)
        },
        objects = {
            Object(15, 9, 'monument', "A monument to the town's fallen heroes."),
            Object(9, 11, 'well', "It's a well."),
            Object(3, 7, 'jar', "It's empty."),
            Object(17, 6, 'jar', "It's empty."),
            Object(11, 23, 'jar', "It's empty.", 'potion', self.items),
            Object(18, 6, 'jar', "It's empty.", 'potion', self.items),
            Object(14, 3, 'drawers', "It's empty."),
            Object(11, 20, 'drawers', "It's empty."),
            Object(9, 20, 'bed', "Looks comfy!"),
            Object(17, 3, 'bed', "Looks comfy!")
        }
    }
    self['cave'] = {
        NPCs = {
            NPC {
                texts = {
                    "It's dangerous to go alone! Take this.",
                    "Want some more, huh? Ok, take this too.",
                    "Still not satisfied?? Alright fine, you can have one of these too.",
                    "Ok, now you're just getting greedy! I'm fresh out!"
                },
                afterTalk = {
                    function()
                        table.insert(items, Item('potion'))
                        gSounds['powerup']:play()
                        gStateStack:push(BattleMessageState("The old man gives you a potion!"))
                    end,
                    function()
                        table.insert(items, Item('ether'))
                        gSounds['powerup']:play()
                        gStateStack:push(BattleMessageState("The old man gives you an ether!"))
                    end,
                    function()
                        table.insert(items, Item('elixir'))
                        gSounds['powerup']:play()
                        gStateStack:push(BattleMessageState("The old man gives you an elixir!!"))
                    end,
                    function()
                        gStateStack:push(BattleMessageState("The old man scowls at you."))
                    end
                },
                mapX = 13,
                mapY = 6,
                NPC_id = 'man'
            }
        },
        chests = {},
        objects = {}
    }
    self['overworld'] = {
        NPCs = {},
        chests = {
            Chest(49, 22, 'ether', self.items),
            Chest(15, 24, 'elixir', self.items)
        },
        objects = {}
    }
    self['dungeon'] = {
        NPCs = {},
        chests =  {
            Chest(7, 4, 'elixir', self.items),
            Chest(8, 4, 'ether', self.items),
            Chest(9, 4, 'potion', self.items)
        },
        objects = {}
    }
    self['dungeon-lv2'] = {
        NPCs = {},
        chests =  {
            Chest(20, 4, 'potion', self.items),
            Chest(21, 4, 'ether', self.items)
        },
        objects = {}
    }
    self['dungeon-lv3'] = {
        NPCs = {},
        chests =  {
            Chest(3, 22, 'elixir', self.items),
            Chest(13, 22, 'elixir', self.items)
        },
        objects = {}
    }
end
