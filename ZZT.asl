// State variables are not applicate for emulators
// For read variables, see the "update"/"init" block
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
  settings.Add("ending56", false, "(Not functioning) Ending 5/6", "splits");
  settings.Add("windrunnerPark", true, "Windrunner Park", "splits");
  settings.Add("mayStadium", true, "May Stadium", "splits");
  settings.Add("heliChase", true, "Helicopter Chase", "splits");
  settings.Add("lincolnPlaza1", true, "Lincoln Plaza Pt. 1", "splits");
  settings.Add("lincolnPlaza2", true, "Lincoln Plaza Pt. 2", "splits");
  settings.Add("lincolnPlaza3", true, "Lincoln Plaza Pt. 3", "splits");
  settings.Add("lucasCanal", true, "Lucas Canal", "splits");
  settings.Add("stiverCC", true, "Stiver Control Center", "splits");
  settings.Add("gregSniped", true, "Greg vs. Vince: The Final Duel", "splits");
  settings.Add("ending12", true, "Ending 1/2", "splits");
}

init
{
  // Boolean values to check if the split has already been hit
  vars.Splits = new HashSet<string>();

  // Dictionary used to split when entering a new area
  // Key: Represents level IDs (area, subArea, checkPoint)
  // Value: Key which represents a LiveSplit settings key
  vars.LevelIds = new Dictionary<Tuple<int, int, int>, string>
  {
    {Tuple.Create(1, 11, 0),  "bridge1"},
    {Tuple.Create(1, 2, 0),   "restaurant"},
    {Tuple.Create(1, 3, 0),   "karen"},
    {Tuple.Create(1, 6, 1),   "bridge2"},
    {Tuple.Create(1, 8, 1),   "overpass"},
    {Tuple.Create(1, 5, 4),   "pjPark1"},
    {Tuple.Create(1, 7, 1),   "pjPark2"},
    {Tuple.Create(1, 10, 1),  "pjPark3"},
    {Tuple.Create(2, 0, 1),   "sidewaysBuilding"},
    {Tuple.Create(2, 2, 1),   "financialDistrict"},
    {Tuple.Create(2, 3, 1),   "constructionSite"},
    {Tuple.Create(2, 4, 4),   "destroyedBuilding1"},
    {Tuple.Create(2, 7, 1),   "destroyedBuilding2"},
    {Tuple.Create(3, 0, 1),   "dmitriCanal"}, // Karen
    {Tuple.Create(3, 1, 1),   "parkAve"}, // Karen
    {Tuple.Create(3, 0, 12),  "karenHouse"}, // Karen
    {Tuple.Create(3, 3, 1),   "subway"}, // Karen
    {Tuple.Create(3, 4, 1),   "reservoir"}, // Karen
    {Tuple.Create(4, 0, 0),   "carDealer"}, // Kelly
    {Tuple.Create(4, 1, 0),   "amusementPark"}, // Kelly
    {Tuple.Create(4, 2, 0),   "swan"}, // Kelly
    {Tuple.Create(4, 3, 0),   "kellyHouse1"}, // Kelly
    {Tuple.Create(4, 4, 0),   "kellyHouse2"}, // Kelly
    {Tuple.Create(5, 0, 3),   "subwayPlatformer"}, // Karen
    {Tuple.Create(5, 10, 4),  "hospital"}, // Kelly
    {Tuple.Create(5, 3, 1),   "keithTheThief"}, 
    {Tuple.Create(5, 5, 1),   "townCrier"},
    {Tuple.Create(5, 7, 1),   "windrunnerPark"}, // Karen
    {Tuple.Create(5, 7, 2),   "windrunnerPark"}, // Kelly
    {Tuple.Create(6, 0, 0),   "mayStadium"}, // Karen
    {Tuple.Create(6, 5, 0),   "mayStadium"}, // Kelly
    {Tuple.Create(6, 1, 4),   "heliChase"}, // Karen
    {Tuple.Create(6, 6, 4),   "heliChase"}, // Kelly
    {Tuple.Create(6, 2, 0),   "lincolnPlaza1"}, // Karen
    {Tuple.Create(6, 7, 0),   "lincolnPlaza1"}, // Kelly
    {Tuple.Create(6, 3, 0),   "lincolnPlaza2"}, // Karen
    {Tuple.Create(6, 8, 0),   "lincolnPlaza2"}, // Kelly
    {Tuple.Create(7, 0, 0),   "lincolnPlaza3"}, // Karen
    {Tuple.Create(7, 9, 0),   "lincolnPlaza3"}, // Kelly
    {Tuple.Create(7, 1, 0),   "lucasCanal"}, // Karen
    {Tuple.Create(7, 10, 0),  "lucasCanal"}, // Kelly
    {Tuple.Create(7, 3, 0),   "stiverCC"}, // Karen
    {Tuple.Create(7, 12, 0),  "stiverCC"}, // Kelly
    {Tuple.Create(7, 6, 11),  "gregSniped"}, // Karen
    {Tuple.Create(7, 15, 11), "gregSniped"}, // Kelly
  };

  // Keeps track of level states
  vars.LevelId = new ExpandoObject();

  // In case of a PCSX2 update changing this, or using this script on another emulator
  const int Pcsx2Offset = 0x20000000;

  // Update our level variables for splitting
  vars.Area = new MemoryWatcher<int>((IntPtr)0x36BBB0 + Pcsx2Offset);
  vars.SubArea = new MemoryWatcher<int>((IntPtr)0x36BBB8 + Pcsx2Offset);
  vars.Checkpoint = new MemoryWatcher<int>((IntPtr)0x36BBC0 + Pcsx2Offset);

  // Variables for miscellaneous splits
  vars.Crowbar = new MemoryWatcher<bool>((IntPtr)0x3535B8 + Pcsx2Offset);
  vars.Ending7Flag = new MemoryWatcher<int>((IntPtr)0x36D7EB + Pcsx2Offset);
  // vars.ending56Flag = new MemoryWatcher<bool>((IntPtr)0x3C5FA0 + Pcsx2Offset);
  vars.Fade = new MemoryWatcher<float>((IntPtr)0x3D918C + Pcsx2Offset);

  // For game time
  vars.TicksPerSecond = 60; // Note: Disaster Report uses Vsync cycles (60.00, NOT 59.97) for its timer. DR waits 2 vsync cycles for each frame, and DR uses that var to determine how many ticks to increment by each frame.
  vars.GameTimeSeconds = new MemoryWatcher<int>((IntPtr)0x4144B4 + Pcsx2Offset);
  vars.GameTimeTicks = new MemoryWatcher<float>((IntPtr)0x380748 + Pcsx2Offset);

  // For start
  vars.GameStarted = new MemoryWatcher<int>((IntPtr)0xBAA7F0 + Pcsx2Offset);

  // For reset
  vars.InGame = new MemoryWatcher<bool>((IntPtr)0x353838 + Pcsx2Offset);

  vars.Watchers = new MemoryWatcherList
  {
    vars.Area,
    vars.SubArea,
    vars.Checkpoint,
    vars.Crowbar,
    vars.Ending7Flag,
    vars.Fade,
    vars.GameTimeSeconds,
    vars.GameTimeTicks,
    vars.GameStarted,
    vars.InGame,
  };

}

