state("pcsx2") {

	uint gameTime : 0x1F1E44B4;
}

// Pretty sure there's a cleaner way to prevent the timer from incrementing, but this is a simple enough solution for now
isLoading
{
    return true;
}

gameTime
{
    return TimeSpan.FromSeconds(current.gameTime);
}