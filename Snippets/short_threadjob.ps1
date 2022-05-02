<#
.SYNOPSIS
    a function to make multithreading easier when handling input and output
.EXAMPLE
    Start-ShortThread(ScriptBlock, Arguments)
.NOTES
    Author: akaya0
    Last Edit: 02.05.2022
#>

function Start-ShortThread{
    Param(
        [Parameter(Position=0,Mandatory=$true)]$ScriptBlock,
        [object[]]$Arguments,
        [object[]]$Outputs
    )
    
    for ($i=0; $i -lt $Arguments.Count; $i++){
        $chk = $($ScriptBlock | Select-String -AllMatches -Pattern @([regex]::Escape($Arguments[$i]))).Matches.Groups[0].Value
        $chk | ForEach-Object {$ScriptBlock.Replace($_, '$args['+ $i +']')}
    }

    Start-ThreadJob -ArgumentList $Arguments `
    -ScriptBlock $([System.Management.Automation.ScriptBlock]::Create($("Process{$ScriptBlock}End{Write-Output -InputObject @()}"))) | Out-Null
}

