-- Name: Teleporter Script for cMangos. 
-- Website: https://github.com/RStijn

-- Config
local NPC_ID = 500001


function On_Gossip(event, player, unit)
	-- Menus
	player:GossipMenuAddItem(0, "Teleport: Gilijim's Isle", 0, 1)
	
	-- Only for specific faction
	if (player:IsAlliance()) then
		player:GossipMenuAddItem(0, "Teleport: Stormwind", 0, 2)
	elseif (player:IsHorde()) then
		player:GossipMenuAddItem(0, "Teleport: Orgrimmar", 0, 3)
	end
	
	player:GossipMenuAddItem(0, "Custom Location", 0, 4)
	player:GossipMenuAddItem(0, "Custom Location", 0, 5)
	player:GossipMenuAddItem(0, "Custom Location", 0, 6)

	player:GossipSendMenu(1, unit)
end

function On_Select(event, player, unit, sender, intid, code)
	-- Teleports

	-- Gilijim's Isle
	if (intid == 1) then
		player:Teleport(0, -13925, 2958, 8, 4.5)
	end

	-- Stormwind
	if (intid == 2) then
		player:Teleport(0, -8905, 560, 94)
	end

	-- Orgrimmar
	if (intid == 3) then
		player:Teleport(1, -8905, 560, 94)
	end
	
	-- Custom
	if (intid == 4) then
		player:Teleport(0, 0, 0, 0)
	end
	
	-- Custom
	if (intid == 5) then
		player:Teleport(0, 0, 0, 0)
	end
	
	-- Custom
	if (intid == 6) then
		player:Teleport(0, 0, 0, 0)
	end

	player:GossipComplete()
end


RegisterCreatureGossipEvent(NPC_ID, 1, On_Gossip)
RegisterCreatureGossipEvent(NPC_ID, 2, On_Select)