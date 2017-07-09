// I have no idea how to access PCSX2's memory values through state :(
// Commence hacky solutions!
state("pcsx2", "null") {}

startup
{
	// Settings
    settings.Add("splits", true, "All Splits");
    settings.Add("bridge1", true, "Bridge Pt. 1", "splits");
    settings.Add("restaurant", true, "Restaurant", "splits");
    settings.Add("karen", true, "Saved Karen", "splits");
    settings.Add("bridge2", true, "Bridge Pt. 2", "splits");
    settings.Add("overpass", true, "Capital City Highway Overpass", "splits");
    settings.Add("crowbar", true, "Obtained Crowbar", "splits");
    settings.Add("pjPark1", true, "Patrick James Park Pt. 1", "splits");
    settings.Add("pjPark2", true, "Patrick James Park Pt. 2", "splits");
    settings.Add("pjPark3", true, "Patrick James Park Pt. 3", "splits");
    settings.Add("sidewaysBuilding", true, "Fallen-over Building", "splits");
    settings.Add("financialDistrict", true, "Financial District", "splits");
    settings.Add("constructionSite", true, "Construction Site", "splits");
    settings.Add("destroyedBuilding1", true, "Destroyed Building Pt. 1", "splits");
    settings.Add("destroyedBuilding2", true, "Destroyed Building Pt. 2", "splits");
    settings.Add("dmitriCanal", false, "(Karen) Dmitri Canal", "splits");
    settings.Add("parkAve", false, "(Karen) Park Ave & Main", "splits");
    settings.Add("karenHouse", false, "(Karen) Karen's Neighborhood", "splits");
    settings.Add("subway", false, "(Karen) Subway", "splits");
    settings.Add("reservoir", false, "(Karen) Reservoir", "splits");
    settings.Add("subwayPlatformer", false, "(Karen) Subway Gauntlet", "splits");
    settings.Add("carDealer", true, "(Kelly) Car Dealership", "splits");
    settings.Add("amusementPark", true, "(Kelly) Amusement Park", "splits");
    settings.Add("swan", true, "(Kelly) Swan Boat Ride", "splits");
    settings.Add("kellyHouse1", true, "(Kelly) Kelly's Neighborhood Pt. 1", "splits");
    settings.Add("kellyHouse2", true, "(Kelly) Kelly's Neighborhood Pt. 2", "splits");
    settings.Add("ending7", false, "(Kelly) Ending 7", "splits");
    settings.Add("hospital", true, "(Kelly) Saint Maria Hospital", "splits");
    settings.Add("keithTheThief", true, "Entered Christophe Construction", "splits");
    settings.Add("townCrier", true, "Town Crier News Dept.", "splits");
    settings.Add("ending56", false, "Ending 5/6", "splits");
    settings.Add("windrunnerPark", true, "Windrunner Park", "splits");
    settings.Add("mayStadium", true, "May Stadium", "splits");
    settings.Add("heliChase", true, "Helicopter Chase", "splits");
    settings.Add("lincolnPlaza1", true, "Lincoln Plaza Pt. 1", "splits");
    settings.Add("lincolnPlaza2", true, "Lincoln Plaza Pt. 2", "splits");
    settings.Add("lincolnPlaza3", true, "Lincoln Plaza Pt. 3", "splits");
}

init
{
	// Boolean values to check if the split has already been hit
	vars.splits = new HashSet<string>();
}

update
{
	// In case of a PCSX2 update changing this, or using this script on another emulator
	const int PCSX2_OFFSET = 0x20000000;

	// Update our level variables for splitting
	vars.area = memory.ReadValue<int>((IntPtr)0x36BBB0 + PCSX2_OFFSET);
	vars.subArea = memory.ReadValue<int>((IntPtr)0x36BBB8 + PCSX2_OFFSET);
	vars.checkpoint = memory.ReadValue<int>((IntPtr)0x36BBC0 + PCSX2_OFFSET);
	vars.crowbar = memory.ReadValue<bool>((IntPtr)0x3535B8 + PCSX2_OFFSET);
	vars.ending7Flag = memory.ReadValue<bool>((IntPtr)0x36D7EB + PCSX2_OFFSET);
	vars.ending56Flag = memory.ReadValue<bool>((IntPtr)0x3C5FA0 + PCSX2_OFFSET);

	// For game time
	vars.TICKS_PER_SECOND = 60; // Note: Disaster Report uses Vsync cycles (60.00, NOT 59.97) for its timer. DR waits 2 vsync cycles for each frame, and DR uses that var to determine how many ticks to increment by each frame.
	vars.gameTimeSeconds = memory.ReadValue<int>((IntPtr)0x4144B4 + PCSX2_OFFSET);
	vars.gameTimeTicks = memory.ReadValue<float>((IntPtr)0x380748 + PCSX2_OFFSET);

	vars.gameTime = vars.gameTimeSeconds + (vars.gameTimeTicks / vars.TICKS_PER_SECOND);

	// For start
	vars.gameStarted = memory.ReadValue<int>((IntPtr)0xBAA7F0 + PCSX2_OFFSET) == 1508400;

	// Used to check if a reset happens
	current.inGame = memory.ReadValue<int>((IntPtr)0x353838 + PCSX2_OFFSET);

	// Whenever timer is paused, clear all the splits;
	if (timer.CurrentPhase == TimerPhase.NotRunning) 
	{
		vars.splits.Clear();
	}
}

