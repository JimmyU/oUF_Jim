local addon_name, ns = ...
local C, F, G, L = unpack(ns)

F.ShortValue = function(val)
	if (val >= 1e7) then
		return ("%.1fkw"):format(val / 1e7)
	elseif (val >= 1e4) then
		return ("%.1fw"):format(val / 1e4)
	else
		return ("%d"):format(val)
	end
end
--===================================================--
--------------------    [[ Tags ]]  -------------------
--===================================================--
oUF.Tags.Methods[G.addon.."hp"] = function(u)
	if UnitIsDead(u) then
		return
	else
		return F.ShortValue(UnitHealth(u))
	end
end
oUF.Tags.Events[G.addon.."hp"] = "UNIT_HEALTH_FREQUENT"

oUF.Tags.Methods[G.addon.."pp"] = function(u)
	if UnitIsDead(u) then
		return
	else
		return F.ShortValue(UnitPower(u))
	end
end
oUF.Tags.Events[G.addon.."pp"] = "UNIT_POWER_FREQUENT"

oUF.Tags.Methods[G.addon.."hp_perc"] = function(u)
	local hp = UnitHealth(u)
	local max = UnitHealthMax(u)
	if max == 0 or hp == max or UnitIsDead(u) then
		return
	elseif hp/max > 0.75 then
		return "|cffFFFFFF"..math.floor(hp/max*100+.5).."|r"
	elseif hp/max > 0.75 then
		return "|cffFFFF00"..math.floor(hp/max*100+.5).."|r"
	elseif hp/max > 0.25 then
		return "|cffffa500"..math.floor(hp/max*100+.5).."|r"
	else
		return "|cffFF0000"..math.floor(hp/max*100+.5).."|r"
	end
end
oUF.Tags.Events[G.addon.."hp_perc"] = "UNIT_HEALTH_FREQUENT"

--===================================================--
--------------------    [[ Auras ]]  ------------------
--===================================================--

local PostCreateIcon = function(Auras, Icon)
    Icon.icon:SetTexCoord(.07, .93, .07, .93)
	
	Icon:CreateBeautyBorder(11)
	Icon:SetBeautyBorderColor(.7, .7, .7)
	Icon:SetBeautyBorderPadding(3, 3, 3, 3, 3, 3, 3, 3)
	Icon:SetBeautyBorderTexture('white')
end

local PostUpdateGapIcon = function(auras, unit, icon, visibleBuffs)
	for i = 1, auras:GetNumChildren() do
		select(i, auras:GetChildren()):ShowBeautyBorder()
	end
	icon:HideBeautyBorder()
