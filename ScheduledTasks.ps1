function Get-ScheduledTasks
 {
    [CmdletBinding()]
    param (
        [Parameter(
			Position = 0,
			ValueFromPipeline = $true,
			ValueFromPipelineByPropertyName = $true
		)]
		[Alias("CN","__SERVER","IPAddress")]
		[string]$computerName

    )

    #The arrays created need to be blank.
    $output = @()
    $out = @()

    #Creates a COM object to get the scheduled tasks
    $sched = New-Object -Com "Schedule.Service"

    #Connects to the specified computer
    $sched.Connect($computerName)

    #Could change which folder which we look at to loop though the tasks.
    $sched.GetFolder("\").GetTasks(0) | ForEach-Object {
        $xml = [xml]$_.xml
        $out += New-Object psobject -Property @{
            "Server" = $c.Name
            "Name" = $_.Name
            "Status" = switch($_.State) {0 {"Unknown"} 1 {"Disabled"} 2 {"Queued"} 3 {"Ready"} 4 {"Running"}}
            "NextRunTime" = $_.NextRunTime
            "LastRunTime" = $_.LastRunTime
            "LastRunResult" = $_.LastTaskResult
            "Author" = $xml.Task.Principals.Principal.UserId
            "Created" = $xml.Task.RegistrationInfo.Date
        }
        $output += $out
    }

    $output
}



