local addon_name, ns = ...
local C, F, G, L = unpack(ns)

--===================================================--
---------------    [[ UnitShared ]]     ---------------
--===================================================--

local function UnitShared(self, u)
	local unit = u:match("[^%d]+") -- boss1 -> boss

end

--===================================================--
--------------    [[ UnitSpecific ]]     --------------
--===================================================--
	
local UnitSpecific = {
    --========================--
    --  Player
    --========================--
    player = function(self, unit)
        UnitShared(self, unit)
		
    end,
	
	--========================--
    --  Target
    --========================--
    target = function(self, unit)
        UnitShared(self, unit)
		
    end,
	
    --========================--
    --  Focus
    --========================--
    focus = function(self, unit)
        UnitShared(self, unit)
		
    end,

    --========================--
    --  Pet
    --========================--
    pet = function(self, unit)
        UnitShared(self, unit)
		
    end,

    --========================--
    --  Target Target
    --========================--
    targettarget = function(self, unit)
        UnitShared(self, unit)
		
    end,

	--========================--
    --  Focus Target
    --========================--
    focustarget = function(self, unit)
        UnitShared(self, unit)
		
    end,
	
    --========================--
    --  Boss
    --========================--
    boss = function(self, unit)
        UnitShared(self, unit)
		
    end,
	
	--========================--
    --  Arena
    --========================--
    arena = function(self, unit)
        UnitShared(self, unit)
		
    end,

}

--===================================================--
--------------    [[ RegisterStyle ]]     -------------
--===================================================--

oUF:RegisterStyle(G.addon, UnitShared)
for unit,layout in next, UnitSpecific do
    oUF:RegisterStyle(G.addon..unit:gsub("^%l", string.upper), layout)
end

--===================================================--
-----------------    [[ Spawn ]]     ------------------
--===================================================--

local SpawnHelper = function(self, unit)
    if(UnitSpecific[unit]) then
        self:SetActiveStyle(G.addon..unit:gsub("^%l", string.upper))
    elseif(UnitSpecific[unit:match("[^%d]+")]) then
        self:SetActiveStyle(G.addon..unit:match("[^%d]+"):gsub("^%l", string.upper)) -- boss1 -> boss
    else
        self:SetActiveStyle(G.addon)
    end

    local object = self:Spawn(unit)
	object:SetParent(EventFrame)
    return object
end

local EventFrame = CreateFrame("Frame", nil, UIParent)

EventFrame:SetScript("OnEvent", function(eventframe, event, ...)

    if event == "ADDON_LOADED" then
	
		local addon_name = ...
		if addon_name ~= "oUF_Jim" then return end
		
		oUF:Factory(function(self)
			local playerframe = SpawnHelper(self, "player")
			
			local targetframe = SpawnHelper(self, "target")
			
			local focusframe = SpawnHelper(self, "focus")
			
			local petframe = SpawnHelper(self, "pet")
			
			local totframe = SpawnHelper(self, "targettarget")
			
			local tofframe = SpawnHelper(self, "focustarget")
			
			local bossframes = {}
			for i = 1, MAX_BOSS_FRAMES do
				bossframes["boss"..i] = SpawnHelper(self, "boss" .. i)
			end
			
			local arenaframes = {}
			for i = 1, 5 do
				arenaframes["arena"..i] = SpawnHelper(self, "arena" .. i)
			end
		end)
		
	end
	
end)

EventFrame:RegisterEvent("ADDON_LOADED")