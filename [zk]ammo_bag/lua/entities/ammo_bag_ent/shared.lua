
AddCSLuaFile()

ENT.Base 		= "base_gmodentity"
ENT.Type 		= "anim"
ENT.PrintName 	= "Ammo Bag"
ENT.Category 	= "Zaktak's"
ENT.Author 		= "Zaktak"
ENT.Spawnable 	= false

ENT.AmmoHold 	= 500
ENT.AmmoBonus 	= 50

if SERVER then

    function ENT:Initialize()
        self:SetModel( "models/items/ammocrate_grenade.mdl" )
        self:PhysicsInit(SOLID_VPHYSICS)
        self:SetCollisionGroup(COLLISION_GROUP_WORLD)
        self:SetSolid(SOLID_VPHYSICS)
        self:SetTrigger(true)
        self:SetUseType( SIMPLE_USE )
        self.UsedBefore = false

        local phys = self:GetPhysicsObject()

        if (IsValid(phys)) then
            phys:EnableGravity(true)
            phys:Wake()
        end

    end

end

function ENT:Use(ply)
	if ( self.AmmoHold < self.AmmoBonus  ) then return end
	if ( !IsValid(self) ) then return end

	if ( self.UsedBefore == false ) then
		local rnd = math.random(1, 3)
		self:EmitSound("doors/vent_open"..rnd..".wav", 75, math.random(70,90), math.random(0.4, 0.8))
	end

	self.UsedBefore = true

	ply:PrintMessage( HUD_PRINTCENTER, "Picked up "..self.AmmoBonus.." ammo." )
	
	self.AmmoHold = self.AmmoHold - self.AmmoBonus

	local wep = ply:GetActiveWeapon()
	local ammoType = wep:GetPrimaryAmmoType()
	
	ply:GiveAmmo(self.AmmoBonus, ammoType, false)
end


function ENT:Draw()
    self:DrawModel()
end

function ENT:Think()
	if ( !IsValid(self) ) then return end
	if ( self.AmmoHold == 0 ) then
		self:Remove()
	else
		self:NextThink( CurTime() + 5 ) -- O_O
	end
end
