<#
.SYNOPSIS
    a function to receive job objects from completed jobs and delete them after
.EXAMPLE
    Receive-ShortThread()

    outputs objects in array from completed jobs
.NOTES
    Author: akaya0
    Last Edit: 02.05.2022
#>

function Receive-ShortThread(){
    do{
        $runningJobs = (Get-Job | Where-Object {($_.State -eq "Running") -or ($_.State -eq "NotStarted")}).count
    }While($runningJobs -ne 0)

    $threadData = New-Object -TypeName System.Collections.ArrayList
    Get-Job | Foreach-Object {$data = Receive-Job -Id $_.Id; $null = $threadData.Add($data)}

    Get-job | Remove-job

    Write-Output -NoEnumerate $threadData
}