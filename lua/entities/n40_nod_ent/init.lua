AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

function ENT:Initialize()
		if SERVER then
		self:SetModel("models/nods/pvs14.mdl")
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
        if activator:GetNWBool("N40_PLAYER_HAS_NVG") == true then return end 
        activator:SetNWBool("N40_PLAYER_HAS_NVG",true)
        self:Remove()
    end 
end 

