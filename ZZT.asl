state("pcsx2", "null") {}

// Pretty sure there's a cleaner way to prevent the timer from incrementing, but this is a simple enough solution for now
isLoading
{
    return true;
}

gameTime
{
    return TimeSpan.FromSeconds(memory.ReadValue<int>((IntPtr)0x204144B4));

}