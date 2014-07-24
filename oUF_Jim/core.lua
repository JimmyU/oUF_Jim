local addon_name, ns = ...
local C, F, G, L = unpack(ns)

--===================================================--
---------------    [[ UnitShared ]]     ---------------
--===================================================--

local function UnitShared(self, u)
	local unit = u:match("[^%d]+") -- boss1 -> boss

	-- 鼠标悬停
	self:SetScript("OnEnter", UnitFrame_OnEnter)
    self:SetScript("OnLeave", UnitFrame_OnLeave)
	
	-- 创建生命条
	local Health = CreateFrame("StatusBar", G.addon..unit.." HealthBar", self)
	Health:SetStatusBarTexture(G.media.bar)
	Health:SetAllPoints()
	
	-- 加上背景
	Health.Background = Health:CreateTexture(nil, 'BACKGROUND')
	Health.Background:SetAllPoints(Health)
	Health.Background:SetTexture(0.3, 0.3, 0.3)
   
	-- 加上边框
	Health:CreateBeautyBorder(11)
	Health:SetBeautyBorderColor(.7, .7, .7)
	Health:SetBeautyBorderPadding(2, 1, 2, 1, 2, 1, 2, 1)
	Health:SetBeautyBorderTexture('white')
	
	-- 选项
	Health.frequentUpdates = true
	Health.colorTapping = true
	Health.colorDisconnected = true
	Health.colorClass = true
	Health.colorReaction = true
	Health.colorHealth = true
   
	-- 把它注册到oUF
	self.Health = Health
	
	if not (unit == "targettarget" or unit == "focustarget") then -- 焦点的目标和目标的目标不要能量条
	
		-- 创建能量条
		local Power = CreateFrame("StatusBar", G.addon..unit.." PowerBar", self)
		Power:SetStatusBarTexture(G.media.bar)
		Power:SetHeight(12)
		Power:SetFrameLevel(5)
		Power:SetPoint("TOPLEFT", Health, "BOTTOMLEFT", 5, 5)
		Power:SetPoint("TOPRIGHT", Health, "BOTTOMRIGHT", -5, 5)
	   
		-- 加上背景
		Power.Background = Power:CreateTexture(nil, 'BACKGROUND')
		Power.Background:SetAllPoints(Power)
		Power.Background:SetTexture(0.3, 0.3, 0.3)

		-- 加上边框
		Power:CreateBeautyBorder(11)
		Power:SetBeautyBorderColor(.7, .7, .7)
		Power:SetBeautyBorderPadding(2, 1, 2, 1, 2, 1, 2, 1)
		Power:SetBeautyBorderTexture('white')

		-- 选项
		Power.frequentUpdates = true
		Power.colorPower = true

		-- 把它注册到oUF
		self.Power = Power
		
	end
	
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
		self:SetSize(C.Player.width, C.Player.height)
		
    end,
	
	--========================--
    --  Target
    --========================--
    target = function(self, unit)
        UnitShared(self, unit)
		self:SetSize(C.Target.width, C.Target.height)
		
    end,
	
    --========================--
    --  Focus
    --========================--
    focus = function(self, unit)
        UnitShared(self, unit)
		self:SetSize(C.Focus.width, C.Focus.height)
		
    end,

    --========================--
    --  Pet
    --========================--
    pet = function(self, unit)
        UnitShared(self, unit)
		self:SetSize(C.Pet.width, C.Pet.height)
		
    end,

    --========================--
    --  Target Target
    --========================--
    targettarget = function(self, unit)
        UnitShared(self, unit)
		self:SetSize(C.ToT.width, C.ToT.height)
		
    end,

	--========================--
    --  Focus Target
    --========================--
    focustarget = function(self, unit)
        UnitShared(self, unit)
		self:SetSize(C.ToF.width, C.ToF.height)
		
    end,
	
    --========================--
    --  Boss
    --========================--
    boss = function(self, unit)
        UnitShared(self, unit)
		self:SetSize(C.Boss.width, C.Boss.height)
		
    end,
	
	--========================--
    --  Arena
    --========================--
    arena = function(self, unit)
        UnitShared(self, unit)
		self:SetSize(C.Arena.width, C.Arena.height)
		
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
			playerframe:SetPoint(C.Player.positon.a1, C.Player.positon.parent, C.Player.positon.a2, C.Player.positon.x, C.Player.positon.y)
			
			local targetframe = SpawnHelper(self, "target")
			targetframe:SetPoint(C.Target.positon.a1, C.Target.positon.parent, C.Target.positon.a2, C.Target.positon.x, C.Target.positon.y)
			
			local focusframe = SpawnHelper(self, "focus")
			focusframe:SetPoint(C.Focus.positon.a1, C.Focus.positon.parent, C.Focus.positon.a2, C.Focus.positon.x, C.Focus.positon.y)
			
			local petframe = SpawnHelper(self, "pet")
			petframe:SetPoint(C.Pet.positon.a1, C.Pet.positon.parent, C.Pet.positon.a2, C.Pet.positon.x, C.Pet.positon.y)
			
			local totframe = SpawnHelper(self, "targettarget")
			totframe:SetPoint(C.ToT.positon.a1, C.ToT.positon.parent, C.ToT.positon.a2, C.ToT.positon.x, C.ToT.positon.y)
			
			local tofframe = SpawnHelper(self, "focustarget")
			tofframe:SetPoint(C.ToF.positon.a1, C.ToF.positon.parent, C.ToF.positon.a2, C.ToF.positon.x, C.ToF.positon.y)
			
			local bossframes = {}
			for i = 1, MAX_BOSS_FRAMES do
				bossframes["boss"..i] = SpawnHelper(self, "boss" .. i)
				if i == 1 then
					bossframes["boss"..i]:SetPoint(C.Boss.positon.a1, C.Boss.positon.parent, C.Boss.positon.a2, C.Boss.positon.x, C.Boss.positon.y)
				else
					bossframes["boss"..i]:SetPoint("TOP", bossframes["boss"..(i-1)], "BOTTOM", 0, -C.Boss.space)
				end
			end
			
			local arenaframes = {}
			for i = 1, 5 do
				arenaframes["arena"..i] = SpawnHelper(self, "arena" .. i)
				if i == 1 then
					arenaframes["arena"..i]:SetPoint(C.Arena.positon.a1, C.Arena.positon.parent, C.Arena.positon.a2, C.Arena.positon.x, C.Arena.positon.y)
				else
					arenaframes["arena"..i]:SetPoint("TOP", arenaframes["arena"..(i-1)], "BOTTOM", 0, -C.Arena.space)
				end
			end
		end)
		
	end
	
end)

EventFrame:RegisterEvent("ADDON_LOADED")