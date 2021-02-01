print("n40_nvg_cl")

mat_noise = Material( "noise_nvg_sharp" )
mat_overlay = "nod2.png"
nvg_distance = 4000
nvg_fov = 90

-- n40_luminocity convars controlls luminocity (wow)

CreateClientConVar( "n40_luminocity", 0, true, false, "", 0, 20 )

local NOD_PVS14 = {
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

net.Receive( "n40_nvg_dectivate", function( len, pl )
	N40_RemoveCastLight()
end )

net.Receive( "n40_nvg_activate", function( len, pl )
	N40_CastLight()
end )

function N40_RemoveCastLight()
	if LocalPlayer().NOD then 
		LocalPlayer().NOD:Remove()
	end 
end 

function N40_CastLight()
	local illumination = ProjectedTexture() -- Im not gay, but 60 fps is 60 fps
	illumination:SetTexture( "effects/flashlight001" )
	illumination:SetFarZ( nvg_distance ) 
	illumination:SetColor(Color(0,255,255))
	illumination:SetPos( LocalPlayer():GetPos()) 
	illumination:SetAngles( LocalPlayer():GetAngles() )
	illumination:SetFOV(nvg_fov)
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

    	LocalPlayer().NOD:SetBrightness( GetConVar("n40_luminocity"):GetFloat()*luminocity )
    	LocalPlayer().NOD:Update()
	end 
end )



hook.Add( "RenderScreenspaceEffects", "color_modify_example", function()
	if LocalPlayer():GetNWBool("N40_PLAYER_NVG_ACTIVE") == true then 
		DrawColorModify( NOD_PVS14 )
		DrawToyTown(8, ScrH() / 2)
		DrawBloom(0.5, 1, 5, 5, 1, 0, 1, 1, 1)
	end
end )


hook.Add( "HUDPaint", "N40_ThinkHookNOD", function()
	if LocalPlayer():GetNWBool("N40_PLAYER_NVG_ACTIVE") == true then 
 		 DrawMaterialOverlay(mat_overlay, 0)
	end 
end )

hook.Add( "HUDPaintBackground", "N40_ThinkHookNOD2", function()
	if LocalPlayer():GetNWBool("N40_PLAYER_NVG_ACTIVE") == true then 
 		surface.SetMaterial( mat_noise )
  		surface.SetDrawColor( Color(2,255,2,255) )
   		surface.DrawTexturedRect( 0 , 0 , ScrW(), ScrH() )
   		surface.DrawTexturedRect( 0 , 0 , ScrW(), ScrH() )
   		surface.DrawTexturedRect( 0 , 0 , ScrW(), ScrH() )
	end 
end )

-- Duct taped together by https://steamcommunity.com/id/FockingPizza/