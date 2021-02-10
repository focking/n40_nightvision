AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

function ENT:Initialize()
		if SERVER then
		self:SetModel("models/noightvision/gpnvg-1.mdl")
        self:SetMoveType( MOVETYPE_VPHYSICS )
        self:SetSolid( SOLID_VPHYSICS )
        self:PhysicsInit( SOLID_VPHYSICS )
        self:SetUseType(SIMPLE_USE)
        self:DrawShadow( true )
        local phys = self:GetPhysicsObject()
        if phys:IsValid() then
            phys:Wake()
            phys:SetBuoyancyRatio(0)
            phys:SetMass(2)
        end

    end
end

function ENT:Use(activator,caller)
    if activator:IsPlayer() then 
        if activator.N40_NOD != "" then return end
        activator:SetNWString("N40_PLAYER_NVG","GPNVG")
        activator.N40_NOD = "n40_gpnvg"
        self:Remove()
    end 
end 

