The recommended way to run this script is on a scheduled task. This task would run on a nightly basis after any scheduled application pool recycles would be happening. You can then manually run this task on an as-needed basis if you need to run it outside of the schedule.

The process will write to a spreadsheet (log.csv) which will contain a list of all of the URLs it has warmed up so far. It will also display erroring pages so you can determine if your sitemap.xml contains 404 errors, 500 errors, etc. This process will also write to a status.txt file which shows the current status of the warmup process (how far along it is). You should not open these files with an editor (excel, notepad) while the warmup process is running - as you might get an error about the file being in use from the powershell script. To view these files, open them with your web browser.

# Configuration
The SiteWarmup.ps1 file is the script you will run to start the warmup process. The only thing that needs configured for this script to run is the $sitemapFile parameter. This defines the path to the sitemap.xml file. The script reads all of the URLs from this file to warmup.
```
$sitemapFile = 'C:\path\to\sitemap.xml'
```


# 

This powershell script was created with Sitefinity sites in mind. By default, Sitefinity pages go through two steps when they are loaded for the first time:

- Compilation (Compiled ASPX code based on Sitemap page)
- Output Generation (static HTML generation based on URL)

This tool is meant to handle the Output Generation part of the process. Technically, if you have not already compiled the sitemap page, the warmup will do that automatically - but it will take more time than necessary.
