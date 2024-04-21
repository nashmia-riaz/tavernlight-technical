-- approach is to split the spell into multiple smaller spells

local combat1 = Combat()
combat1:setParameter(COMBAT_PARAM_TYPE, COMBAT_ICEDAMAGE)
combat1:setParameter(COMBAT_PARAM_EFFECT, CONST_ME_ICETORNADO)
combat1:setArea(createCombatArea(AREA_TORNADO_1))

local combat2 = Combat()
combat2:setParameter(COMBAT_PARAM_TYPE, COMBAT_ICEDAMAGE)
combat2:setParameter(COMBAT_PARAM_EFFECT, CONST_ME_ICETORNADO)
combat2:setArea(createCombatArea(AREA_TORNADO_2))

local combat3 = Combat()
combat3:setParameter(COMBAT_PARAM_TYPE, COMBAT_ICEDAMAGE)
combat3:setParameter(COMBAT_PARAM_EFFECT, CONST_ME_ICETORNADO)
combat3:setArea(createCombatArea(AREA_TORNADO_3))

local combat4 = Combat()
combat4:setParameter(COMBAT_PARAM_TYPE, COMBAT_ICEDAMAGE)
combat4:setParameter(COMBAT_PARAM_EFFECT, CONST_ME_ICETORNADO)
combat4:setArea(createCombatArea(AREA_TORNADO_4))

function onGetFormulaValues(player, level, magicLevel)
	local min = (level / 5) + (magicLevel * 5.5) + 25
	local max = (level / 5) + (magicLevel * 11) + 50
	return -min, -max
end

-- Loop the area combats 3x
function onCastSpell(creature, variant)
	createCombats(creature.uid, variant)
	addEvent(createCombats, 1000, creature.uid, variant)
	addEvent(createCombats, 2000, creature.uid, variant)
	return true
end

-- cast different cell combats at different times
function createCombats(cid, variant)
	combat1:execute(cid, variant)
	addEvent(executeCombat, 250, combat2, cid, variant)
	addEvent(executeCombat, 500, combat3, cid, variant)
	addEvent(executeCombat, 750, combat4, cid, variant)
end

-- cast a single combat. Need this function for addEvent
function executeCombat(combat, cid, variant)
	combat:execute(cid, variant)
end