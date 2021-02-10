print("n40_nvg")
util.AddNetworkString( "n40_nvg_activate" )
util.AddNetworkString( "n40_nvg_deactivate" )


-- N40_PLAYER_NVG_ACTIVE 
-- PLY.N40_NOD
concommand.Add("n40_nod", function( ply, cmd, args )

	if ply.N40_NOD == "" then return false end

	if ply:GetNWBool("N40_PLAYER_NVG_ACTIVE") == false then   
		ply:EmitSound("nod/down.wav")
		ply:ScreenFade(SCREENFADE.IN, Color(0,0,0), 1, 0.2 )
		net.Start("n40_nvg_activate")
		net.WriteString(ply.N40_NOD)
		net.Send(ply)
		ply:SetNWBool("N40_PLAYER_NVG_ACTIVE",true)
	else 
		ply:EmitSound("nod/up.wav")
		ply:ScreenFade(SCREENFADE.IN, Color(0,0,0), 1, 0.4 )
		net.Start("n40_nvg_deactivate")
		net.WriteString(ply.N40_NOD)
		net.Send(ply)
		ply:SetNWBool("N40_PLAYER_NVG_ACTIVE",false)
	end 

end)


concommand.Add("n40_nod_drop", function( ply, cmd, args )
	if ply:GetNWBool("N40_PLAYER_NVG_ACTIVE") == true then
		ply:EmitSound("nod/up.wav")
		ply:ScreenFade(SCREENFADE.IN, Color(0,0,0), 1, 0.4 )
		net.Start("n40_nvg_deactivate")
		net.WriteString(ply.N40_NOD)
		net.Send(ply)
		ply:SetNWBool("N40_PLAYER_NVG_ACTIVE",false)	
		N40_DropNods(ply)
	else 
		N40_DropNods(ply)
	end 
end) 

function N40_DropNods(ply)
	if ply.N40_NOD == "" then return false end
	local nods = ents.Create(ply.N40_NOD)
	local tr = util.TraceLine( {
		start = ply:EyePos(),
		endpos = ply:GetPos() + ply:GetForward() * 32 + ply:GetUp() * 32,
		filter = ply,
	} )
	nods:SetPos(tr.HitPos)
	nods:Spawn()
	ply.N40_NOD = ""
end 

hook.Add( "PlayerDeath", "N40_NodRemove", function( victim, inflictor, attacker )
	net.Start("n40_nvg_deactivate")
	net.Send(victim)
	victim:SetNWBool("N40_PLAYER_NVG_ACTIVE", false)
	victim.N40_NOD = ""
end)

hook.Add( "PlayerSpawn", "N40_NodRemoveSpawn", function(ply)
	ply:SetNWBool("N40_PLAYER_NVG_ACTIVE", false)
	ply.N40_NOD = ""
end )

-- Duct taped together by https://steamcommunity.com/id/FockingPizza/