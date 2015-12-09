# SiteWarmup
Multithreaded warmup tool that runs off a sitemap.xml file

# Configuration
The SiteWarmup.ps1 file is the script you will run to start the warmup process

This powershell script was created with Sitefinity sites in mind. By default, Sitefinity pages go through two steps when they are loaded for the first time:

- Compilation (Compiled ASPX code based on Sitemap page)
- Output Generation (static HTML generation based on URL)

This tool is meant to handle the Output Generation part of the process. Technically, if you have not already compiled the sitemap page, the warmup will do that automatically - but it will take more time than necessary.
