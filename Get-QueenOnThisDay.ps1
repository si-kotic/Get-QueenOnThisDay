Function Get-QueenOnThisDay {
    [CmdLetBinding()]
    Param (
        [switch]$All
    )
    $queenLogo = @"
     ____  __  _______________   __
    / __ \/ / / / ____/ ____/ | / /
   / / / / / / / __/ / __/ /  |/ / 
  / /_/ / /_/ / /___/ /___/ /|  /  
  \___\_\____/_____/_____/_/ |_/   
       ON     THIS     DAY         
"@
    $webContent = (Invoke-WebRequest -Uri https://www.queensongs.info/on-this-day).Content
    $allFacts = Select-String -InputObject $webContent -AllMatches -Pattern "<div class=`"card-body`">\s+?<h5 class=`"card-title`">([\w\d\W]+?)<\/h5>\s+?<h6 class=`"card-subtitle mb-2 text-muted`">([\w\d\W]+?)<\/h6>\s+?([\w\d\W]+?)\s+?<\/div>"
    # $qotdFacts = $allFacts.Matches | Where-Object {$_.Groups[2].Value -ne "others"}
    $qotdFacts = $allFacts.Matches
    $factObj = foreach ($fact in $qotdFacts) {
        $properties = [ordered]@{
            "When"  = $fact.Groups[1].Value;
            "Who"   = $fact.Groups[2].Value;
            "What"  = $fact.Groups[3].Value.Trim();
        }
        New-Object -TypeName PSObject -Property $properties
    }
    if ($All) {
        Write-Host $queenLogo
        $factObj | Format-Table When,What
    } else {
        $curFact = Get-Random $factObj
        Write-Host $queenLogo
        Write-Host
        Write-Host "$($curFact.When), $($curFact.What)"
        Write-Host
        Write-Host
    }
}