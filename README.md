# Background information

These scripts were created with Sitefinity sites in mind. By default, Sitefinity pages go through two steps when they are loaded for the first time:

* **Compilation** (Compiled ASPX code based on Sitemap page)
    * We use the Sitefinity Precompiler tool to precompile the site instead of doing this on the initial request. This increases the performance and decreases the load on the CPU during peak hours.
    * Whenever a page is updated in the backend (published), it will force the page to be recompiled on its next request
    
* **Output Generation** (static HTML generation based on URL)
    * We use the SiteWarmup script to crawl every page in your XML Sitemap. This puts every page into your OutputCache. Doing this will cause your pages to come back very fast, as they are just static HTML at this point.

# How this tool works

I've created two versions of the master script file. OvernightProcess.cmd and OvernightProcess.ps1. They both do the same thing. For those of you using Azure Websites, you will need to use the .cmd file with Web Jobs instead of Scheduled Tasks. For those with remote access to the server, you can use the Task Scheduler in Windows and create a task for the OvernightProcess.ps1 file. Make sure the task runs with Administrator permissions.

Make sure you edit the OvernightProcess script to include the values applicable to your project. If the comments are not clear enough, please let me know and I'll clarify.

The script makes use of the Sitefinity Precompiler tool. You can read about and download this from here: http://docs.sitefinity.com/for-developers-sitefinity-precompiler-tool

#Considerations

This is not a one-size-fits-all solution. Unfortunately, each project is different. If you make changes weekly, then it doesn't make sense for you to run the Precompiler nightly - you should separate it from the site warmup portion (so precompilation happens weekly and site warmup still happens nightly).

*The more sitemap pages you have, the longer the precompiler will take to run. Ultimate timing will depend on your CPU performance. For me, I can precompile a 3000 page site (sitemap pages, not URLs) in 20 minutes.*

# Recommended optimizations

This tool alone is not going to make your Sitefinity site fast. Use this checklist as a good way to secure your performance:

##### Output cache settings

Make sure you have OutputCache turned on for all of your pages
Set your OutputCache to store for at least 24 hours (86400 seconds)
Set the "Wait for OutputCache to fill" option to true
Turn off "Vary by User Agent" if the option is available (SF 9+)

##### PageRouteHandler optimizations for Output Cache

By default, .NET will vary the OutputCache by User Agent. If you are using SF 9+, you will have a checkbox in the OutputCache settings of Sitefinity where you can turn off Vary by User Agent. If you do not have this, you will need to do it manually. Please take a look at this gist: https://gist.github.com/avisra/5e52a31b7892b7ec1598

By default, .NET also varies by all params (query strings and posted parameters). This is not always desirable. If users come to your site through email campaigns or advertisements, they will often have a tracking ID attached to their URL. This will cause your page to regenerate its HTML for that user because of the query string. It is recommended to disable VaryByParams for all pages which do not need it for the page response. *For instance, you will likely need your Search page to vary by params so the query strings force the page to regenerate its output.* Please take a look at this gist: https://gist.github.com/avisra/5e52a31b7892b7ec1598

##### Global.asax.cs issues

There is an issue .NET with having an empty Session_Start method in your Global.asax. cs file. This empty method causes a session to get generated. This can cause issues with compatibility with CDN's and can also cause OutputCache to be invalidated. **It is recommended to remove or comment all empty methods in your Global.asax.cs**