# Tavernlight Technical Test

This readme contains the explanations for Q5 and Q7 for the Tavernlight Technical Test. 

Please note that:
- **Q6 was skipped**
- The explanations for Q1 - Q4 are commented within their code files (along with any links used for explanation) in the [Questions](/Questions) folder.

# Table of Contents
- [Question 5](#question-5)
    - [Commit 6de5d6f](https://github.com/nashmia-riaz/tavernlight-technical/commit/6de5d6f576f48770a9faa7994f53f4a78dd11517) initial implementation of static cascading spell
    - [Commit d6b0bf0](https://github.com/nashmia-riaz/tavernlight-technical/commit/d6b0bf066801735938fa3ee39d3d60530e02c9dc) further implementation of cascading randomized spell
    - [TFS 1.4/data/spells/lib/spells.lua](/TFS%201.4/data/spells/lib/spells.lua)
    - [TFS 1.4/data/spells/scripts/attack/tornado storm.lua](/TFS%201.4/data/spells/scripts/attack/tornado_storm.lua)
- Question 6 (skipped)
- [Question 7](#question-7)
    - [Commit caef0fa](https://github.com/nashmia-riaz/tavernlight-technical/commit/caef0fa5b5a1ba2bbd68a4c1a66f8715cfaaf82d)
    - [OTClient/modules/jump_window/jumpWindow.lua](/otclient/modules/jump_window/jumpWindow.lua)
    - [OTClient/modules/jump_window/jumpWindow.otui](/otclient/modules/jump_window/jumpWindow.otui)
    - [OTClient/modules/jump_window/jumpWindow.otmod](/otclient/modules/jump_window/jumpWindow.otmod)

## Question 5

### How to Produce
With the [TFS](/TFS%201.4/) set up (provided in the repo), connect with OTClient and run the spell using words '**cast tornado storm**'.

### Video Proof
![alt text](/Resources/Tornado%20Storm.gif)

### Code changes
The commit for the code changes is [6de5d6f](https://github.com/nashmia-riaz/tavernlight-technical/commit/6de5d6f576f48770a9faa7994f53f4a78dd11517).

Main files that were changed/added for the task:
- [TFS 1.4/data/spells/lib/spells.lua](/TFS%201.4/data/spells/lib/spells.lua)
- [TFS 1.4/data/spells/scripts/attack/tornado storm.lua](/TFS%201.4/data/spells/scripts/attack/tornado_storm.lua)

### Process
For this question, my first task was figuring out where the tornado sprites are located. Upon my search for grasping a general understanding of the OTClient, I stumbled upon [Eternal Winter](https://tibia.fandom.com/wiki/Eternal_Winter). This spell looked very close to the question requirements but was too uniform.

![alt text](https://static.wikia.nocookie.net/tibia/images/4/45/Eternal_Winter_animation.gif/revision/latest?cb=20171009102528&path-prefix=en&format=original)

*Original Eternal Winter Preview*

#### Problem 1: Spell Effect Bug Within the OTClient
Upon trying to simply understand and run Eternal Winter in my client, one of the first things I noticed was that my spell did not appear as its supposed to. Something was off with the rendering and it appeared as below: 

![alt text](/Resources/Broken%20Eternal%20Winter.gif)

*Eternal Winter in OTClient Bugged*

Upon some further searching, I found this [thread](https://otland.net/threads/issue-on-the-animation-of-eternal-winter.281595/) on OTLand.  Another user had the same issue which confirmed my suspicions that this was a client-sided bug. Someone recommended [mehah's client](https://github.com/mehah/otclient) which apparently did not have the bug. In my understanding of the bug, I figured out that the spell was being drawn in effect.cpp. I understood and implemented mehah's version of effect.cpp into the edubart client. 

``` C++
//fixing eternal wind effect to be a diagonal square and not overlap the player
// Calculate the horizontal offset of the effect from the central position of the map
int xOffset = m_position.x - g_map.getCentralPosition().x;

// Calculate the vertical offset of the effect from the central position of the map
int yOffset = m_position.y - g_map.getCentralPosition().y;

// Calculate the vertical pattern index based on the offset and the number of patterns vertically
int yPattern = unsigned(yOffset) % getNumPatternY();

// Calculate the horizontal pattern index based on the offset and the number of patterns horizontally
int xPattern = unsigned(xOffset) % getNumPatternX();

// Adjust the horizontal pattern index to handle negative values correctly
xPattern = 1 - xPattern - getNumPatternX();

// Wrap around the horizontal pattern index if it's negative
if (xPattern < 0)
    xPattern += getNumPatternX();

rawGetThingType()->draw(dest, scaleFactor, 0, xPattern, yPattern, 0, animationPhase, lightView);
```

This started rendering Eternal Winter as expected.

#### Implementing Question 5
From my understanding of OTClient and TFS so far, I understood that the implementation of a spell resided within the TFS code, particularly within `data/spells/`. I started off by cloning Eternal Winter and working off of its existing code. The way I looked at it, our spell has multiple combats that take effect one after the other. Upon studying the video for the technical test requirements, I created the image below to understand the sequence. The number signify the order in which the cell is triggered, and the area is a 3x3 circle.

![alt text](/Resources/Tornado%20Spell%20Sequence.png)

*Image summarizing spell execution sequence*

I then created these areas in [`spells/lib/spells.lua`](/TFS%201.4/data/spells/lib/spells.lua). Upon testing, I also noticed that the spells are mirrored, so my implemented areas are mirrored as well. The code block highlights the general idea, but the entire code is within the file itself

``` lua
...
-- areas for tornado spell
AREA_TORNADO_1 = {
	{0, 0, 0, 0, 0, 0, 0},
	{0, 0, 0, 0, 0, 0, 0},
	{0, 0, 0, 0, 0, 0, 0},
	{1, 0, 0, 3, 0, 0, 1},
	{0, 1, 0, 0, 0, 0, 0},
	{0, 0, 1, 0, 0, 0, 0},
	{0, 0, 0, 1, 0, 0, 0}
}
... 
AREA_TORNADO_4 ={
	{0, 0, 0, 1, 0, 0, 0},
	{0, 0, 0, 0, 0, 0, 0},
	{0, 0, 0, 1, 0, 0, 0},
	{0, 0, 0, 3, 0, 0, 0},
	{0, 0, 0, 0, 0, 0, 0},
	{0, 0, 0, 0, 0, 0, 0},
	{0, 0, 0, 0, 0, 0, 0}
}
...
```

Lastly, I implemented the spell's code as described above; separate combats that are triggered in a sequence. This code is under [/spells/scripts/attack/tornado storm.lua](/TFS%201.4/data/spells/scripts/attack/tornado_storm.lua). The main code is highlighted below, but the file itself contains the nitty and gritty. One important aspect to note here is that `creature.uid` is being passed in the argument instead of `creature`, as the creature variable was marked unsafe for the `addEvent` function.

``` lua
function onCastSpell(creature, variant)
	createCombats(creature.uid, variant)
	addEvent(createCombats, 1000, creature.uid, variant)
	addEvent(createCombats, 2000, creature.uid, variant)
	addEvent(createCombats, 3000, creature.uid, variant)
	return true
end

function createCombats(cid, variant)
	combat1:execute(cid, variant)
	addEvent(executeCombat, 250, combat2, cid, variant)
	addEvent(executeCombat, 500, combat3, cid, variant)
	addEvent(executeCombat, 750, combat4, cid, variant)
end

function executeCombat(combat, cid, variant)
	combat:execute(cid, variant)
end
```

### Further Implementation
Having achieved what the technical video specified, it didn't make sense for a game design and implementation POV to have such a static spell within the game. Therefore, I started working on randomizing the area of effect within the cascading spell.

My approach was the same as before, except I wanted the 4 areas initially created to be random instead of static. I started by referring to a base area defined as below:

``` lua
AREA_TORNADO_USABLE = {
	{0, 0, 0, 1, 0, 0, 0},
	{0, 0, 1, 0, 1, 0, 0},
	{0, 1, 0, 1, 0, 1, 0},
	{1, 0, 1, 3, 1, 0, 1},
	{0, 1, 0, 1, 0, 1, 0},
	{0, 0, 1, 0, 1, 0, 0},
	{0, 0, 0, 1, 0, 0, 0}
}
```

My plan was to reference this as the base and then incrementally use the on cells (cells with value 1) for each cascade, keep x amount of cells turned on in my copy, all the while keeping track of which cells had been used. Therefore, these cells would not be used in the future. I would do this by:
- traversing through the base area
- using any cell with value 1, and using a 50/50 randomizer to see if i wanted to keep it on
    - if yes, I would turn this cell off (value to 0) in the base
    - I would copy the value of 1 over to the new area
    - if no, I would turn this cell to false 
- I would then store the newly randomly generated area for future use


``` lua
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
```

I planned to generate such random areas at runtime. But alas, the server is limited because it cannot set combat area at runtime. Therefore, I instead initialized my 4 combats to these 4 areas upon loading. The result is random as seen below:

![alt text](/Resources//Tornado%20Storm%202.gif)

*Tornado Storm with Random Cascading Cells*

### Summary
It was a very intriguing task, especially considering that the engine itself contained errors that needed resolving. Initially, the implementation was kept as close to the technical video as possible, meaning that its execution is very static. I then added randomization to the spell. However, this randomization is still limited as its only set when the server is initialized, not when the spell is cast. A reason for this limitation is that we cannot set the combat area at runtime. 

In the future, perhaps further randomization can be added by preloading x amount of randomized areas, and picking 4 grouped subareas from that list randomly. This, however, does imply that 4 x X amount of combats would need to be preloaded and preinitialized, and then picked from at runtime. 

## Question 7

### How to Produce
With the [OTClient](/otclient/) set up and launched (provided in the repo), load the module '**jump_window**'. A window should appear with clickable 'Jump!' buttons. There is no need to connect to a server for this as it can be loaded in the main menu.

### Video Proof
https://github.com/nashmia-riaz/tavernlight-technical/assets/13387692/e30cea5e-468e-4270-a105-d0ebdfcd2d72


### Code changes
The commit for the code changes is [caef0fa](https://github.com/nashmia-riaz/tavernlight-technical/commit/caef0fa5b5a1ba2bbd68a4c1a66f8715cfaaf82d).

Main files that were changed/added for the task:
- [OTClient/modules/jump_window/jumpWindow.lua](/otclient/modules/jump_window/jumpWindow.lua)
- [OTClient/modules/jump_window/jumpWindow.otui](/otclient/modules/jump_window/jumpWindow.otui)
- [OTClient/modules/jump_window/jumpWindow.otmod](/otclient/modules/jump_window/jumpWindow.otmod)

### Process
As with the previous task, I delved within the client's code to understand how UI was being rendered. It was very obvious that different modules render different UI as expected. I understood that I need to add my UI as a module.

Further search on how UI is implemented within the OTClient led me to this [very useful module tutorial](https://github.com/edubart/otclient/wiki/Module-Tutorial). My first step was to simply replicate this code and set it up to running. I understood that of the 3 files added:
- .otmod would specify module details for Module Manager
- .otui defines the UI, based closely off of CSS
- .lua defines the code needed

### Implementation

Next up, I changed the file names and module name to be what I wanted. This is stored in the OTClient as [jump_window](/otclient/modules/jump_window/).

I then created my window with a single button within it, under [jump_window.otui](/otclient/modules/jump_window/jumpWindow.otui). 

```
MainWindow
  id: jumpWindow
  size: 300 300

  Button
    id: jumpButton
    width: 64
    anchors.right: parent.right
    anchors.bottom: parent.bottom
    @onClick: onClickButton()
    !text: tr('Jump!')
```

I then set up my implementation of the lua code. I would reference my window and button within the load function, create the window on screen and destroy it on terminate. All of this was set up by studying the provided modules. A simple module taken for reference was `client_entergame`.

Next, I wanted to move the button across the window. I created an update function that would simply set the button's position. I noticed the function `cycleEvent` provided by the client and used that to loop my update function.

#### Problem 1: Updating the Button's Position
From reading OTClient's documentation, I was under the assumption this would work closely to CSS. So I tried to use function's like `setRect` or `setX` and `setY` to update the button's position within the update function. I was very wrong in this assumption. I went back to scouring the client code. After realizing that UIButton extends from UIWidget, I tried to use the UIWidget code and set margins to move the button instead.

My update function worked and looked like this: 
``` lua
...
-- function to move the button across the window
function OnUpdateJumpWindow()
    -- store the button's previous position
	local oldMargin = jumpButton:getMarginRight()
    -- move the button by x and store
	local newMargin = oldMargin + buttonMovementSpeed
	
    -- update the button's position by setting the margin
    jumpButton:setMarginRight(newMargin)

    -- TODO: Reset the button's position if it moves too far to the left of the window
end
...
```

### Problem 2: Resetting the Button's Position
Next up, I wanted to implement the button's position resetting to the starting point, but randomly across the vertical axis. This would happen if the user clicked the button, or if the button moved too far outside the window.

After understanding how to move the button using margins, this was a pretty straightforward implementation. I added the function `resetButtonPosition()` which would take a random number between 0 and the window's top margin, and apply that position to the button.

A new smaller problem here was the button would sometimes appear in the header of the window. So, I added the header's padding to the equation and voila! It started to come together.

```lua
function resetButtonPosition()
	local randVerticalPos = math.random(0, jumpWindow:getHeight() - jumpWindow:getPaddingTop() - jumpButton:getHeight() / 2)
	jumpButton:setMarginBottom(randVerticalPos)
	jumpButton:setMarginRight(0)
end
```

### Summary
Although simpler than Q5, due to lack of many resources for OTClient, this one involved a little bit of hit and trial. Apart from the OTClient module tutorial, there was not a whole lot to go off of on the OTLand forums. This involved going back and forth within the code and understanding different functions and their implementation to apply into the project, particularly with moving the button across the screen.

