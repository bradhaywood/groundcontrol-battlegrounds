-- SERVER RELATED STUFF

include "shared.lua"
AddCSLuaFile "shared.lua"

-- Throw everything in the post init hook so we can reliably get the gamemode tables
hook.Add("GroundControlPostInitEntity", "Post Init", function()
	GroundControl = gmod.GetGamemode() -- grab the gamemode tables

	Battlegrounds.mapRotation = GroundControl:getMapRotation("one_side_rush")

	function Battlegrounds:postPlayerDeath(ply) -- check for round over possibility
		GroundControl:checkRoundOverPossibility(ply:Team())
	end

	function Battlegrounds:playerDisconnected(ply)
		local hisTeam = ply:Team()
		-- nothing fancy, just skip 1 frame and call postPlayerDeath,
		-- since 1 frame later the player won't be anywhere in the player tables
		timer.Simple(0, function()
			GroundControl:checkRoundOverPossibility(hisTeam, true)
		end)
	end

	function Battlegrounds:playerJoinTeam(ply, teamId)
		GroundControl:checkRoundOverPossibility(nil, true)
	end

  GroundControl:registerNewGametype(Battlegrounds)
end)