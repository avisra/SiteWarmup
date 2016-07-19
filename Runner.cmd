:: Specify the WEBSITE_NODE_DEFAULT_VERSION in your app service application settings to a recent version
:: This tool runs off the Azure CLI to communicate with your App Service. To do this, it needs your publishsettings file
:: You can generate this file here: https://manage.windowsazure.com/PublishSettings/index?Client=&SchemaVersion=&DisplayTenantSelector=true
:: Add it to the root of your azure environment %HOME%

@echo off
set "publishsettings=%HOME%\YourPublishSettings.publishsettings"
set "sitename=AzureSiteName"
set "siteurl=http://www.mysite.com"
set "statusfile=%HOME%\site\wwwroot\App_Data\status{0}.txt"
set "logfile=%HOME%\site\wwwroot\App_Data\log{0}.csv"
set "sitemapfile=%HOME%\site\wwwroot\sitemap.xml"
set "authkey=49XA46f08l3J5F58tOEHN977Tk402qDS"
set "appdir=%HOME%\site\wwwroot"
set "sitemapurl=http://www.mysite.com/sitemap/sitemap.xml"

PowerShell.exe -ExecutionPolicy ByPass -File Runner.ps1 -settingsFile "%publishsettings%" -siteName "%sitename%" -appDir "%appdir%" -authKey "%authkey%" -siteUrl "%siteurl%" -statusFile "%statusfile%" -logFile "%logfile%" -sitemapFile "%sitemapFile%" -sitemapUrl "%sitemapUrl%"