update
{
  // In case of a PCSX2 update changing this, or using this script on another emulator
  const int Pcsx2Offset = 0x20000000;

  // Update memory watchers
  vars.Watchers.UpdateAll(game);

  // Manually update level ids
  vars.LevelId.Current = Tuple.Create(vars.Area.Current, vars.SubArea.Current, vars.Checkpoint.Current);
  vars.LevelId.Old = Tuple.Create(vars.Area.Old, vars.SubArea.Old, vars.Checkpoint.Old);

  // Game time
  vars.GameTime = vars.GameTimeSeconds.Current + (vars.GameTimeTicks.Current / vars.TicksPerSecond);

  // Location tracking, just in case
  IntPtr keithAddr = memory.ReadValue<IntPtr>((IntPtr)0x3810D8 + Pcsx2Offset) + Pcsx2Offset;
  vars.keithPosX = memory.ReadValue<float>(keithAddr + 0xE0);
  vars.keithPosY = memory.ReadValue<float>(keithAddr + 0xE4);
  vars.keithPosZ = memory.ReadValue<float>(keithAddr + 0xE8);

  // Whenever timer is paused, clear all the splits;
  if (timer.CurrentPhase == TimerPhase.NotRunning) { vars.Splits.Clear(); }
}

reset { return !vars.InGame.Current && vars.InGame.Old; }

// Prevents the in-game timer from increasing on its own (it's synced to the game's time value)
isLoading { return true; }

// Minor bug: "ticks" are retained from the previous game before the player gains control in a new game
// we could just write to this address but then I'd be doing IREM's job for them
gameTime { return TimeSpan.FromSeconds(vars.GameTime); }
start { return vars.GameStarted.Current == 1508400; }

split
{
  // The game retains area values in the main menu, so check this
  if (vars.InGame.Current == 0) { return false; }

  // Splits for level/checkpoint transitions
  if (!vars.LevelId.Current.Equals(vars.LevelId.Old))
  {
    if (!vars.LevelIds.ContainsKey(vars.LevelId.Current)) { return false; }

    // (0, 0, 0) is the default value when LS is initialized so return to prevent a false split
    if (vars.LevelId.Old.Equals(Tuple.Create(0, 0, 0))) { return false; } 

    string key = vars.LevelIds[vars.LevelId.Current];
    if (!vars.Splits.Contains(key))
    {
      vars.Splits.Add(key);
      return settings[key];
    }
  }

  // Ending 1 & 2
  if (settings["ending12"] && !(vars.Splits.Contains("ending12")) && 
    vars.Area.Current == 7 && (vars.SubArea.Current == 7 || vars.SubArea.Current == 16) && 
    vars.keithPosY < -95 && vars.Fade.Current == 128)
  {
    vars.Splits.Add("ending12");
    return true;
  }

  // Crowbar
  // Note: This particular address read is a bool indicating if the crowbar has been picked up
  // Tentative
  if (settings["crowbar"] && !(vars.Splits.Contains("crowbar")) && vars.Crowbar.Current)
  {
    vars.Splits.Add("crowbar");
    print("DEBUG: crowbar split");
    return true;
  }

  // (Kelly) Ending 7
  // Tentative
  if (settings["ending7"] && !(vars.Splits.Contains("ending7")) && 
    vars.Ending7Flag.Current == 128 && vars.Ending7Flag.Old == 0)
  {
    vars.Splits.Add("ending7");
    print("DEBUG: ending7 split");
    return true;
  }
}