AddCSLuaFile()


ENT.Type 				= "anim"
ENT.Base 				= "base_entity"
ENT.PrintName 			= "Base Coin"
ENT.Author 				= ""
ENT.Information 		= ""

ENT.Spawnable 			= false
ENT.AdminSpawnable		= false 
ENT.Category			= "Super Mario 64"
ENT.RenderGroup			= RENDERGROUP_TRANSLUCENT



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
	
		local tracedata = {}
		tracedata.start = self:GetPos()
		tracedata.endpos = self:GetPos()
		tracedata.mins = Vector( -30, -30, -30 )
		tracedata.maxs = Vector( 30, 30, 30 )
		tracedata.ignoreworld = true
		
		

		
		local tr = util.TraceHull( tracedata )
	
		--print(tr.Entity)

		--local tracesettings = { start = self:GetPos(), endpos = self:GetPos(), filter = self }
		--local tr = util.TraceEntity( tracedata , self )
		
		if tr.Hit then
			if tr.Entity:IsPlayer() then
				self:CoinGrab(tr.Entity)
			end
		end
	end
end


function ENT:PhysicsCollide(data,physobj)
	
	local zspeed =  math.abs(data.OurOldVelocity.z)

	if zspeed > 50  then
		self:EmitSound("mario64/bestcoin.wav",75,120)
	end
	
	physobj:AddVelocity( (-data.HitNormal * data.OurOldVelocity:Length() * 0.5))
	
end

function ENT:CoinGrab(GrabEntity)
	if GrabEntity:IsPlayer() then
		
		local CountMultiplier = GetConVar("sv_mario_coins_healthmul"):GetFloat()
		
		local ShouldAddHealth = GrabEntity:Health() < GrabEntity:GetMaxHealth()
		
		if self.Worth > 1 then
			for i=1, self.Worth do
				timer.Simple(i*0.05 - 0.05, function () 
					GrabEntity:EmitSound("mario64/bestcoin.wav")
					if ShouldAddHealth then
						GrabEntity:SetHealth(math.min(GrabEntity:Health() + 1*CountMultiplier , GrabEntity:GetMaxHealth()))
					end
				end)
			end
		else
			GrabEntity:EmitSound("mario64/bestcoin.wav")
			if ShouldAddHealth then
				GrabEntity:SetHealth(math.min(GrabEntity:Health() + 1*CountMultiplier , GrabEntity:GetMaxHealth()))
			end
		end
		
		self:Remove()
	end
end




local mat = Material("sprites/mario64coin")

function ENT:DrawTranslucent()
	local pos = self:GetPos()

	render.SetMaterial( mat )
	render.DrawSprite( pos, self.CoinSize, self.CoinSize, self:GetColor() )
	
	--[[
	local tracedata = {}
	tracedata.start = self:GetPos()
	tracedata.endpos = self:GetPos()
	tracedata.mins = Vector( -30, -30, -30 )
	tracedata.maxs = Vector( 30, 30, 30 )

	local tr = util.TraceHull( tracedata )
	
	render.DrawWireframeBox( tracedata.start, Angle( 0, 0, 0 ), tracedata.mins, tracedata.maxs, Color( 255, 255, 255 ), true )
	--]]
end
