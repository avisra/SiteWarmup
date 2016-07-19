# url - URL of Sitefinity application
# successOuput - What message to return when application has started
# totalWaitMinutes - How long this script should wait for application to start until continuing

param([String]$url="http://localhost", [String]$successOuput="SUCCESS", [Int32]$totalWaitMinutes=10)

$elapsed = [System.Diagnostics.Stopwatch]::StartNew()

$statusUrl = ($url + "/appstatus")

""
"Attempt to start Sitefinity up: " + $statusUrl

$retryCount = 0;
$progressPreference = 'silentlyContinue'
try 
{ 
  "Retry: " + $retryCount
  $retryCount++;
  $response = Invoke-WebRequest $statusUrl -TimeoutSec 1800 -UseBasicParsing

  if($response.StatusCode -eq 200)
  {
    "Sitefinity is starting ..." + $statusUrl
  }  

  while($response.StatusCode -eq 200)
  {    
    "Checking Sitefinity status: " + $statusUrl
	"Retry: " + $retryCount
	$retryCount++;
    $response = Invoke-WebRequest $statusUrl -TimeoutSec 1800 -UseBasicParsing

    if($elapsed.Elapsed.Minites > $totalWaitMinutes)
    {
	  "Sitefinity did NOT start in the specified maximum time"
      break
    }

	Start-Sleep -s 1
  }
} 
catch 
{
  if($_.Exception.Response.StatusCode.Value__ -eq 404)
  {
    $response = Invoke-WebRequest $url -TimeoutSec 120 -UseBasicParsing

    if($response.StatusCode -eq 200)
    {
      "Sitefinity has started after " + $elapsed.Elapsed.Seconds + " second(s) - " + $successOuput
    }
    else
    {
      "Sitefinity failed to start"
    }
  }
  else
  {
    "Sitefinity failed to start - StatusCode: " + $_.Exception.Response.StatusCode.Value__
	
    $_|format-list
	$_.Exception|format-list
  }
}