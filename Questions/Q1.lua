-- Q1 - Fix or improve the implementation of the below methods

local function releaseStorage(player)
player:setStorageValue(1000, -1)
end

function onLogout(player)
    -- check if storage value is not -1 before release. 
    -- We don't know what value is set in case storage is used, but we are aware that -1 means storage is empty and doesn't require releasing
if player:getStorageValue(1000) ~= -1 then 
    -- Call function immediately without delay. Delay was unnecessary. In order to understand AddEvent, this link was used -> https://otland.net/threads/how-to-using-addevent.225292/
    releaseStorage(player)
end
--return true to allow player to log out
return true
end