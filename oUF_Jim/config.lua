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

