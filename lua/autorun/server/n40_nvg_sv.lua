print("n40_nvg")
util.AddNetworkString( "n40_nvg_activate" )
util.AddNetworkString( "n40_nvg_dectivate" )


-- N40_PLAYER_NVG_ACTIVE 
-- N40_PLAYER_HAS_NVG

concommand.Add("n40_nod", function( ply, cmd, args )
	if ply:GetNWBool("N40_PLAYER_HAS_NVG") == false then ply:ChatPrint("You dont have NVG") return end  

	if ply:GetNWBool("N40_PLAYER_NVG_ACTIVE") == false then   
		ply:EmitSound("nod/down.wav")
		ply:ScreenFade(SCREENFADE.IN, Color(0,0,0), 1, 0.2 )
		net.Start("n40_nvg_activate")
		net.Send(ply)
		ply:SetNWBool("N40_PLAYER_NVG_ACTIVE",true)
	else 
		ply:EmitSound("nod/up.wav")
		ply:ScreenFade(SCREENFADE.IN, Color(0,0,0), 1, 0.4 )
		net.Start("n40_nvg_dectivate")
		net.Send(ply)
		ply:SetNWBool("N40_PLAYER_NVG_ACTIVE",false)
	end 

end)


function N40_HasNods(ply)
	if ply:GetNWBool("N40_PLAYER_HAS_NVG") == true then return true else return false end 
end

hook.Add( "PlayerDeath", "N40_NodRemove", function( victim, inflictor, attacker )
	if N40_HasNods(victim) then 
		net.Start("n40_nvg_dectivate")
		net.Send(victim)
		victim:SetNWBool("N40_PLAYER_NVG_ACTIVE", false)
		victim:GetNWBool("N40_PLAYER_HAS_NVG", false)
	end
end)

hook.Add( "PlayerSpawn", "N40_NodRemoveSpawn", function(ply)
	ply:SetNWBool("N40_PLAYER_NVG_ACTIVE", false)
	ply:GetNWBool("N40_PLAYER_HAS_NVG", false)
end )

-- Duct taped together by https://steamcommunity.com/id/FockingPizza/