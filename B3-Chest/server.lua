--  في حين مواجهة اي مشاكل بالسكربت يرجى فتح تذكرة برمجية  https://discord.gg/2mNts9zxdn

local Tunnel = module("vrp", "lib/Tunnel")
local Proxy = module("vrp", "lib/Proxy")

vRP = Proxy.getInterface("vRP")
vRPclient = Tunnel.getInterface("vRP","vRP_chests")

-- اكثر من طريقة لاضافة خزنة 
-- {"البرمشن", x,y,z, "اسم اختياري تقدر ما تحط عادي"},  -- هذي الخيار الاول عن طريق البرمشن
-- {"الايدي", x,y,z, "اسم اختياري تقدر ما تحط عادي"},  -- هذي الطريقة الثانية عن طريق ايدي الاعب
-- {"none", x,y,z, "اسم اختياري تقدر ما تحط عادي"},  -- ويصير الكل لهم الصلاحية للخزنة هذي none هذي الطريقة الثالثة و هي انه خزنة عامة خل بدل البرمشن

local chests = {}
chests = {
	{"police.chest", 1851.3234863281,3690.7126464844,34.267040252686, "Police Chest"},
	{"1", -2361.0776367188,3243.5947265625,92.903678894043, "Owner Chest"},
	{"none", 1438.2683105469,1146.2396240234,114.32404327393}
}


local function create_pleschest(owner_access, x, y, z, player, name)
	local namex = name or "chest"
	
	local chest_enter = function(player, area)
		local user_id = vRP.getUserId({player})
		if user_id ~= nil then
			if owner_access == "none" or user_id == tonumber(owner_access) or vRP.hasGroup({user_id, owner_access}) or vRP.hasPermission({user_id, owner_access}) then
				vRP.openChest({player, "static:"..owner_access..":"..namex, 200, nil, nil, nil})
			end
		end
	end

	local chest_leave = function(player,area)
		vRP.closeMenu({player})
	end
	
	local nid = "vRP:static-"..namex..":"..owner_access
	vRPclient.setNamedMarker(player,{nid,x,y,z-1,0.7,0.7,0.5,0,148,255,125,150})
	vRP.setArea({player,nid,x,y,z,1,1.5,chest_enter,chest_leave})
end

AddEventHandler("vRP:playerSpawn",function(user_id,source,first_spawn)
  if first_spawn then
	for k, v in pairs(chests) do
		create_pleschest(v[1], v[2], v[3], v[4], source, v[5])
		--TriggerClientEvent('chatMessage', -1, "Chest created: "..v[1]..", "..v[2]..", "..v[3]..", "..v[4]..", "..v[5]..".") -- تفعيل الشات الافضل خله كذا لا تفعله
	end
  end
end)
-- Updates
        print("^4"..GetCurrentResourceName() .."^7 is on the ^2newest ^7version!^7")