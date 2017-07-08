// I have no idea how to access PCSX2's memory values through state :(
// Commence hacky solutions!
state("pcsx2", "null") {}

startup
{
	// Settings
    settings.Add("splits", false, "All Splits");
    settings.Add("bridge1", false, "Bridge Pt. 1", "splits");
}

init
{
	// Can't seem to use memory.ReadValue with these variables, so *magic numbers* for now.
	// if you see these numbers, just pretend with your eyeballs that these variables take their place
	//vars.GAMETIME_ADDR = (IntPtr)0x204144B4;
	//vars.AREA_ADDR = (IntPtr)0x2036BBB0;
	//vars.SUBAREA_ADDR = (IntPtr)0x2036BBB8;

	// Boolean values to check if the split has already been hit
	vars.splits = new HashSet<string>();

	vars.area = new Dictionary<string, int>();
	vars.area.Add("current", 0);
	vars.area.Add("old", 0);

	vars.subArea = new Dictionary<string, int>();
	vars.subArea.Add("current", 0);
	vars.subArea.Add("old", 0);
}

update
{
	// store LiveSplit timer phase
	current.timerPhase = timer.CurrentPhase;

	// Update our level variables for splitting
	vars.area["old"] = vars.area["current"];
	vars.subArea["old"] = vars.subArea["current"];
	vars.area["current"] = memory.ReadValue<int>((IntPtr)0x2036BBB0);
	vars.subArea["current"] = memory.ReadValue<int>((IntPtr)0x2036BBB8);

	// Whenever timer is started, clear all the splits;
	if ((old.timerPhase != current.timerPhase && old.timerPhase != TimerPhase.Paused) && current.timerPhase == TimerPhase.Running) 
	{
		vars.splits.Clear();
	}
}

// Pretty sure there's a cleaner way to prevent the timer from incrementing, but this is a simple enough solution for now
isLoading
{
    return true;
}

gameTime
{
    return TimeSpan.FromSeconds(memory.ReadValue<int>((IntPtr)0x204144B4));
}

split
{
	// Bridge Pt. 1
	if (settings["bridge1"] && !(vars.splits.Contains("bridge1")) && vars.area["current"] == 1 && vars.subArea["current"] == 11 && vars.subArea["old"] == 1)
	{
		vars.splits.Add("bridge1");
		return true;
	}
}