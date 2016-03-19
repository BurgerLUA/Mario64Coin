
CreateConVar("sv_mario_coins_player", "0", FCVAR_REPLICATED  + FCVAR_ARCHIVE , "" )
CreateConVar("sv_mario_coins_npc", "1", FCVAR_REPLICATED  + FCVAR_ARCHIVE , "" )
CreateConVar("sv_mario_coins_healthmul", "1", FCVAR_REPLICATED  + FCVAR_ARCHIVE , "" )
CreateConVar("sv_mario_coins_playercountmul", "1", FCVAR_REPLICATED  + FCVAR_ARCHIVE , "" )

local DeleteTime = 120

function NPCCoinDeath( victim, inflictor, attacker )

	if GetConVarNumber("sv_mario_coins_npc") == 0 then return end
	
	if victim:GetMaxHealth() > 300 then
		local coin = ents.Create("ent_mario_coin_blue")
			coin:SetPos(victim:EyePos())
			coin:Spawn()
			coin:Activate()
			coin:GetPhysicsObject():ApplyForceCenter( Vector(math.Rand(-10,10),math.Rand(-10,10),300 + math.Rand(-50,50) ) )
			SafeRemoveEntityDelayed(coin,DeleteTime)
	elseif victim:GetMaxHealth() > 100 then
		for i=1, 3 do
			local coin =  ents.Create("ent_mario_coin_yellow")
				coin:SetPos(victim:EyePos())
				coin:Spawn()
				coin:Activate()
				coin:GetPhysicsObject():ApplyForceCenter( Vector(math.Rand(-10,10),math.Rand(-10,10),300 + math.Rand(-50,50) ) )
				SafeRemoveEntityDelayed(coin,DeleteTime)
		end
	else
		local coin =  ents.Create("ent_mario_coin_yellow")
			coin:SetPos(victim:EyePos())
			coin:Spawn()
			coin:Activate()
			coin:GetPhysicsObject():ApplyForceCenter( Vector(math.Rand(-10,10),math.Rand(-10,10),300 + math.Rand(-50,50) ) )
			SafeRemoveEntityDelayed(coin,DeleteTime)
	end

end

hook.Add("OnNPCKilled","NPC Coin Death",NPCCoinDeath)


function PlayerCoinDeath( victim, inflictor, attacker )

	if GetConVarNumber("sv_mario_coins_player") == 0 then return end

	for i=1, math.Clamp(GetConVarNumber("sv_mario_coins_playercountmul"),1,10) do
		local coin = ents.Create("ent_mario_coin_yellow")
		coin:SetPos(victim:EyePos())
		coin:Spawn()
		coin:Activate()
		coin:GetPhysicsObject():ApplyForceCenter( Vector(math.Rand(-10,10),math.Rand(-10,10),300 + math.Rand(-50,50) ) )
		SafeRemoveEntityDelayed(coin,DeleteTime)
	end

	
end

hook.Add("PlayerDeath","Player Coin Death",PlayerCoinDeath)