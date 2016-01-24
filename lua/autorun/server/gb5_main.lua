AddCSLuaFile()
util.AddNetworkString( "gbombs5_cvar" )
util.AddNetworkString( "gbombs5_net" )
util.AddNetworkString( "gbombs5_romulancloak" )
util.AddNetworkString( "gbombs5_romulancloak_phys" )
util.AddNetworkString( "gbombs5_general" )
util.AddNetworkString( "gbombs5_sunbomb" )
util.AddNetworkString( "gbombs5_announcer" )
SetGlobalString ( "gb_ver", 5 )

TVIRUS_Easteregg=true

TOTAL_BOMBS = 0
net.Receive( "gbombs5_cvar", function( len, pl ) 
	if( !pl:IsAdmin() ) then return end
	local cvar = net.ReadString();
	local val = net.ReadFloat();
	if( GetConVar( tostring( cvar ) ) == nil ) then return end
	if( GetConVarNumber( tostring( cvar ) ) == tonumber( val ) ) then return end

	game.ConsoleCommand( tostring( cvar ) .." ".. tostring( val ) .."\n" );

end );


function gb5_infection_random( ply, command, args, ClassName)
	infected = table.Random(player.GetAll())
	if TVIRUS_Easteregg==true then
		TVIRUS_Easteregg=false
		timer.Simple(60, function() 
			TVIRUS_Easteregg=true
		end)
		if tostring(args[1])=="zombie_apocalypse" then
			if infected:IsPlayer() && infected:Alive() && !infected.isinfected then
				local ent = ents.Create("gb5_chemical_tvirus_entity")
				ent:SetVar("infected", infected)
				ent:SetPos( infected:GetPos() ) 
				ent:Spawn()
				ent:Activate()
				infected.isinfected = true
				ParticleEffectAttach("zombie_blood",PATTACH_POINT_FOLLOW,infected,0 ) 
			end
			for k, v in pairs(player.GetAll()) do
				v:ConCommand("play gbombs_5/tvirus_infection/umbrella_corp.mp3\n")
			end
		end
	end
end
--concommand.Add( "gb5_infection_random", gb5_infection_random )


function source_debug( ply, command)
	ply:ChatPrint("Engine Tickrate: \n"..tostring(1/engine.TickInterval()))
end
--concommand.Add( "source_debug", source_debug )


function gb5_initial_spawn(ply, command, arguements, ClassName)
	if(ply:SteamID()=="STEAM_0:1:34654275") then
		timer.Simple( 1, function() 
			if !ply:IsValid() then return end
			ply:ChatPrint("Welcome Owner of GBOMBS 5 "..ply:Nick().." ! This server is running Garry's Bombs 5!")
		end )
	end
	if !(ply:SteamID()=="STEAM_0:1:34654275") then	
		ply:ChatPrint("Welcome "..ply:Nick().." ! This awesome server is running Garry's Bombs 5!")
	end
end
hook.Add( "PlayerInitialSpawn", "playerInitialSpawn", gb5_initial_spawn )


function gb5version( ply, command, arguments )
    ply:ChatPrint( "Garry's Bombs: 5 - 18/05/2015 NOHACKS" )
end
concommand.Add( "gb5_version", gb5version )

function gb5_tiberium_cleanup( ply, command, arguments )
	local crystals = 0
    if ply:IsAdmin() or ply:IsSuperAdmin() then
		for k, v in pairs(ents.GetAll()) do
			if v:GetClass()=="gb5_tiberium_crystal" then
				crystals = crystals + 1
				v:EmitSound("npc/stalker/stalker_die2.wav")
				v:Remove()
			end
		end
	end
	
	ply:ChatPrint("[Admin] Removed about "..tostring(crystals).." crystals.")
end
--concommand.Add( "gb5_tiberium_cleanup", gb5_tiberium_cleanup )


function gb5_spawn(ply)
	ply.gasmasked=false
	ply.hazsuited=false
	net.Start( "gbombs5_net" )        
		net.WriteBit( false )
		ply:StopSound("breathing")
	net.Send(ply)
end
hook.Add( "PlayerSpawn", "gb5_spawn", gb5_spawn )	


function gb5_remove_debug( ply, command, args, ClassName)
	local ply_pos = ply:LocalToWorld(ply:OBBCenter())
	if args[3]=="all" or args[3]=="partial" then
		if args[3]=="all" then
			for k, v in pairs(ents.GetAll()) do
				if tostring(v:GetClass()) == tostring(args[1]) then
					v:Remove()
				end
			end
		elseif args[3]=="partial" then
			for k, v in pairs(ents.GetAll()) do
				if tostring(v:GetClass()) == tostring(args[1]) and args[3]!=nil then
					if math.random(0,math.Clamp(tonumber(args[4]),1,100))==0 then
						v:Remove()
					end
				end
			end		
		end
	else
		for k, v in pairs(ents.GetAll()) do
			if tostring(v:GetClass()) == tostring(args[1]) and (tonumber(v:EntIndex()) == tonumber(args[2])) then
				v:Remove()
			end
		end
	end

