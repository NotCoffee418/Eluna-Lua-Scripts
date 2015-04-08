-- Name:    Custom Flight Master Script for cMangos.
-- Details: With option to require gold or custom item as price for taxi service & configurable conditions.
--          Easy to configure. Copy a the Flight[#] {} and enter the correct config for each flight path
--          You can add Player conditions to your flight paths. See for reference: http://eluna.emudevs.com/Player/index.html
-- Website: https://github.com/RStijn
 
-- Config
local NPC_FLIGHTMASTER  = 500022    -- Creature ID. CreatureType must be 3 & NpcFlags 512 or higher.
local MOUNT_DISPLAYID_A = 28135     -- Display ID of flying mount for Alliance
local MOUNT_DISPLAYID_H = 28135     -- Display ID of flying mount for Horde
 
-- To leave costs or tokens out, remove them from the list or set them as nil
local FLIGHT = {
    -- Basic flight path
    {
        label       = "Take me up that mountain.",  -- NPC Gossip Menu Text
        cost        = 2500,                         -- Cost for taxi services 10000 = 1 Gold    default: 0
        token       = 500000,                       -- Custom item ID as cost price             default: 0
        token_count = 50,                           -- Amount of custom item to take            default: 0
        waypoints = {
            {
                path = {
                    {0, -13838, 3098, 5},               -- WAYPOINT 1
                    {0, -13947, 3106, 180},             -- WAYPOINT 2
                    {0, -14099, 3111, 188},
                },
            },
        },
    },
   
    -- Flight path with conditions
    {
        -- condition predicate function list that return true if the player can see this option
        conditions = {
            function(player)
                return player:GetLevel() >= 30
            end,
        },
       
        label       = "Take me to Stranglethorn Vale.", -- NPC Gossip Menu Text
        cost        = 2500,                             -- Cost for taxi services 10000 = 1 Gold
        token       = 500000,                           -- Custom item ID as cost price
        token_count = 50,                               -- Amount of custom item to take
        waypoints = {
            {
                -- condition predicate functions that return true if the player can use this route
                conditions = {
                    Player.IsAlliance,
                },
                path = {
                    {0, -13838, 3098, 5},
                    {0, -13800, 2913, 60},      -- WAYPOINT 1
                    {0, -11758, 107, 134},      -- WAYPOINT 2
                    {0, -11614, -41, 12},
                },
            },
            {
                -- condition predicate functions that return true if the player can use this route
                conditions = {
                    Player.IsHorde,
                },
                path = {
                    {0, -13838, 3098, 5},
                    {0, -13800, 2913, 60},      -- WAYPOINT 2
                    {0, -12438, 296, 25},       -- WAYPOINT 2
                    {0, -12391, 196, 4},
                },
            },
        },
    },
}
 
-- Create flight paths from points and save their IDs to the FLIGHT table at FLIGHT[intid].waypoints[i].path
for k,v in ipairs(FLIGHT) do
    if (v.waypoints) then
        for k2,v2 in ipairs(v.waypoints) do
            if (v2.path) then
                v2.path = AddTaxiPath(v2.path, MOUNT_DISPLAYID_A, MOUNT_DISPLAYID_H)
            end
        end
    end
end
 
-- Functions
local function TestConditions(conds, player)
    if (not conds) then
        return true
    end
    if (not player) then
        return false
    end
    for k,v in ipairs(conds) do
        if (not v(player)) then
            return false
        end
    end
    return true
end
 
local function startFlight(player, flight)
    -- check if player can afford cost
    if ((not flight.cost or player:GetCoinage() >= flight.cost) and (not flight.token or player:GetItemCount(flight.token) >= (flight.token_count or 0))) then
        if (flight.cost) then
            player:ModifyMoney(-flight.cost)
        end
        if (flight.token) then
            player:RemoveItem(flight.token, flight.token_count or 0)
        end
       
        for k,v in ipairs(flight.waypoints) do
            if (TestConditions(v.conditions, player)) then
                player:StartTaxi(v.path)
                break -- stop on first valid path
            end
        end
    else
        player:SendNotification("You can't afford to take this flight")
    end
end
 
local function On_Gossip(event, player, unit)
    for k,v in ipairs(FLIGHT) do
        if (TestConditions(v.conditions, player)) then
            player:GossipMenuAddItem(0, v.label, 0, k, nil, nil, v.cost)
        end
    end
    player:GossipSendMenu(1, unit)
end
 
local function On_Select(event, player, unit, sender, intid, code)
    startFlight(player, FLIGHT[intid])
    player:GossipComplete()
end
 
RegisterCreatureGossipEvent(NPC_FLIGHTMASTER, 1, On_Gossip)
RegisterCreatureGossipEvent(NPC_FLIGHTMASTER, 2, On_Select)