end

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
	
	if unit == "player" or unit == "boss" or unit == "pet" then -- 只有玩家，首领和宠物（载具）需要特殊能量条
		
		-- 创建特殊能量条
		local AltPowerBar = CreateFrame("StatusBar", G.addon..unit.." AltPowerBar", self)
		AltPowerBar:SetStatusBarTexture(G.media.bar)
		AltPowerBar:SetHeight(12)
		AltPowerBar:SetFrameLevel(5)
		AltPowerBar:SetPoint("TOPLEFT", Power, "BOTTOMLEFT", 5, 5)
		AltPowerBar:SetPoint("TOPRIGHT", Power, "BOTTOMRIGHT", -5, 5)
		
		-- 加上背景
		AltPowerBar.Background = AltPowerBar:CreateTexture(nil, 'BACKGROUND')
		AltPowerBar.Background:SetAllPoints(AltPowerBar)
		AltPowerBar.Background:SetTexture(0.3, 0.3, 0.3)
	   
		-- 加上边框
		AltPowerBar:CreateBeautyBorder(11)
		AltPowerBar:SetBeautyBorderColor(.7, .7, .7)
		AltPowerBar:SetBeautyBorderPadding(2, 1, 2, 1, 2, 1, 2, 1)
		AltPowerBar:SetBeautyBorderTexture('white')
		
		-- 在上面创建一个文本，用于显示数值
		AltPowerBar.Text = AltPowerBar:CreateFontString(nil, "OVERLAY")
		AltPowerBar.Text:SetFont(G.font, 12, "OUTLINE")
		AltPowerBar.Text:SetJustifyH("CENTER")
		
		-- 把它注册到oUF
		self.AltPowerBar = AltPowerBar
		
		-- 更新能量条时更新文本数值
		self.AltPowerBar.PostUpdate = function(AltPowerBar, min, cur, max)
			AltPowerBar.Text:SetText(cur)
		end
    end
		
	-- 创建名字
	local Name = Health:CreateFontString(nil, "OVERLAY")
	Name:SetFont(G.font, 16, "OUTLINE")
	Name:SetJustifyH("LEFT")
	Name:SetPoint("TOPLEFT", Health, "TOPLEFT", 3, 9)
	Name:SetPoint("TOPRIGHT", Health, "TOPRIGHT", -3, 9) -- 防止太长
	
    if unit == "player" or unit == "pet" then
        Name:Hide()
	elseif unit == "targettarget" or unit == "focustarget" or unit == "boss" or unit == "arena" then
		self:Tag(Name, "[name]")
    else
		self:Tag(Name, "[difficulty][smartlevel]|r [raidcolor][smartclass]|r[shortclassification] [name] [status]")
    end
	
    self.Name = Name
	
	if not (unit == "targettarget" or unit == "focustarget" or unit == "pet") then
	
		-- 创建生命值
		local Health_Value = Health:CreateFontString(nil, "OVERLAY")
		Health_Value:SetFont(G.font, 16, "OUTLINE")
		Health_Value:SetJustifyH("LEFT")
		Health_Value:SetPoint("BOTTOMLEFT", Health, "BOTTOMLEFT", 3, 6)
	
		self:Tag(Health_Value, "["..G.addon.."hp]")
		
		-- 创建能量值
		local Power_Value = Health:CreateFontString(nil, "OVERLAY")
		Power_Value:SetFont(G.font, 16, "OUTLINE")
		Power_Value:SetJustifyH("RIGHT")
		Power_Value:SetPoint("BOTTOMRIGHT", Health, "BOTTOMRIGHT", -3, 6)
	
		self:Tag(Power_Value, "["..G.addon.."pp]")
		
		-- 创建生命值百分比
		local Health_Perc = Health:CreateFontString(nil, "OVERLAY")
		Health_Perc:SetFont(G.font, 24, "OUTLINE")
		if unit == "player" then
			Health_Perc:SetPoint("LEFT", Health, "RIGHT", 5, 0)
			Health_Perc:SetJustifyH("LEFT")
		else
			Health_Perc:SetPoint("RIGHT", Health, "LEFT", -5, 0)
			Health_Perc:SetJustifyH("RIGHT")
		end
	
		self:Tag(Health_Perc, "["..G.addon.."hp_perc]")
		
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
		
		if C.Aura.show_player then
			local Auras = CreateFrame("Frame", G.addon..unit.." Auras", self)
			Auras:SetPoint("BOTTOMLEFT", self, "TOPLEFT", 0, 15)
			Auras:SetSize(C.Player.width, C.Aura.icon_size*2+C.Aura.icon_space)
			
			Auras.disableCooldown = false
			Auras.size = C.Aura.icon_size
			Auras.onlyShowPlayer = false
			Auras.showStealableBuffs = true
			Auras.spacing = C.Aura.icon_space
			Auras.numBuffs = 10
			Auras.numDebuffs = 20
			Auras.gap = true
			
			-- Register with oUF
			self.Auras = Auras
			Auras.PostCreateIcon = PostCreateIcon
			Auras.PostUpdateGapIcon = PostUpdateGapIcon
		end
    end,
	
	--========================--
    --  Target
    --========================--
    target = function(self, unit)
        UnitShared(self, unit)
		self:SetSize(C.Target.width, C.Target.height)
		
		local Auras = CreateFrame("Frame", G.addon..unit.." Auras", self)
		Auras:SetPoint("BOTTOMLEFT", self, "TOPLEFT", 0, 15)
		Auras:SetSize(C.Target.width, C.Aura.icon_size*2+C.Aura.icon_space)
			
		Auras.disableCooldown = false
		Auras.size = C.Aura.icon_size
		Auras.onlyShowPlayer = false
		Auras.showStealableBuffs = true
		Auras.spacing = C.Aura.icon_space
		Auras.numBuffs = 10
		Auras.numDebuffs = 20
		Auras.gap = true
			
		-- Register with oUF
		self.Auras = Auras
		Auras.PostCreateIcon = PostCreateIcon
		Auras.PostUpdateGapIcon = PostUpdateGapIcon
    end,
	
    --========================--
    --  Focus
    --========================--
    focus = function(self, unit)
        UnitShared(self, unit)
		self:SetSize(C.Focus.width, C.Focus.height)
		
		local Auras = CreateFrame("Frame", G.addon..unit.." Auras", self)
		Auras:SetPoint("BOTTOMLEFT", self, "TOPLEFT", 0, 15)
		Auras:SetSize(C.Focus.width, C.Aura.icon_size*2+C.Aura.icon_space)
			
		Auras.disableCooldown = false
		Auras.size = C.Aura.icon_size
		Auras.onlyShowPlayer = false
		Auras.showStealableBuffs = true
		Auras.spacing = C.Aura.icon_space
		Auras.numBuffs = 10
		Auras.numDebuffs = 20
		Auras.gap = true
			
		-- Register with oUF
		self.Auras = Auras
		Auras.PostCreateIcon = PostCreateIcon
		Auras.PostUpdateGapIcon = PostUpdateGapIcon
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
		
		local Auras = CreateFrame("Frame", G.addon..unit.." Auras", self)
		Auras:SetPoint("BOTTOMLEFT", self, "TOPLEFT", 0, 15)
		Auras:SetSize(C.Boss.width, C.Aura.icon_size*2+C.Aura.icon_space)
			
		Auras.disableCooldown = false
		Auras.size = C.Aura.icon_size
		Auras.onlyShowPlayer = false
		Auras.showStealableBuffs = true
		Auras.spacing = C.Aura.icon_space
		Auras.numBuffs = 10
		Auras.numDebuffs = 20
		Auras.gap = true
			
		-- Register with oUF
		self.Auras = Auras
		Auras.PostCreateIcon = PostCreateIcon
		Auras.PostUpdateGapIcon = PostUpdateGapIcon
    end,
	
	--========================--
    --  Arena
    --========================--
    arena = function(self, unit)
        UnitShared(self, unit)
		self:SetSize(C.Arena.width, C.Arena.height)
		
		local Auras = CreateFrame("Frame", G.addon..unit.." Auras", self)
		Auras:SetPoint("BOTTOMLEFT", self, "TOPLEFT", 0, 15)
		Auras:SetSize(C.Arena.width, C.Aura.icon_size*2+C.Aura.icon_space)
			
		Auras.disableCooldown = false
		Auras.size = C.Aura.icon_size
		Auras.onlyShowPlayer = false
		Auras.showStealableBuffs = true
		Auras.spacing = C.Aura.icon_space
		Auras.numBuffs = 10
		Auras.numDebuffs = 20
		Auras.gap = true
			
		-- Register with oUF
		self.Auras = Auras
		Auras.PostCreateIcon = PostCreateIcon
		Auras.PostUpdateGapIcon = PostUpdateGapIcon
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