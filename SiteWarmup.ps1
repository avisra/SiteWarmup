$MyDir = Split-Path $MyInvocation.MyCommand.Definition
. "$MyDir\Invoke-Parallel.ps1"

cls

$startTime = Get-Date
$sitemapFile = 'C:\path\to\sitemap.xml'
$logFile = '.\log.csv'
$statusFile = '.\status.txt'
$pages = @()

Clear-Content $statusFile

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