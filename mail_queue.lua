-- Name: 	Send Mail Queue
-- Details:	Send mails in-game from an external application.
-- Usage:	Insert rows to mail_queue to send them when a player logs in.
-- Website: https://github.com/RStijn


-- Send queue
function SendMailQueue(event, irrelevantPlr)
	local query = CharDBQuery("SELECT * FROM mail_queue");
		
	while query:GetRowCount() ~= 0 do
		local row = query:GetRow(1);
		CharDBQuery("DELETE FROM mail_queue WHERE id=" .. row["id"]);
		
		local sender = 0;
		if row["sender"] ~= "" then
			sender = GetGUIDLow(GetPlayerByName(VerifyName(row["sender"])):GetGUID());
		end
		
		local receiver = 0;
		if row["receiver"] == "" then
			return false;
		end
		receiver = GetGUIDLow(GetPlayerByName(VerifyName(row["receiver"])):GetGUID());
		
		if (row["item"] == 0) then
			SendMail(row["subject"], row["body"], receiver, sender, row["stationery"], 0, 0, 0);
		else
			SendMail(row["subject"], row["body"], receiver, sender, row["stationery"], 0, 0, 0, row["item"], row["item_count"]);
		end
		
		query = CharDBQuery("SELECT * FROM mail_queue");
	end
	
end

-- Set correct character case
function VerifyName(name)
	name = name:lower();
	return (name:gsub("^%l", string.upper))
end


-- On login event event
RegisterPlayerEvent(3, SendMailQueue);

-- Create table
CharDBQuery("CREATE TABLE IF NOT EXISTS mail_queue (id int(10) NOT NULL AUTO_INCREMENT, sender varchar(16) NOT NULL, receiver varchar(16) NOT NULL, subject varchar(64) NOT NULL, body varchar(500) NOT NULL, item int(10) NOT NULL DEFAULT '0', item_count int(3) NOT NULL DEFAULT '0', stationery int(11) NOT NULL DEFAULT '41', PRIMARY KEY (id))");