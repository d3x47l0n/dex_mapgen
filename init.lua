local local_path = minetest.get_modpath(minetest.get_current_modname())

luamap.set_singlenode()

--local internals
local content_id_list = dofile(local_path .. "/content_id_list.lua")
local realm_limits = dofile(local_path .. "/realm_limits.lua")
local realm_data = {
  [5] = dofile(local_path .. "/realms/overworld.lua")
  }

--global
realms = {}

--register noises
minetest.log("action","register noises")
for limit,realm in ipairs(realm_data) do
  minetest.log("action",tostring(limit) .. " " .. dump(realm))
  for noise_name,noise_settings in pairs(realm.noises) do
    minetest.log("action",noise_name .. " " .. dump(noise_settings))
    local converted_settings = noise_settings
    converted_settings.ymin = converted_settings.ymin + noise_settings.ymin
    converted_settings.ymin = converted_settings.ymax + noise_settings.ymax
    luamap.register_noise(noise_name,noise_settings)
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