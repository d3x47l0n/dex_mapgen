local overworld = dex_mapgen.realm:new("overworld",-100,100)

overworld:register_noise("terrain_2d",
  {
    ["type"] = "2d",
    np_vals = {
        offset = 0,
        scale = 1,
        spread = {x=384, y=256, z=384},
        seed = 5900033,
        octaves = 5,
        persist = 0.63,
        lacunarity = 2.0,
        flags = ""
    }
  })

function overworld:logic(n,x,y,z,seed,c)
  local content = minetest.CONTENT_AIR
  if y < 50 then content = c.stone end
  return content
end

return overworld