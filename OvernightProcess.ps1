$MyDir = Split-Path $MyInvocation.MyCommand.Definition

$precompilerFile = "$MyDir\Telerik.Sitefinity.Compiler.1.0.0.10\Telerik.Sitefinity.Compiler.exe"
& $precompilerFile /url="http://localhost:5080" /appdir="C:\Projects\dag-sitefinity-website\SitefinityWebApp" /authKey="L2737ln9EieQG7T0uaWdGT5J00jRNdgl" /strategy="Frontend"

# Please note, if you have Overlapped Recycles turned on in IIS, the application will
# not recycle immediately (the WaitForSitefinityToStart script will think it has started
# immediately, incorrectly). Make sure you diable overlapped recycles or manually recycle
# the application pool here
# Restart-WebAppPool -name ".NET v4.5"

. "$MyDir\WaitForSitefinityToStart.ps1" -url "http://localhost:5960"
. "$MyDir\SiteWarmup.ps1" -sitemapFile "C:\path\to\your\sitemap.xml"
