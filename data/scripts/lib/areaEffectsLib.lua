tileRequirementsConfig = {
    ---------------------------------------------------------
   -- Tile Requeriment example 1
   ---------------------------------------------------------
   [36000] = {
		minLevel = 10, -- level req to enter
		maxLevel = 0, -- set 0 to disable (set level max to enter)
		storageReq = 0, -- set 0 to disable (if player need storage to enter)
		storageName = "", -- if you want show quest need to enter (example: you need >demon quest< to join this area)
		zoneName = "Maze Area", -- name of your zone or use default
		teleport = Position(0, 0, 0), -- if you want teleport player put 0 to disable
		shader = 0
		},
     ---------------------------------------------------------
   -- Example Tiles
   ---------------------------------------------------------
   [36001] = {
       minLevel = 500, -- level req to enter
       maxLevel = 0, -- set 0 to disable (set level max to enter)
       storageReq = 36001, -- set 0 to disable (if player need storage to enter)
       storageName = "Quest Retro", -- if you want show quest need to enter (example: you need >demon quest< to join this area)
       zoneName = "this area", -- name of your zone or use default
       teleport = Position(0, 0, 0) -- if you want teleport player put 0 to disable
       },

    [36002] = {
       minLevel = 50, -- level req to enter
       maxLevel = 0, -- set 0 to disable (set level max to enter)
       storageReq = 0, -- set 0 to disable (if player need storage to enter)
       storageName = "", -- if you want show quest need to enter (example: you need >demon quest< to join this area)
       zoneName = "this area", -- name of your zone or use default
       teleport = Position(0, 0, 0) -- if you want teleport player put 0 to disable
       }
 
 
}