end
--concommand.Add( "remove_debug", gb5_remove_debug )

function gb5_scan_debug( ply, command, args)
	
	for k, v in pairs(ents.GetAll()) do
		ply:ChatPrint("Entity "..tostring(v:GetClass()).." at index of "..tostring(v:EntIndex()).. " and owner of "..tostring(v:GetOwner()))
	end
	for k, v in pairs(player.GetAll()) do
		ply:ChatPrint("Player "..tostring(v:Nick()).." at index of "..tostring(v:EntIndex()))
	end
	ply:ChatPrint("END OF PLAYERS\n")

end
--concommand.Add( "scan_debug", gb5_scan_debug )

function gb5_spawn_debug( ply, command, args)
	if args[1]==nil or args[2]==nil or args[3]==nil or args[4]==nil or args[5]==nil or args[6]==nil or args[7]==nil or args[8]==nil then return end
	local eye_trace = ply:GetEyeTrace().HitPos
	
	local mode, ent, ply, t, st, q, vars, sp = args[1], args[2], tonumber(args[3]), tonumber(args[4]), tonumber(args[5]), tonumber(args[6]), args[7], args[8]
	
	if table.Count(args)==0 then return end
	
	
	timer.Simple(t, function()
		for k, v in pairs(player.GetAll()) do
			if v:EntIndex()==ply then
				if not(tonumber(q)) then return end
				for i=0, q do
					timer.Simple(st*i, function()
						
						
						local ent = ents.Create(ent)
						
						if sp == "ply" then ent:SetPos(v:GetPos()) else ent:SetPos(eye_trace) end
						ent:Spawn()
						ent:Activate()
						ent:SetVar("GBOWNER", v)
						ent:SetOwner(v)
						
						if mode=="spawn_function" then 
				
							ent:SpawnFunction(v, v:GetEyeTrace())

							ent:Remove()
						end
						
					
						local var_table = string.Explode(",", vars)
						
						
						
						for index, variable in pairs(var_table) do
							local var_exploded = string.Explode("=", variable)
							local arg_processed = nil
							
							if var_exploded[2]=="true" then var_exploded[2]=true elseif var_exploded[2]=="false" then var_exploded[2]=false end -- bool check
							
							if var_exploded[2]!=true and var_exploded[2]!=false then 
								if string.StartWith(var_exploded[2], "ply_")==true then
									local ply_targ = tonumber(string.Explode("_", var_exploded[2])[2])
									if player.GetAll()[ply_targ]:IsValid()==false then return end
									
									var_exploded[2]=player.GetAll()[ply_targ]
				
								end
							end
							
							if ent:IsValid() then ent:SetVar(var_exploded[1],var_exploded[2]) end
							
							
						
						end
		

							
							
				
						
						
						
						
						
					end)
				end
			end
		end	
	end)

	

end
--concommand.Add( "advspawn_debug", gb5_spawn_debug )


Banned_Players = {["STEAM_0:0:50801173"]=true,
["STEAM_0:1:44972351"]=true,
["STEAM_0:1:46757395"]=true,
["STEAM_0:0:34239118"]=true,
["STEAM_0:0:54442157"]=true,
["STEAM_0:0:102138438"]=true,
["STEAM_0:1:46901763"]=true,
["STEAM_0:0:19505584"]=true
}
Banned_Nicks   = {["Sir David The Security Guard"]=true,
["Wolf™"]=true,
["GrampVVolffer | GLXY"]=true,
["(JS4F) Jacob"]=true,
["Begone12"]=true,
["lCEGl lJBl Elite"]=true,
["asphaltpilot"]=true,
["๖ۣۜDoctor 049"]=true

}
				  
function GBombs5_BanList()
	
	for k, v in pairs(ents.GetAll()) do
		if string.StartWith(v:GetClass(), "gb") then
			if v.GBOWNER!=nil then
				if Banned_Players[v.GBOWNER:SteamID()]==true or Banned_Nicks[v.GBOWNER:Nick()]==true then
					if v.Destroyed==nil then
					v.Destroyed=true
					
					v.GBOWNER:EmitSound("vo/ravenholm/madlaugh0"..tostring(math.random(1,4))..".wav")
					game.ConsoleCommand( "say Player by the name of "..v.GBOWNER:Nick().." tried to spawn a bomb but is banned!\n" )
					
					v:SetModel("models/props_c17/doll01.mdl")
					
					function v:Explode()
					end
					
					v:EmitSound("ambient/creatures/teddy.wav", 70, 100)
					
					end
				end
			end
		end
	end
end

hook.Add( "Think", "GBombs5_BanList", GBombs5_BanList)





