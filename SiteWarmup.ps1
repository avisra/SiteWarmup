# sitemapFile - location of the XML Sitemap
# statusFile - location of the status file. Progress is written here. Place somewhere in website root so you can open using a web browser to see current status. If empty, placed in same folder as this script
# logFile - location of the log file. All URLs are logged here with their HTTP status code and response time. Recommend placing in App_Data. If empty, placed in same folder as this script

param([String]$sitemapFile, [String]$statusFile, [String]$logFile)

# Multi-threading library
$MyDir = Split-Path $MyInvocation.MyCommand.Definition
. "$MyDir\Invoke-Parallel.ps1"

$startTime = Get-Date

if([string]::IsNullOrEmpty($logFile)) { $logFile = "$MyDir\log.csv" }
if([string]::IsNullOrEmpty($statusFile)) { $statusFile = "$MyDir\status.txt" }

$null | out-file $statusFile
    
$pages = @()

# Collect page urls for processing
""
"Collecting page urls..."
[xml]$xml = Get-Content $sitemapFile -ReadCount 0
foreach ($urlCollection in $xml.urlset.url)
{
    if($urlCollection.link -eq $null)
    {
        # No language variation, just use the default location
        $pages += $urlCollection.loc

    } else {

        # Loop through all language variations
        foreach ($link in $urlCollection.link)
        {
            $pages += $link.ref
        }

    }
}

"Sitemap count:" + $pages.Count
""

$pages | Invoke-Parallel -LogFile $logFile -ProgressFile $statusFile {

    $url = $_
    
    # create a web request with browser cache disabled
    [System.Net.HttpWebRequest] $request = [System.Net.HttpWebRequest]::Create($url)
    $request.Method = "GET"
    $request.Timeout = 21600000
    $request.CachePolicy = New-Object System.Net.Cache.HttpRequestCachePolicy([System.Net.Cache.HttpRequestCacheLevel]::NoCacheNoStore)
    $request.UserAgent = [Microsoft.PowerShell.Commands.PSUserAgent]::Chrome
    
    [System.Net.HttpWebResponse] $response = $request.GetResponse()
    $response.Close()

}

Write-Host "Warmup completed"  -ForegroundColor "magenta"