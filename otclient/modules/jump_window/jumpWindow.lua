local jumpWindow
local jumpButton
local buttonMovementSpeed = 5

function init()
	jumpWindow = g_ui.displayUI('jumpWindow')
	jumpButton = jumpWindow:getChildById('jumpButton')
	resetButtonPosition()
	cycleEvent(OnUpdateJumpWindow, 50)
end

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

function OnUpdateJumpWindow()
	local oldMargin = jumpButton:getMarginRight()
	local newMargin = oldMargin + buttonMovementSpeed
	jumpButton:setMarginRight(newMargin)

	if newMargin > jumpWindow:getMarginRight() + jumpWindow:getWidth() - jumpButton:getWidth() * 1.5 then
		resetButtonPosition()
	end
end

function onClickButton()
	resetButtonPosition()
end

function resetButtonPosition()
	local randVerticalPos = math.random(0, jumpWindow:getHeight() - jumpWindow:getPaddingTop() - jumpButton:getHeight() / 2)
	jumpButton:setMarginBottom(randVerticalPos)
	jumpButton:setMarginRight(0)
end
