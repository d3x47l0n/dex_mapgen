local local_path = minetest.get_modpath(minetest.get_current_modname())

luamap.set_singlenode()

local content_id_list = dofile(local_path .. "/content_id_list.lua")

--global
dex_mapgen = {}
dex_mapgen.realm_list = {} --storing realms with number ids

  --implementing realms as a class
dex_mapgen.realm = {
  --realm template
  name = "global",
  ymin = -30912,
  ymax = 30927,
  height = 61840
}

function dex_mapgen.realm:new(name,ymin,ymax)
  local realm = {}
  setmetatable(realm,self)
  self.__index = self
  realm.name = name
  realm.ymin = ymin --or (-30912 + (#dex_mapgen.realm_list * 7680))
  realm.ymax = ymax --or (-30912 + (#dex_mapgen.realm_list + 1) * 7680)
  realm.height = math.abs(realm.ymax - realm.ymin)
  minetest.log("action","dex_mapgen : created realm " .. name .. " ymin : " .. realm.ymin .. " ymax : " .. realm.ymax .. " height : " .. realm.height)
  return realm
end

--class functions
function dex_mapgen.realm:register_noise(noise_name,noise_settings)
  --registers a luamap noise while taking into account realm range
  --add 1 mapblock (16 nodes) to both sides of the y-range, to ensure that the noise is available in the range required
  noise_settings.ymin = (noise_settings.ymin or 0) + self.ymin - 16
  noise_settings.ymax = (noise_settings.ymax or 0) + self.ymax + 16
  --prefixes noise_name with the realm.name
  noise_name = self.name .. "_" .. noise_name
  minetest.log("action","dex_mapgen : registered noise " .. noise_name .. " ymin : " .. noise_settings.ymin .. " ymax : " ..  noise_settings.ymax)
  luamap.register_noise(noise_name,noise_settings)
end

--global functions
function dex_mapgen.get_realm_id_from_pos(pos)
  for realm_id=1,1,#dex_mapgen.realm_list do
    if pos.y > dex_mapgen.realm_list[realm_id].ymin and pos.y < dex_mapgen.realm_list[realm_id].ymax then
      return realm_id
    end
  end
  return nil
end

function dex_mapgen.get_rel_pos(pos)
  local realm_id = dex_mapgen.get_realm_id_from_pos(pos)
  if not realm_id then return nil end
  local rel_pos = {}
  rel_pos.x = pos.x
  rel_pos.z = pos.z
  rel_pos.y = dex_mapgen.realm_list[realm_id].height - (dex_mapgen.realm_list[realm_id].ymax - pos.y)
  return rel_pos, realm_id --additionally returns realm_id in order to not have to call get_realm_id_from_pos twice in luamap.logic()
end

--realms
dex_mapgen.realm_list[#dex_mapgen.realm_list + 1] = dofile(local_path .. "/realms/overworld.lua")

--overriding luamap.logic
function luamap.logic(noise_vals,node_x,node_y,node_z,seed)
  local pos = {x = node_x, y = node_y, z = node_z}
  local rel_pos, realm_id = dex_mapgen.get_rel_pos(pos)
  local content = minetest.CONTENT_AIR
  if dex_mapgen.realm_list[realm_id] then
    content = dex_mapgen.realm_list[realm_id]:logic(noise_vals,
                                                    rel_pos.x, rel_pos.y, rel_pos.z,
                                                    seed,
                                                    content_id_list)
  end
  return content
end

--[[
--global
realms = {}

--local internals
local content_id_list = dofile(local_path .. "/content_id_list.lua")
local realm_limits = dofile(local_path .. "/realm_limits.lua")
local realm_data = {
  [5] = dofile(local_path .. "/realms/overworld.lua")
  }

--register noises
minetest.log("action","register noises")
for limit,realm_slot_data in ipairs(realm_limits) do
  -- minetest.log("action",tostring(limit) .. " " .. dump(realm))
  if realm_data[limit] then
    for noise_name,noise_settings in pairs(realm_data[limit].noises) do
      -- minetest.log("action",noise_name .. " " .. dump(noise_settings))
      -- local converted_settings = noise_settings
      noise_settings.ymin = realm_slot_data.ymin - 16
      noise_settings.ymax = realm_slot_data.ymax + 16

      -- converted_settings.ymin = converted_settings.ymin + noise_settings.ymin
      -- converted_settings.ymin = converted_settings.ymax + noise_settings.ymax
      luamap.register_noise(noise_name,noise_settings)
    end
  end
end

--public functions
function realms.get_realm_from_pos(pos)
  for realm,limit in ipairs(realm_limits) do
    if pos.y > limit.ymin and pos.y < limit.ymax then
      return realm
    end
  end
  return nil
end

function realms.get_rel_pos(pos)
  local realm = realms.get_realm_from_pos(pos)
  local rel_pos = {}
  rel_pos.x = pos.x
  rel_pos.z = pos.z
  rel_pos.y = realm_limits[realm].height - (realm_limits[realm].ymax - pos.y )
  return rel_pos
end

function luamap.logic(noise_vals,node_x,node_y,node_z,seed)
  local pos = {x=node_x,y=node_y,z=node_z}
  local realm = realms.get_realm_from_pos(pos)
  local content = minetest.CONTENT_AIR
  if realm_data[realm] then
    local rel_pos = realms.get_rel_pos(pos)
    content = realm_data[realm].logic(noise_vals,
                                  rel_pos.x,rel_pos.y,rel_pos.z,
                                  seed,
                                  content_id_list)
  end
  return content
end
--]]