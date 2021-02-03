print("n40_nvg_cl")


hook.Add( "CalcView", "MyCalcView", function( ply, pos, angles, fov )
	local view = {
		origin = pos - ( angles:Forward() * 100 ),
		angles = angles,
		fov = fov,
		drawviewer = true
	}

	return nil
end )

CreateClientConVar( "n40_luminocity", 0, true, false, "", 0, 20 )

N40_TOYTOWN = ScrH()/2

N40_NVGLIST = {
	["PVS14"] = {
		overlay = "nod2.png",
		distance = 4000,
		fov = 90,
		illum_col = Color(0,255,255),
		noise_col = Color(0,255,0,255),
		overexpose_limit = 200,
		color_mod = {
			[ "$pp_colour_addr" ] = 0,
			[ "$pp_colour_addg" ] = 1,
			[ "$pp_colour_addb" ] = 0,
			[ "$pp_colour_brightness" ] = 0,
			[ "$pp_colour_contrast" ] = 1,
			[ "$pp_colour_colour" ] = 0.25,
			[ "$pp_colour_mulr" ] = 1,
			[ "$pp_colour_mulg" ] = 0,
			[ "$pp_colour_mulb" ] = 0
		}
	},
	["PVS15"] = {
		overlay = "nod4.png",
		distance = 9000,
		fov = 110,
		illum_col = Color(0,255,255),
		noise_col = Color(255,255,255,100),
		overexpose_limit = 200,
		color_mod = {
			[ "$pp_colour_addr" ] = 0,
			[ "$pp_colour_addg" ] = 0.2,
			[ "$pp_colour_addb" ] = 0.3,
			[ "$pp_colour_brightness" ] = -0.15,
			[ "$pp_colour_contrast" ] = 0.9,
			[ "$pp_colour_colour" ] = 0.25,
			[ "$pp_colour_mulr" ] = 1,
			[ "$pp_colour_mulg" ] = 0,
			[ "$pp_colour_mulb" ] = 0
		},

	},
	["GPNVG"] = {
		overlay = "nod5.png",
		distance = 6000,
		fov = 100,
		illum_col = Color(0,255,255),
		noise_col = Color(0,255,0,255),
		overexpose_limit = 200,
		color_mod = {
			[ "$pp_colour_addr" ] = 0,
			[ "$pp_colour_addg" ] = 1,
			[ "$pp_colour_addb" ] = 0,
			[ "$pp_colour_brightness" ] = 0,
			[ "$pp_colour_contrast" ] = 0.90,
			[ "$pp_colour_colour" ] = 0.25,
			[ "$pp_colour_mulr" ] = 1,
			[ "$pp_colour_mulg" ] = 0,
			[ "$pp_colour_mulb" ] = 0
		},
	},
}

net.Receive( "n40_nvg_deactivate", function( len, pl )
	PLAYER_NOD = net.ReadString()
	N40_RemoveCastLight()
end )

net.Receive( "n40_nvg_activate", function( len, pl )
	PLAYER_NOD = net.ReadString()
	N40_CastLight()
end )
function N40_RemoveCastLight()
	if LocalPlayer().NOD then 
		LocalPlayer().NOD:Remove()
	end 
end 

mat_noise = Material( "noise_nvg_sharp" )


function N40_CastLight()
	local illumination = ProjectedTexture() -- Im not gay, but 60 fps is 60 fps
	illumination:SetTexture( "effects/flashlight001" )
	illumination:SetFarZ( N40_NVGLIST[PLAYER_NOD].distance ) 
	illumination:SetColor( N40_NVGLIST[PLAYER_NOD].illum_col )
	illumination:SetPos( LocalPlayer():GetPos()) 
	illumination:SetAngles( LocalPlayer():EyeAngles() )
	illumination:SetFOV( N40_NVGLIST[PLAYER_NOD].fov )
	illumination:SetEnableShadows(false)
	illumination:Update()
	LocalPlayer().NOD = illumination 
end 

hook.Add( "Think", "N40_ThinkHookNOD", function()
	if LocalPlayer():GetNWBool("N40_PLAYER_NVG_ACTIVE") == true then 
		LocalPlayer().NOD:SetPos( LocalPlayer():EyePos()+Vector(0,0,2) + LocalPlayer():GetForward()*4 )
		LocalPlayer().NOD:SetAngles( LocalPlayer():GetAngles() )

		---https://steamcommunity.com/sharedfiles/filedetails/?id=2242151511
		local complight = math.max((render.ComputeLighting(LocalPlayer():GetPos()+Vector(0,0,40),Vector(0,0,-1))*Vector(255,255,255)):Length(),(render.ComputeLighting(LocalPlayer():GetPos()+Vector(0,0,40),Vector(0,0,1))*Vector(255,255,255)):Length(),(render.ComputeLighting(LocalPlayer():GetPos()+Vector(0,0,40),Vector(0,1,0))*Vector(255,255,255)):Length(),(render.ComputeLighting(LocalPlayer():GetPos()+Vector(0,0,40),Vector(0,-1,0))*Vector(255,255,255)):Length(),(render.ComputeLighting(LocalPlayer():GetPos()+Vector(0,0,40),Vector(1,0,0))*Vector(255,255,255)):Length(),(render.ComputeLighting(LocalPlayer():GetPos()+Vector(0,0,40),Vector(-1,0,0))*Vector(255,255,255)):Length())
  		local complight = math.max((render.ComputeLighting(LocalPlayer():GetPos(),Vector(0,0,-1))*Vector(255,255,255)):Length(),(render.ComputeLighting(LocalPlayer():GetPos(),Vector(0,0,1))*Vector(255,255,255)):Length())
   	 	luminocity = math.Clamp(complight/2.8 + ((LocalPlayer():FlashlightIsOn() and 1 or 0)*100),0,255)
    	if luminocity <= 1 then luminocity = 1 end
    	if luminocity >= 200 then N40_TOYTOWN = ScrH() else N40_TOYTOWN = ScrH()/2 end
    	LocalPlayer().NOD:SetBrightness( GetConVar("n40_luminocity"):GetFloat()*luminocity )
    	LocalPlayer().NOD:Update()
	end 
end )



hook.Add( "RenderScreenspaceEffects", "color_modify_example", function()
	if LocalPlayer():GetNWBool("N40_PLAYER_NVG_ACTIVE") == true then 
		DrawColorModify( N40_NVGLIST[PLAYER_NOD].color_mod )
		DrawToyTown(8, N40_TOYTOWN)
		DrawBloom(0.5, 1, 5, 5, 1, 0, 1, 1, 1)
	end
end )


hook.Add( "HUDPaint", "N40_ThinkHookNOD", function()
	if LocalPlayer():GetNWBool("N40_PLAYER_NVG_ACTIVE") == true then 
 		 DrawMaterialOverlay(N40_NVGLIST[PLAYER_NOD].overlay, 0)
	end 
end )

hook.Add( "HUDPaintBackground", "N40_ThinkHookNOD2", function()
	if LocalPlayer():GetNWBool("N40_PLAYER_NVG_ACTIVE") == true then 
 		surface.SetMaterial( mat_noise )
  		surface.SetDrawColor( N40_NVGLIST[PLAYER_NOD].noise_col )
   		surface.DrawTexturedRect( 0 , 0 , ScrW(), ScrH() )
   		surface.DrawTexturedRect( 0 , 0 , ScrW(), ScrH() )
   		surface.DrawTexturedRect( 0 , 0 , ScrW(), ScrH() )
	end 
end )

-- Duct taped together by https://steamcommunity.com/id/FockingPizza/


