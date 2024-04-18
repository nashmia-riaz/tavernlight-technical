--Q2 - Fix or improve the implementation of the below method

function printSmallGuildNames(memberCount)
    -- this method is supposed to print names of all guilds that have less than memberCount max members

    -- string.format to include the number memberCount in our query string directly. Easier to read and keep up with query this way (instead of formatting after)
    local selectGuildQuery = string.format("SELECT name FROM guilds WHERE max_members < %d;", memberCount)

    -- simply call the db with query
    local resultId = db.storeQuery(selectGuildQuery)

    -- add a simple check to see if results exist within the database
    if resultId ~= false then
        -- loop through all the results and print their names here. Previously, we were not looping through our query results
        -- In order to understand repeat loop, this link was used -> https://www.tutorialspoint.com/lua/lua_repeat_until_loop.htm
        -- Also, to loop through results properly, I utilized the OTLand forums here -> https://otland.net/threads/get-more-than-1-result-at-database-with-tfs-1-2.273320/
        repeat
            local guildName = result.getString(resultId, "name")
            print(guildName)
            -- keep looping until next result doesn't exist
        until not result.next(resultId)
        -- free the result set, otherwise we will end up incrementing the database. See -> https://otland.net/threads/sql-lua-return-storequery.272689/#post-2626244
        result.free(resultId)
    else
        --if database doesn't hold results, we will print a statement for debugging
        print("[Print Small Guild Names] Result not found. No guilds found with less than " .. memberCount .. " members.")
    end
end