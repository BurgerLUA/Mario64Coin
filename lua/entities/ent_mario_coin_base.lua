ENT.Type 				= "anim"
ENT.Base 				= "base_entity"
ENT.PrintName 			= "Base Coin"
ENT.Author 				= ""
ENT.Information 		= ""

ENT.Spawnable 			= false
ENT.AdminSpawnable		= false 
ENT.Category			= "Super Mario 64"

AddCSLuaFile()

ENT.CoinColor			= Color(255,255,0)
ENT.Worth				= 1
ENT.CoinSize			= 12
ENT.Unicorn 			= false

function ENT:Initialize()

	if SERVER then
	
		local adjustedsize = self.CoinSize/2
	
		self:SetModel("models/dav0r/hoverball.mdl")
		self:PhysicsInitSphere( adjustedsize, "metal" )
		self:SetCollisionBounds( Vector( -adjustedsize, -adjustedsize, -adjustedsize ), Vector( adjustedsize, adjustedsize, adjustedsize ) )
		self:SetCollisionGroup( COLLISION_GROUP_DEBRIS )
		
		
		--self:DrawShadow(false)

	
		local phys = self:GetPhysicsObject()
		if phys:IsValid() then
			phys:Wake()
			phys:SetBuoyancyRatio(0)
		end
		
	end
	
	self:SetColor(self.CoinColor)

	
	
end

function ENT:SpawnFunction( ply, tr, ClassName )

	if ( !tr.Hit ) then return end

	local SpawnPos = tr.HitPos + tr.HitNormal * self.CoinSize

	local ent = ents.Create( ClassName )
	ent:SetPos( SpawnPos )
	ent:Spawn()
	ent:Activate()

	return ent

end



function ENT:Think()
	if SERVER then
	
	if self.Unicorn == true then

		self:SetColor(Color(math.Rand(0,255),math.Rand(0,255),math.Rand(0,255)))
	
	end
	
	
		local tracesettings = { start = self:GetPos(), endpos = self:GetPos(), filter = self }
		local tr = util.TraceEntity( tracesettings , self )
		
		if tr.Hit then
			if tr.Entity:IsPlayer() then
				self:CoinGrab(tr.Entity)
			end
		end
	end
end




function ENT:PhysicsCollide(data,physobj)
	
	if data.Speed > 10 then
		self:EmitSound("mario64/bestcoin.wav",75,120)
	end
	
	physobj:SetVelocity(-data.HitNormal * data.OurOldVelocity:Length() * 0.75)
	
end

--[[
function ENT:Use(user)
	self:CoinGrab(user)
end

function ENT:Touch(toucher)
	self:CoinGrab(toucher)
end
--]]

function ENT:CoinGrab(GrabEntity)
	if GrabEntity:IsPlayer() then
		
		
		if self.Worth > 1 then
			for i=1, self.Worth do
				timer.Simple(i*0.05 - 0.05, function () 
					GrabEntity:EmitSound("mario64/bestcoin.wav")
					GrabEntity:SetHealth(math.min(GrabEntity:Health() + 1 , GrabEntity:GetMaxHealth()))
				end)
			end
		else
			GrabEntity:SetHealth(math.min(GrabEntity:Health() + 1 , GrabEntity:GetMaxHealth()))
			GrabEntity:EmitSound("mario64/bestcoin.wav")
		end
		
		self:Remove()
	end
end




local mat = Material("sprites/mario64coin")

function ENT:Draw()
	local pos = self:GetPos()

	render.SetMaterial( mat )
	render.DrawSprite( pos, self.CoinSize, self.CoinSize, self:GetColor() )
end
