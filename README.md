To run this powershell warmup tool, you will be running the SiteWarmup.ps1 file. To run this, you can simply right click, Run with Powershell - or you can run from Powershell ISE. We will talk about this more under the Recommended Setup section, but you should set this script up to run on a scheduled task so it is self-managed.

The process will write to a spreadsheet (log.csv) which will contain a list of all of the URLs it has warmed up so far. It will also display erroring pages so you can determine if your sitemap.xml contains 404 errors, 500 errors, etc. This process will also write to a status.txt file which shows the current status of the warmup process (how far along it is). You should not open these files with an editor (excel, notepad) while the warmup process is running - as you might get an error about the file being in use from the powershell script. To view these files, open them with your web browser.

# Configuration

The only thing that needs configured for this script to run is the $sitemapFile parameter. This defines the path to the sitemap.xml file. The script reads all of the URLs from this file to warmup.
```
$sitemapFile = 'C:\path\to\sitemap.xml'
```

# Background information

This powershell script was created with Sitefinity sites in mind. By default, Sitefinity pages go through two steps when they are loaded for the first time:

- Compilation (Compiled ASPX code based on Sitemap page)
- Output Generation (static HTML generation based on URL)

This tool is meant to handle the Output Generation part of the process. Technically, if you have not already compiled the sitemap page, the warmup will do that automatically - but it will take more time than necessary.

# Recommended setup

This tool alone is not going to make your Sitefinity site fast. Use this checklist as a good way to secure your performance:

##### Output cache settings

Set your OutputCache to store for at least 24 hours (86400 seconds)
Set the "Wait for OutputCache to fill" option to true
Turn off "Vary by User Agent"

##### PageRouteHandler optimizations for Output Cache

By default, .NET will vary the OutputCache by User Agent. If you are using SF 9+, you will have a checkbox in the OutputCache settings of Sitefinity where you can turn off Vary by User Agent. If you do not have this, you will need to do it manually. Please take a look at this gist:

By default, .NET also varies by all params (query strings and posted parameters). This is not always desirable. If users come to your site through email campaigns or advertisements, they will often have a tracking ID attached to their URL. This will cause your page to regenerate its HTML for that user because of the query string. It is recommended to disable VaryByParams for all pages which do not need it for the page response. *For instance, you will likely need your Search page to vary by params so the query strings force the page to regenerate its output.*

##### Precompilation
##### Global.asax.cs issues

There is an issue .NET with having an empty Session_Start method in your Global.asax. cs file. This empty method causes a session to get generated. This can cause issues with compatibility with CDN's and can also cause OutputCache to be invalidated. **It is recommended to remote or comment all empty methods in your Global.asax.cs**

##### Scheduling

# Considerations
