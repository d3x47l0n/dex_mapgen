return {
  
  name = "overworld",
  
  noises = {
    
    ["overworld_terrain_2d"] = {
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
      },
      ymin = 1680,
      ymax = 6680
      }
    
    },
  
  logic = function(noise_vals,x,y,z,seed,c)
      local content = minetest.CONTENT_AIR
      
      --absolutely ugly, temporary
      if y < 30 then
        content = c.water
      end
      
        if y == (noise_vals.overworld_terrain_2d * 50) then
          content = c.grass
        end
        if y < (noise_vals.overworld_terrain_2d * 50) then
          content = c.dirt
        end
        if y < (noise_vals.overworld_terrain_2d * 45) then
          content = c.stone
        end
      
      return content
    end
  
  }