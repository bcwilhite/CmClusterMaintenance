function Start-StopWatch
{
    [CmdletBinding()]
    param()
    [System.Diagnostics.Stopwatch]::StartNew()
}
