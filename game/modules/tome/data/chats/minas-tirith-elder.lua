newChat{ id="welcome",
	text = [[Welcome @playername@ to Minas Tirith traveler, please be quick my time is precious.]],
	answers = {
		{"I have found this staff in my travels, it looks really old and powerful. I dare not use it.", jump="found_staff", cond=function(npc, player) return player:isQuestStatus("staff-absorption", engine.Quest.PENDING) and player:findInAllInventories("Staff of Absorption") end},
		{"Nothing, excuse me. Bye!"},
	}
}

newChat{ id="found_staff",
	text = [[#LIGHT_GREEN#*He examines the staff*#WHITE# Indeed you were right in bringing it here. While I cannot sense its true purpose I feel this could be used to cause many wrongs.
Please surrender the staff to the protection of the King while we work to learn its power.
This could be related to the rumours we hear from the far east...]],
	answers = {
		{"Take it Sir.", action=function(npc, player)
			local o, item, inven_id = player:findInAllInventories("Staff of Absorption")
			player:removeObject(inven_id, item, true)
			o:removed()

			player:setQuestStatus("staff-absorption", engine.Quest.DONE)
			player.winner = true
			local D = require "engine.Dialog"
			D:simplePopup("Winner!", "#VIOLET#Congratulations you have won the game! At least for now... The quest has only started!")

--			game:setAllowedBuild("evil_race", true)
		end},
	}
}

return "welcome"
