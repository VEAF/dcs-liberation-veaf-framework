env.info( '*** VEAF-Mission-Creation-Tools SCRIPTS DYNAMIC INCLUDE START *** ' )

local base = _G

__Veaf = {}

__Veaf.Include = function( IncludeFile )
	if not __Veaf.Includes[ IncludeFile ] then
		__Veaf.Includes[IncludeFile] = IncludeFile
		local f = assert( base.loadfile( IncludeFile ) )
		if f == nil then
			error ("VEAF-Mission-Creation-Tools: Could not load Veaf script file " .. IncludeFile )
		else
			env.info( "VEAF-Mission-Creation-Tools: " .. IncludeFile .. " dynamically loaded." )
			return f()
		end
	end
end

__Veaf.Includes = {}

if not VEAF_DYNAMIC_PATH then
  VEAF_DYNAMIC_PATH = ""
end

-- load the community scripts
--__Veaf.Include( VEAF_DYNAMIC_PATH .. '/src/scripts/community/mist.lua' )
--__Veaf.Include( VEAF_DYNAMIC_PATH .. '/src/scripts/community/Moose.lua' )
--__Veaf.Include( VEAF_DYNAMIC_PATH .. '/src/scripts/community/WeatherMark.lua' )

-- load the VEAF scripts
__Veaf.Include( VEAF_DYNAMIC_PATH .. '/src/scripts/veaf/veaf.lua' )
__Veaf.Include( VEAF_DYNAMIC_PATH .. '/src/scripts/veaf/veafAssets.lua' )
__Veaf.Include( VEAF_DYNAMIC_PATH .. '/src/scripts/veaf/veafCarrierOperations.lua' )
__Veaf.Include( VEAF_DYNAMIC_PATH .. '/src/scripts/veaf/veafCarrierOperations2.lua' )
__Veaf.Include( VEAF_DYNAMIC_PATH .. '/src/scripts/veaf/veafCasMission.lua' )
__Veaf.Include( VEAF_DYNAMIC_PATH .. '/src/scripts/veaf/veafCombatMission.lua' )
__Veaf.Include( VEAF_DYNAMIC_PATH .. '/src/scripts/veaf/veafCombatZone.lua' )
__Veaf.Include( VEAF_DYNAMIC_PATH .. '/src/scripts/veaf/veafGrass.lua' )
__Veaf.Include( VEAF_DYNAMIC_PATH .. '/src/scripts/veaf/veafInterpreter.lua' )
__Veaf.Include( VEAF_DYNAMIC_PATH .. '/src/scripts/veaf/veafMarkers.lua' )
__Veaf.Include( VEAF_DYNAMIC_PATH .. '/src/scripts/veaf/veafMove.lua' )
__Veaf.Include( VEAF_DYNAMIC_PATH .. '/src/scripts/veaf/veafNamedPoints.lua' )
__Veaf.Include( VEAF_DYNAMIC_PATH .. '/src/scripts/veaf/veafRadio.lua' )
__Veaf.Include( VEAF_DYNAMIC_PATH .. '/src/scripts/veaf/veafSecurity.lua' )
__Veaf.Include( VEAF_DYNAMIC_PATH .. '/src/scripts/veaf/veafShortcuts.lua' )
__Veaf.Include( VEAF_DYNAMIC_PATH .. '/src/scripts/veaf/veafSpawn.lua' )
__Veaf.Include( VEAF_DYNAMIC_PATH .. '/src/scripts/veaf/veafTransportMission.lua' )
__Veaf.Include( VEAF_DYNAMIC_PATH .. '/src/scripts/veaf/dcsUnits.lua' )
__Veaf.Include( VEAF_DYNAMIC_PATH .. '/src/scripts/veaf/veafUnits.lua' )
__Veaf.Include( VEAF_DYNAMIC_PATH .. '/src/scripts/veaf/veafRemote.lua' )

-- set the environment in debug mode
env.info( '*** VEAF-Mission-Creation-Tools set the environment in debug mode *** ' )
veaf.Development = true
veaf.Debug = veaf.Development
veaf.Trace = veaf.Development
veaf.SecurityDisabled = veaf.Development
veafSecurity.authenticated = veaf.Development

-- load Witchcraft
if witchcraft then
	env.info( '*** Start Witchcraft *** ' )
	witchcraft.start(_G)
end

env.info( '*** VEAF-Mission-Creation-Tools SCRIPTS INCLUDE END *** ' )