reset
{
	if (current.inGame == 0 && old.inGame == 1) 
	{
		vars.splits.Clear();
		return true;
	}
}

// Pretty sure there's a cleaner way to prevent the timer from incrementing, but this is a simple enough solution for now
isLoading
{
    return true;
}

gameTime
{
	// Minor bug: "ticks" are retained from the previous game before the player gains control in a new game
	// we could just write to this address but then I'd be doing IREM's job for them
    return TimeSpan.FromSeconds(vars.gameTime);
}

start
{
	if (!vars.splits.Contains("start") && vars.gameStarted)
	{
		vars.splits.Add("start");
		return true;
	}
}

split
{

	// The game retains area values in the main menu, so check this
	if (current.inGame == 0) return false;

	// Bridge Pt. 1
	if (settings["bridge1"] && !(vars.splits.Contains("bridge1")) && vars.area == 1 && vars.subArea == 11)
	{
		vars.splits.Add("bridge1");
		return true;
	}

	// Restaurant
	if (settings["restaurant"] && !(vars.splits.Contains("restaurant")) && vars.area == 1 && vars.subArea == 2)
	{
		vars.splits.Add("restaurant");
		return true;
	}

	// Saved Karen
	// Note: Area 1.3 is the cutscene with Karen, Area 1.4 is the playable segment following
	if (settings["karen"] && !(vars.splits.Contains("karen")) && vars.area == 1 && vars.subArea == 3)
	{
		vars.splits.Add("karen");
		return true;
	}

	// Bridge Pt. 2
	if (settings["bridge2"] && !(vars.splits.Contains("bridge2")) && vars.area == 1 && vars.subArea == 6)
	{
		vars.splits.Add("bridge2");
		return true;
	}

	// Overpass
	if (settings["overpass"] && !(vars.splits.Contains("overpass")) && vars.area == 1 && vars.subArea == 8)
	{
		vars.splits.Add("overpass");
		return true;
	}

	// Crowbar
	// Note: This particular address read is a bool indicating if the crowbar has been picked up
	if (settings["crowbar"] && !(vars.splits.Contains("crowbar")) && vars.crowbar)
	{
		vars.splits.Add("crowbar");
		return true;
	}

	// Patrick James Park Pt. 1
	if (settings["pjPark1"] && !(vars.splits.Contains("pjPark1")) && vars.area == 1 && vars.subArea == 5)
	{
		vars.splits.Add("pjPark1");
		return true;
	}

	// Patrick James Park Pt. 2
	if (settings["pjPark2"] && !(vars.splits.Contains("pjPark2")) && vars.area == 1 && vars.subArea == 7)
	{
		vars.splits.Add("pjPark2");
		return true;
	}

	// Patrick James Park Pt. 3
	if (settings["pjPark3"] && !(vars.splits.Contains("pjPark3")) && vars.area == 1 && vars.subArea == 10)
	{
		vars.splits.Add("pjPark3");
		return true;
	}

	// Fallen-Over Building
	if (settings["sidewaysBuilding"] && !(vars.splits.Contains("sidewaysBuilding")) && vars.area == 2 && vars.subArea == 0)
	{
		vars.splits.Add("sidewaysBuilding");
		return true;
	}

	// Financial District
	if (settings["financialDistrict"] && !(vars.splits.Contains("financialDistrict")) && vars.area == 2 && vars.subArea == 2)
	{
		vars.splits.Add("financialDistrict");
		return true;
	}

	// Construction Site
	if (settings["constructionSite"] && !(vars.splits.Contains("constructionSite")) && vars.area == 2 && vars.subArea == 3)
	{
		vars.splits.Add("constructionSite");
		return true;
	}

	// Destroyed Building Pt. 1
	if (settings["destroyedBuilding1"] && !(vars.splits.Contains("destroyedBuilding1")) && vars.area == 2 && vars.subArea == 4)
	{
		vars.splits.Add("destroyedBuilding1");
		return true;
	}

	// Destroyed Building Pt. 2
	if (settings["destroyedBuilding2"] && !(vars.splits.Contains("destroyedBuilding2")) && vars.area == 2 && vars.subArea == 7)
	{
		vars.splits.Add("destroyedBuilding2");
		return true;
	}

	// (Karen) Dmitri Canal
	if (settings["dmitriCanal"] && !(vars.splits.Contains("dmitriCanal")) && vars.area == 3 && vars.subArea == 0)
	{
		vars.splits.Add("dmitriCanal");
		return true;
	}

	// (Karen) Park Ave & Main
	if (settings["parkAve"] && !(vars.splits.Contains("parkAve")) && vars.area == 3 && vars.subArea == 1)
	{
		vars.splits.Add("parkAve");
		return true;
	}

	// (Karen) Karen's Neighborhood
	if (settings["karenHouse"] && !(vars.splits.Contains("karenHouse")) && vars.area == 3 && vars.subArea == 0 && vars.checkpoint == 12)
	{
		vars.splits.Add("karenHouse");
		return true;
	}

	// (Karen) Subway
	if (settings["subway"] && !(vars.splits.Contains("subway")) && vars.area == 3 && vars.subArea == 3)
	{
		vars.splits.Add("subway");
		return true;
	}

	// (Karen) Reservoir
	if (settings["reservoir"] && !(vars.splits.Contains("reservoir")) && vars.area == 3 && vars.subArea == 4)
	{
		vars.splits.Add("reservoir");
		return true;
	}

	// (Karen) Subway Gauntlet
	if (settings["subwayPlatformer"] && !(vars.splits.Contains("subwayPlatformer")) && vars.area == 5 && vars.subArea == 0)
	{
		vars.splits.Add("subwayPlatformer");
		return true;
	}

	// (Kelly) Car Dealership
	if (settings["carDealer"] && !(vars.splits.Contains("carDealer")) && vars.area == 4 && vars.subArea == 0)
	{
		vars.splits.Add("carDealer");
		return true;
	}

	// (Kelly) Amusement Park
	if (settings["amusementPark"] && !(vars.splits.Contains("amusementPark")) && vars.area == 4 && vars.subArea == 1)
	{
		vars.splits.Add("amusementPark");
		return true;
	}

	// (Kelly) Swan Boat Ride
	if (settings["swan"] && !(vars.splits.Contains("swan")) && vars.area == 4 && vars.subArea == 2)
	{
		vars.splits.Add("swan");
		return true;
	}

	// (Kelly) Kelly's Neighborhood Pt. 1
	if (settings["kellyHouse1"] && !(vars.splits.Contains("kellyHouse1")) && vars.area == 4 && vars.subArea == 3 && vars.checkpoint == 4)
	{
		vars.splits.Add("kellyHouse1");
		return true;
	}

	// (Kelly) Kelly's Neighborhood Pt. 2
	if (settings["kellyHouse2"] && !(vars.splits.Contains("kellyHouse2")) && vars.area == 4 && vars.subArea == 4)
	{
		vars.splits.Add("kellyHouse2");
		return true;
	}

	// (Kelly) Ending 7
	if (settings["ending7"] && !(vars.splits.Contains("ending7")) && vars.ending7Flag)
	{
		vars.splits.Add("ending7");
		return true;
	}

	// (Kelly) Saint Katrina Hospital
	if (settings["hospital"] && !(vars.splits.Contains("hospital")) && vars.area == 5 && vars.subArea == 10)
	{
		vars.splits.Add("hospital");
		return true;
	}

	// Entered Christophe Construction
	if (settings["keithTheThief"] && !(vars.splits.Contains("keithTheThief")) && vars.area == 5 && vars.subArea == 3)
	{
		vars.splits.Add("keithTheThief");
		return true;
	}

	// Town Crier News Dept.
	if (settings["townCrier"] && !(vars.splits.Contains("townCrier")) && vars.area == 5 && vars.subArea == 5)
	{
		vars.splits.Add("townCrier");
		return true;
	}

	// Ending 5/6
	if (settings["ending56"] && !(vars.splits.Contains("ending56")) && vars.ending56Flag)
	{
		vars.splits.Add("ending56");
		return true;
	}

	// Windrunner Park
	if (settings["windrunnerPark"] && !(vars.splits.Contains("windrunnerPark")) && vars.area == 5 && vars.subArea == 7)
	{
		vars.splits.Add("windrunnerPark");
		return true;
	}

	// May Stadium
	if (settings["mayStadium"] && !(vars.splits.Contains("mayStadium")) && vars.area == 6 && (vars.subArea == 0 || vars.subArea == 5))
	{
		vars.splits.Add("mayStadium");
		return true;
	}

	// Helicopter Chase
	if (settings["heliChase"] && !(vars.splits.Contains("heliChase")) && vars.area == 6 && (vars.subArea == 1 || vars.subArea == 6))
	{
		vars.splits.Add("heliChase");
		return true;
	}

	// Lincoln Plaza Pt. 1
	if (settings["lincolnPlaza1"] && !(vars.splits.Contains("lincolnPlaza1")) && vars.area == 6 && (vars.subArea == 2 || vars.subArea == 7))
	{
		vars.splits.Add("lincolnPlaza1");
		return true;
	}

	// Lincoln Plaza Pt. 2
	if (settings["lincolnPlaza2"] && !(vars.splits.Contains("lincolnPlaza2")) && vars.area == 6 && (vars.subArea == 3 || vars.subArea == 8))
	{
		vars.splits.Add("lincolnPlaza2");
		return true;
	}

	// Lincoln Plaza Pt. 3
	if (settings["lincolnPlaza3"] && !(vars.splits.Contains("lincolnPlaza3")) && vars.area == 6 && (vars.subArea == 4 || vars.subArea == 9))
	{
		vars.splits.Add("lincolnPlaza3");
		return true;
	}

}