param([String]$siteUrl, [String]$sitemapFile, [String]$statusFile, [String]$logFile, [String]$instance)

$MyDir = Split-Path $MyInvocation.MyCommand.Definition

Start-Sleep -s 10

. "$MyDir\WaitForSitefinityToStart.ps1" -url $siteUrl -instance $instance
. "$MyDir\SiteWarmup.ps1" -statusFile $statusFile -logFile $logFile -sitemapFile $sitemapFile -instance $instance