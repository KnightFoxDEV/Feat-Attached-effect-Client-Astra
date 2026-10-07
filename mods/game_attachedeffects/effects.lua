--[[
    register(id, name, thingId, thingType, config)
    config = {
        speed, disableWalkAnimation, shader,
        offset{x, y, onTop}, dirOffset[dir]{x, y, onTop},
        onAttach, onDetach
    }
]] --
AttachedEffectManager.register(1, 'Spoke Lighting', 12, ThingCategoryEffect, {
    speed = 0.5,
    onAttach = function(effect, owner)
        print('onAttach: ', effect:getId(), owner:getName())
    end,
    onDetach = function(effect, oldOwner)
        print('onDetach: ', effect:getId(), oldOwner:getName())
    end
})

-- Astra registers the equivalent rainbow outfit shader as `outfit_rainbow`.
AttachedEffectManager.register(2, 'Bat Wings', 307, ThingCategoryCreature, {
    speed = 5,
    shader = 'outfit_rainbow',
    inheritOutfitShader = true,
    disableWalkAnimation = true,
    onAttach = function(effect, owner)
        owner:setBounce(0, 10, 5000)
    end,
    onDetach = function(effect, owner)
        owner:setBounce(0, 0, 0)
    end,
    dirOffset = {
        [North] = {0, -10, true},
        [East] = {5, -5},
        [South] = {-5, 0},
        [West] = {-10, -5, true},
        [NorthWest] = {-10, -5, true},
        [SouthWest] = {-10, -5, true}
    }
})

AttachedEffectManager.register(3, 'Angel Light', 50, ThingCategoryEffect, {})

AttachedEffectManager.register(4, 'Brino - Effect', 2558, ThingCategoryCreature, {
    dirOffset = {
        [North] = {0, 0, true},
        [East] = {0, 0, true},
        [South] = {0, 0, true},
        [West] = {0, 0, true}
    }
})

AttachedEffectManager.register(5, 'Brino - Effect', 2559, ThingCategoryCreature, {
    dirOffset = {
        [North] = {0, 0, false},
        [East] = {0, 0, false},
        [South] = {0, 0, false},
        [West] = {0, 0, false}
    }
})

-- OpenTibiaBR image presets; retain the reference IDs, size and anchor offsets.
AttachedEffectManager.register(7, 'Pentagram Aura', '/images/game/effects/pentagram.png', ThingExternalTexture, {
    size = {128, 128},
    offset = {50, 45}
})

AttachedEffectManager.register(8, 'Ki', '/images/game/effects/ki.png', ThingExternalTexture, {
    size = {140, 110},
    offset = {60, 75, true},
    pulse = {0, 50, 3000}
})

AttachedEffectManager.register(9, 'Thunder', '/images/game/effects/thunder.png', ThingExternalTexture, {
    loop = 1,
    offset = {215, 230}
})

-- This ID is advertised by the compatible 860 server as a wing. Keep the same
-- native creature sprite and motion config as the Mehah client registration.
AttachedEffectManager.register(11, 'Bat', 307, ThingCategoryCreature, {
    speed = 0.5,
    shader = 'outfit_rainbow',
    followOwner = true,
    offset = {0, 0},
    dirOffset = {
        [North] = {0, -10, true},
        [East] = {5, -5},
        [South] = {-5, 0},
        [West] = {-10, -5, true},
        [NorthWest] = {-10, -5, true},
        [SouthWest] = {-10, -5, true}
    },
    onAttach = function(effect, owner)
        owner:setBounce(0, 10, 5000)
    end,
    onDetach = function(effect, owner)
        owner:setBounce(0, 0, 0)
    end
})
