$MyDir = Split-Path $MyInvocation.MyCommand.Definition

$precompilerFile = "$MyDir\Telerik.Sitefinity.Compiler.1.0.0.10\Telerik.Sitefinity.Compiler.exe"
& $precompilerFile /url="http://localhost:5960/" /appdir="C:\Path\to\application\root" /authKey="L2737ln9EieQG7T0uaWdGT5J00jRNdgl" /strategy="Frontend"

. "$MyDir\WaitForSitefinityToStart.ps1" -url "http://localhost:5960"
. "$MyDir\SiteWarmup.ps1" -sitemapFile "C:\path\to\your\sitemap.xml"