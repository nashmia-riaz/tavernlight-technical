local jumpWindow
local jumpButton
local buttonMovementSpeed = 5

-- Initialize the window, set references and init button position at random
function init()
	jumpWindow = g_ui.displayUI('jumpWindow')
	jumpButton = jumpWindow:getChildById('jumpButton')
	resetButtonPosition()
	cycleEvent(OnUpdateJumpWindow, 50)
end

-- destory the button and window
function terminate()
	if jumpButton ~= nil then
		jumpButton.destroy()
		jumpButton = nil
	end

	if jumpWindow ~= nil then
		jumpWindow.destroy()
		jumpWindow = nil
	end
end

-- on cycle event, call this function to update the button's position
function OnUpdateJumpWindow()
	local oldMargin = jumpButton:getMarginRight()
	local newMargin = oldMargin + buttonMovementSpeed
	jumpButton:setMarginRight(newMargin)

	-- if button moves outside of the window (too far to the left) reset it's position
	if newMargin > jumpWindow:getMarginRight() + jumpWindow:getWidth() - jumpButton:getWidth() * 1.5 then
		resetButtonPosition()
	end
end

-- called when button is clicked
function onClickButton()
	-- reset the button position
	resetButtonPosition()
end

-- Resets the buttons position. x = 0, y will be random between minWindowY and maxWindowY
function resetButtonPosition()
	local randVerticalPos = math.random(0, jumpWindow:getHeight() - jumpWindow:getPaddingTop() - jumpButton:getHeight() / 2)
	jumpButton:setMarginBottom(randVerticalPos)
	jumpButton:setMarginRight(0)
end
