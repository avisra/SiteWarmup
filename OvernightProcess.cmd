:: %HOME%\site\wwwroot can be used for the appdir parameter when using Azure Websites
Telerik.Sitefinity.Compiler.1.0.0.10\Telerik.Sitefinity.Compiler.exe /url="http://localhost:5960/" /appdir="C:\Path\to\application\root" /authKey="L2737ln9EieQG7T0uaWdGT5J00jRNdgl" /strategy="Frontend"

:: Azure web apps has overlapped recycles on. So the site will not reset immediately
:: which will cause the WaitForSitefinityToStart script to think it has started
:: immediately. To fix this, we will manually restart the Azure Website
:: azure site restart [sitename]

PowerShell.exe -ExecutionPolicy Bypass -File WaitForSitefinityToStart.ps1 -url "http://localhost:5960"
PowerShell.exe -ExecutionPolicy Bypass -File SiteWarmup.ps1 -sitemapFile "C:\path\to\your\sitemap.xml"