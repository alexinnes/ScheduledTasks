function Verb-Noun {
    [CmdletBinding()]
    param (
    [Parameter(Mandatory=$true)]
    $computer
    )


    $output = @()
    $out = @()

    $sched = New-Object -Com "Schedule.Service"
    $sched.Connect($computer)
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



