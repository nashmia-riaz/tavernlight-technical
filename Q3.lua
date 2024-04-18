-- Q3 - Fix or improve the name and the implementation of the below method

-- Removes a specific player from the party
function removePlayerFromParty(playerId, membername)

    -- get player with ID and check if such player exists
    local player = Player(playerId)
    if player == nil then
        print("[Remove Player From Party] Player with ID " .. playerId .." not found")
        return
    end

    -- Get the party for the player and check if party exists
    local party = player:getParty()
    if party == nil then
        print("[Remove Player From Party] Player with ID ".. playerId .. " is not in a party")
        return
    end

     -- Loop through all party members
    local partyMemebrs = party:getMembers()
    --  single underscore since we don't user the value https://www.mediawiki.org/wiki/Help:Lua/Lua_best_practice/pl#:~:text=In%20Lua%20code%20a%20single,be%20respected%20in%20ordinary%20code.
    for _, member in ipairs(partyMembers) do
        -- if player with name is found in the party, remove them from the party
        if member == Player(membername) then
            party:removeMember(member)
            print("[Remove Player From Party] Successfully removed ".. playerName .. " removed from the party")
            return
        end
    end

    print("[Remove Player From Party] Player ".. playerName .. " is not in any party.")
end