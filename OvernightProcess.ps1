$MyDir = Split-Path $MyInvocation.MyCommand.Definition

$precompilerFile = "$MyDir\Telerik.Sitefinity.Compiler.1.0.0.10\Telerik.Sitefinity.Compiler.exe"
$sitemapFile = "C:\path\to\your\sitemap.xml"
$siteUrl = "http://localhost:5960"
# $sitemapUrl = "http://localhost:5960/sitemap/sitemap.xml"
$appDir = "C:\path\to\your\webapp"
$authKey  = "L2737ln9EieQG7T0uaWdGT5J00jRNdgl"

& $precompilerFile /url="$siteUrl" /appdir="$appDir" /authKey="$authKey" /strategy="Frontend"

# Please note, if you have Overlapped Recycles turned on in IIS, the application will
# not recycle immediately (the WaitForSitefinityToStart script will think it has started
# immediately, incorrectly). Make sure you diable overlapped recycles or manually recycle
# the application pool here
# Restart-WebAppPool -name ".NET v4.5"

. "$MyDir\WaitForSitefinityToStart.ps1" -url $siteUrl

# If you wish to download the latest sitemap. Recommend setting the Sitemap Generator to run regularly
# "Downloading latest sitemap file"
# $wc = New-Object System.Net.WebClient
# $wc.DownloadFile($sitemapUrl, $sitemapFile)

. "$MyDir\SiteWarmup.ps1" -sitemapFile $sitemapFile
