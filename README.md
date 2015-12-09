# SiteWarmup
Multithreaded warmup tool that runs off a sitemap.xml file

This powershell script was created with Sitefinity sites in mind. By default, Sitefinity pages go through two steps when they are loaded for the first time:

- Compilation (Compiled ASPX code based on Sitemap page)
- Output Generation (static HTML generation based on URL)

