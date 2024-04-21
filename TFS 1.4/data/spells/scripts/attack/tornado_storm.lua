-- approach is to split the spell into multiple smaller spells
local maxRandomAreaGroups = 10
local combats = {}
local maxCombats = 4 * maxRandomAreaGroups

-- this variable stores all combat areas, they'll be stored in groups of 4 and we'll eventually increment by 4
-- in combination with maxRandomAreaGroups, we'll have 10 individual random groups
-- local combatAreas = { AREA_TORNADO_1, AREA_TORNADO_2, AREA_TORNADO_3, AREA_TORNADO_4}
local combatAreas = {}

-- debugging
-- print the generated area in console
function printArea(area)
	print("Printing area")
	for i = 1, #area do
		io.write("\n {")
		for j = 1, #area[i] do
			io.write(area[i][j] .. " ")
		end
		io.write("}\n")
	end
	print()
end

-- deep copies an area into a new copy 
function deepcopy(orig)
    local orig_type = type(orig)
    local copy
    if orig_type == 'table' then
        copy = {}
        for orig_key, orig_value in next, orig, nil do
            copy[deepcopy(orig_key)] = deepcopy(orig_value)
        end
        setmetatable(copy, deepcopy(getmetatable(orig)))
    else -- number, string, boolean, etc
        copy = orig
    end
    return copy
end

-- returns the total number of usable cells
function getTotalUsableCells(area)
	local totalCells = 0
	for i = 1, #area, 1 do
		for j = 1, #area[i], 1 do
			if area[i][j] == 1 then
				totalCells = totalCells + 1
			end
		end
	end
	return totalCells
end

--generates a random area using cellsToUse. This area, based on the original area, will have random cells of no. specified turned to 1 to be used later
function generateRandomArea(refArea, cellsToUse)
	local cellsUsed = 0
	local area = deepcopy(refArea)
	while cellsUsed < cellsToUse do
		for i = 1, #refArea do
			for j = 1, #refArea[i] do
				if refArea[i][j] == 1 then
					local shouldUseCell = math.random(0, 1)
					
					if(shouldUseCell == 1 and cellsUsed < cellsToUse) then
						-- set the area to 1 so it's used in the final area
						area[i][j] = refArea[i][j]
						cellsUsed = cellsUsed + 1
						-- set the cell to 0 in original area so it cannot be reused
						refArea[i][j] = 0
					else
						area[i][j] = 0
					end
				end
			end
		end
	end
	return area
end

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
	combats[1]:execute(cid, variant)
	addEvent(executeCombat, 250, combats[2], cid, variant)
	addEvent(executeCombat, 500, combats[3], cid, variant)
	addEvent(executeCombat, 750, combats[4], cid, variant)
end

-- cast a single combat. Need this function for addEvent
function executeCombat(combat, cid, variant)
	combat:execute(cid, variant)
end

-- uses normalized randomization to generate 4 no. of random cells within the specified range
-- basically, it's 4 random numbers that equate to our total usable cells
function generateRandomCellNumbers(totalUsableCells)

	local randomizer1 = math.random(1, 100)
	local randomizer2 = math.random(1, 100)
	local randomizer3 = math.random(1, 100)
	local randomizer4 = math.random(1, 100)

	local randomizerTotal = randomizer1 + randomizer2 + randomizer3 + randomizer4

	local randNormalized1 = math.floor(randomizer1 / randomizerTotal * totalUsableCells)
	local randNormalized2 = math.floor(randomizer2 / randomizerTotal * totalUsableCells)
	local randNormalized3 = math.floor(randomizer3 / randomizerTotal * totalUsableCells)
	local randNormalized4 = math.floor(randomizer4 / randomizerTotal * totalUsableCells)

	local totalUsedCellsSoFar = randNormalized1 + randNormalized2 + randNormalized3 + randNormalized4

	if(totalUsedCellsSoFar < totalUsableCells) then
		randNormalized4 = randNormalized4 + (totalUsableCells - (totalUsedCellsSoFar))
	end

	return {randNormalized1, randNormalized2, randNormalized3, randNormalized4}
end

-- inits the spell
function init()
	local totalArea = deepcopy(AREA_TORNADO_USABLE)
	-- get total area to intitialze spell with
	local totalUsableCells = getTotalUsableCells(totalArea)

	local randomizers = generateRandomCellNumbers(totalUsableCells)
	combatAreas[1] = generateRandomArea(totalArea, randomizers[1])
	combatAreas[2] = generateRandomArea(totalArea, randomizers[2])
	combatAreas[3] = generateRandomArea(totalArea, randomizers[3])
	combatAreas[4] = generateRandomArea(totalArea, randomizers[4])

	--creates and sets up 4 combats
	for i = 1, 4 do
		combats[i] = Combat()
		combats[i]:setParameter(COMBAT_PARAM_TYPE, COMBAT_ICEDAMAGE)
		combats[i]:setParameter(COMBAT_PARAM_EFFECT, CONST_ME_ICETORNADO)
		combats[i]:setArea(createCombatArea(combatAreas[i]))
	end
	
end

init()
