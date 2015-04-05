-- Name: 	Custom Flight Master Script for cMangos. 
-- Details:	With option to require gold or custom item as price for taxi service & configurable conditions. 
-- 			Easy to configure. Copy a the Flight[#] {} and enter the correct config for each flight path
--			You can add Player conditions to your flight paths. See for reference: http://eluna.emudevs.com/Player/index.html
-- Website: https://github.com/RStijn

-- Init
local FLIGHT = {}


-- Config
local NPC_FLIGHTMASTER = 500022 	-- Creature ID. CreatureType must be 3 & NpcFlags 512 or higher.
local MOUNT_DISPLAYID_A = 28135		-- Display ID of flying mount for Alliance
local MOUNT_DISPLAYID_H = 28135		-- Display ID of flying mount for Horde

local function flightConfig(player)
	-- Flight 1 - Basic
	FLIGHT[1] = {} 
	FLIGHT[1][0] = "Take me up that mountain."		-- NPC Gossip Menu Text
	FLIGHT[1][1] = {	
		{0, -13838, 3098, 5}, 			-- WAYPOINT 1
		{0, -13947, 3106, 180},			-- WAYPOINT 2
		{0, -14099, 3111, 188},
	}
	FLIGHT[1][2] = 2500					-- Cost for taxi services 10000 = 1 Gold	default: 0
	FLIGHT[1][3] = 500000				-- Custom item ID as cost price				default: 0
	FLIGHT[1][4] = 50					-- Amount of custom item to take			default: 0
	-- end Flight 1

	-- Flight 2 - With Condition
	if (player:GetLevel() >= 30) then
		FLIGHT[2] = {}
		FLIGHT[2][0] = "Take me to Stranglethorn Vale."		-- NPC Gossip Menu Text
	
		if player:IsAlliance() then
			FLIGHT[2][1] = {
				{0, -13838, 3098, 5},
				{0, -13800, 2913, 60},			-- WAYPOINT 1
				{0, -11758, 107, 134},			-- WAYPOINT 2
				{0, -11614, -41, 12},
			}
		else -- horde
			FLIGHT[2][1] = {
				{0, -13838, 3098, 5},
				{0, -13800, 2913, 60},			-- WAYPOINT 2
				{0, -12438, 296, 25},			-- WAYPOINT 2
				{0, -12391, 196, 4},
			}
		end
		FLIGHT[2][2] = 2500					-- Cost for taxi services 10000 = 1 Gold
		FLIGHT[2][3] = 500000				-- Custom item ID as cost price
		FLIGHT[2][4] = 50					-- Amount of custom item to take
	end
	-- end Flight 2
	
end



-- Functions
local function startFlight(player, fly)
	-- check if player can afford cost
	if (player:GetCoinage() >= fly[2] and player:GetItemCount(fly[3]) >= fly[4]) then
		-- start flight
		local path = AddTaxiPath(fly[1], MOUNT_DISPLAYID_A, MOUNT_DISPLAYID_H)
		player:StartTaxi(path)
		
		-- remove cost
		player:ModifyMoney(fly[2]-fly[2]-fly[2])
		player:RemoveItem(fly[3],fly[4])
	else
		player:SendBroadcastMessage("You can't afford to take this flight.")
	end
end

function On_Gossip(event, player, unit)
	flightConfig(player)
	local i = 1
	
	-- Add to gossip menu
    while FLIGHT[i] do
      player:GossipMenuAddItem(0, FLIGHT[i][0], 0, i)
      i = i + 1
    end
	
	player:GossipSendMenu(1, unit)
end

function On_Select(event, player, unit, sender, intid, code)
	flightConfig(player)
	startFlight(player, FLIGHT[intid])
	player:GossipComplete()
end


RegisterCreatureGossipEvent(NPC_FLIGHTMASTER, 1, On_Gossip)
RegisterCreatureGossipEvent(NPC_FLIGHTMASTER, 2, On_Select)