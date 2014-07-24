local addon_name, ns = ...

ns[1] = {} -- Config
ns[2] = {} -- Functions
ns[3] = {} -- Globals
ns[4] = {} -- Localization

local C, F, G, L = unpack(ns)

--[[------------------>>  Globals  <<------------------]]--


G.addon = "oUF_Jim_"

G.font = "Interface\\AddOns\\oUF_Jim\\media\\font.ttf"

G.media = {
	blank = "Interface\\Buttons\\WHITE8x8",
	bar = "Interface\\AddOns\\oUF_Jim\\media\\texture",
}

--[[------------------>>  Config  <<------------------]]--

C.Font = {
	Normal_FontSize = 12,
	Small_FontSize = 16,
}

C.Aura = {
	icon_space = 7,
	icon_size = 28,
	show_player = true, -- 显示玩家身上的光环
}

C.Player = { -- 玩家
	height = 32,
	width = 280,
	positon = {a1 = "TOPRIGHT", parent= "UIParent", a2 = "CENTER", x = "-120", y = "-60"},
}

C.Target = { -- 目标
	height = 32,
	width = 280,
	positon = {a1 = "TOPLEFT", parent= "UIParent", a2 = "CENTER", x = "120", y = "-60"},
}

C.Focus = { -- 焦点
	height = 32,
	width = 280,
	positon = {a1 = "TOPLEFT", parent= "UIParent", a2 = "CENTER", x = "120", y = "60"},
}

C.Pet = { -- 宠物
	height = 32,
	width = 80,
	positon = {a1 = "TOPRIGHT", parent= "UIParent", a2 = "CENTER", x = "-405", y = "-60"},
}

C.ToT = { -- 目标的目标
	height = 32,
	width = 80,
	positon = {a1 = "TOPLEFT", parent= "UIParent", a2 = "CENTER", x = "405", y = "-60"},
}

C.ToF = { -- 焦点的目标
	height = 32,
	width = 80,
	positon = {a1 = "TOPLEFT", parent= "UIParent", a2 = "CENTER", x = "405", y = "60"},
}

C.Boss = { -- 首领
	height = 32,
	width = 160,
	positon = {a1 = "TOPRIGHT", parent= "UIParent", a2 = "RIGHT", x = "-100", y = "120"},
	space = 80,
}

C.Arena = { -- 竞技场敌人
	height = 32,
	width = 160,
	positon = {a1 = "TOPRIGHT", parent= "UIParent", a2 = "RIGHT", x = "-100", y = "120"},
	space = 80,
}
