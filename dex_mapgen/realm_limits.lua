--[[ 

  total limit : −30912 to 30927, that is 773 mapchunks
  772 for even number ( remainder 1 )
  divided by 4 -> 193 -> 192 for even number ( 4 remainders + 1 = 5 )
  divided by 2 -> 96 mapchunks per realm + a realm 5 mapchunks tall
  96 * 80 = 7680 nodes per realm ( 8 realms ) ( 400 nodes for the extra realm )

--]]

return {
  {
    ymin = -30912,
    ymax = -23232,
    height = 7680
  }, -- slot 1
  
  {
    ymin = -23232,
    ymax = -15552,
    height = 7680
  }, -- slot 2
  
  {
    ymin = -15552,
    ymax = -7872,
    height = 7680
  }, -- slot 3
  
  {
    ymin = -7872,
    ymax = -192,
    height = 7680
  }, -- slot 4
  
  {
    ymin = -192,
    ymax = 7488,
    height = 7680
  }, -- slot 5
  
  {
    ymin = 7488,
    ymax = 15168,
    height = 7680
  }, -- slot 6
  
  {
    ymin = 15168,
    ymax = 22848,
    height = 7680
  }, -- slot 7
  
  {
    ymin = 22848,
    ymax = 30528,
    height = 7680
  }, -- slot 8
  
  {
    ymin = 30528,
    ymax = 30927,
    height = 399
  }  -- slot 9 extra
  
}