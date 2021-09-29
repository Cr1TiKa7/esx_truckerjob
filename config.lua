Config = {}
Config.Locale                     = 'de'
Config.Blip = {
  color   = 40,
  alpha   = 255,
  friend  = 1,
  short   = 1,
  scale   = 1.0,
  display = 2,
  sprite  = 635,
  name    = 'Trucker Job'
}

-- Trucks: packer, hauler, hauler2, phantom, phantom3
-- Trailer: belatrailer, graintrailer, tr3, tr4, tvtrailer, 
-- tanker, tanker2, trailerlarge, trailerlogs, trailers, trailers2, trailers3, trailers4
Config.TruckerJob = {
  DutyPos = { x=814.5, y=-2982.4, z=6.0 },  
  FinalPos = { x=825.7, y=-2932.6, z=5.9 },  
  SpawnPos = { x=823.8, y=-2951.6, z=6.0 },
  TruckSpawn = {x=830.5, y=-2947.2, h=180.0, z=5.9 },
  {
    Jobs = {
      {
        Name = 'Test Job',
        Vehicle = 'packer',
        Trailer = 'tanker',
        Price = 15000,
        TrailerSpawn = { x=945.2, y=-3129.1, h=0.0, z=5.9 },
        Destination = { x=894.4, y=-3112.4, z=5.9 } 
      },
      {
        Name = 'Test Job 2',
        Vehicle = 'hauler',
        Trailer = 'tr3',
        Price = 10000,
        TrailerSpawn = { x=945.2, y=-3129.1, h=0.0, z=5.9 },
        Destination = { x=894.4, y=-3112.4, z=5.9 } 
      }
    }
  }
}

Config.JobUniforms = {
	male = {
		['sex'] = 0,
    ['tshirt_1'] = 15,  ['tshirt_2'] = 0,
    ['torso_1'] = 41,   ['torso_2'] = 0,
    ['decals_1'] = 0,   ['decals_2'] = 0,
    ['arms'] = 1,
    ['pants_1'] = 8,   ['pants_2'] = 0,
    ['shoes_1'] = 15,   ['shoes_2'] = 0,
    ['chain_1'] = 0,    ['chain_2'] = 0,
    ['bproof_1'] = 0,     ['bproof_2'] = 0	
	},
	female = {
		['sex'] = 1,		
    ['tshirt_1'] = 86,  ['tshirt_2'] = 0,
    ['torso_1'] = 3,   ['torso_2'] = 0,
    ['decals_1'] = 0,   ['decals_2'] = 0,
    ['arms'] = 1,
    ['pants_1'] = 1,   ['pants_2'] = 0,
    ['shoes_1'] = 28,   ['shoes_2'] = 0,
    ['chain_1'] = 0,    ['chain_2'] = 0,
    ['bproof_1'] = 0,     ['bproof_2'] = 0	
	}
}
