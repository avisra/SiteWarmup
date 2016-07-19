param([String]$settingsFile, [String]$siteName, [String]$appDir, [String]$authKey, [String]$siteUrl, [String]$sitemapFile, [String]$statusFile, [String]$logFile, [String]$instance, [String]$sitemapUrl)

$MyDir = Split-Path $MyInvocation.MyCommand.Definition

Start-Sleep -s 10

if(-Not ([string]::IsNullOrEmpty($sitemapUrl))) {
    "Downloading latest sitemap file"
    $wc = New-Object System.Net.WebClient
    $wc.DownloadFile($sitemapUrl, $sitemapFile)
}

"Attempting to update NPM"
npm install npm -g

"Attempting to install Azure CLI"
npm install azure-cli -g

"Attempting to install publishing settings"
azure account import $settingsFile

"Requesting instance IDs using Azure CLI"
$siteDetails = azure site show $siteName --json
$siteJson = ConvertFrom-Json "$siteDetails"
$instances = $siteJson.instances

"These azure instances were detected:"
$instances
""

# Start precompiler on any instance - it doesn't matter
$precompilerFile = "$MyDir\Telerik.Sitefinity.Compiler.1.0.0.10\Telerik.Sitefinity.Compiler.exe"
& $precompilerFile /url="$siteUrl" /appdir="$appDir" /authKey="$authKey" /strategy="Frontend" /instanceId="$instances[0]"

foreach ($instance in $instances)
{
   # Wait for sitefinity to start and begin warmup
    . "$MyDir\AzureScaledAppController.ps1" -siteUrl $siteUrl -sitemapFile $sitemapFile -statusFile $statusFile -logFile $logFile -instance $instance
}