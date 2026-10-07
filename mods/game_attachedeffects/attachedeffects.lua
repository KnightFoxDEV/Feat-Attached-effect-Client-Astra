-- Weak keys do not keep disappeared creatures/items/tiles alive.
local owners = setmetatable({}, {__mode = 'k'})

function onGameEnd()
    -- Creature userdata may already be invalid when onGameEnd runs. Calling
    -- clearAttachedEffects here can trigger a fatal C++ Lua-call failure while
    -- looking up the method. The game teardown owns and releases these objects.
    owners = setmetatable({}, {__mode = 'k'})
end

function init()
    assert(g_attachedEffects and AttachedEffect, 'Native Attached Effects support is required')
    connect(Creature, {onOutfitChange = onOutfitChange})
    connect(AttachedEffect, {onAttach = onAttach, onDetach = onDetach})
    connect(g_game, {onGameEnd = onGameEnd})
end

function terminate()
    onGameEnd()
    disconnect(Creature, {onOutfitChange = onOutfitChange})
    disconnect(AttachedEffect, {onAttach = onAttach, onDetach = onDetach})
    disconnect(g_game, {onGameEnd = onGameEnd})
    AttachedEffectManager.clear()
end

function onAttach(effect, owner)
    owners[owner] = true
    local category, thingId = AttachedEffectManager.getDataThing(owner)
    local config = AttachedEffectManager.executeThingConfig(effect, category, thingId, true)
    -- Effects can be registered before game_shaders finishes loading. Resolve
    -- the configured shader again when attaching, when the registry is ready.
    if config and config.shader then effect:setShader(config.shader) end
    applyOwnerShader(effect, owner, config)
    if config and config.onAttach then config.onAttach(effect, owner, config.__onAttach) end
end

function applyOwnerShader(effect, owner, config)
    if not config or not config.inheritOutfitShader then return end
    local outfit = owner:getOutfit()
    local shader = outfit and outfit.shader
    if shader and shader ~= '' and shader ~= 'outfit_default' then
        effect:setShader(shader)
    elseif config.shader then
        effect:setShader(config.shader)
    else
        effect:setShader('')
    end
end

function onDetach(effect, owner)
    local category, thingId = AttachedEffectManager.getDataThing(owner)
    local config = AttachedEffectManager.getConfig(effect:getId(), category, thingId)
    if config and config.onDetach then config.onDetach(effect, owner, config.__onDetach) end
    if not owner:hasAttachedEffects() then owners[owner] = nil end
end

function onOutfitChange(creature, outfit)
    for _, effect in ipairs(creature:getAttachedEffects()) do
        local config = AttachedEffectManager.executeThingConfig(effect, ThingCategoryCreature, outfit.type)
        applyOwnerShader(effect, creature, config)
    end
end
