-- Name: 	Reload Scripts
-- Details:	Reloads lua scripts for faster development.
-- Usage:	Type "reload scripts" in the mangosd console.		
-- Website: https://github.com/RStijn

-- Functions
function reloadElunaEngine(event, player, command)
  if command == "reload scripts" or command == "reloadscripts" then 
	ReloadEluna()
  end
end

RegisterPlayerEvent(42, reloadElunaEngine)