# url - URL of Sitefinity application
# successOuput - What message to return when application has started
# totalWaitMinutes - How long this script should wait for application to start until continuing

param([String]$url="http://localhost", [String]$successOuput="SUCCESS", [Int32]$totalWaitMinutes=10, [String]$instance)

#cookie for azure ARRAffinity if there is an instance provided
$session = $null
if(-Not [String]::IsNullOrEmpty($instance)){
  $session = New-Object Microsoft.PowerShell.Commands.WebRequestSession
  $cookie = New-Object System.Net.Cookie 
  $cookie.Name = "ARRAffinity"
  $cookie.Value = $instance
  $cookie.Domain = ([System.Uri]$url).Host
  $session.Cookies.Add($cookie);
}

$elapsed = [System.Diagnostics.Stopwatch]::StartNew()

$statusUrl = ($url + "/appstatus")
""
"Attempt to start Sitefinity up: " + $statusUrl
if(-Not [String]::IsNullOrEmpty($instance)){
  "For instance id: " + $instance 
}
$retryCount = 0;
$progressPreference = 'silentlyContinue'
try 
{ 
  "Retry: " + $retryCount
  $retryCount++;
  $response = Invoke-WebRequest $statusUrl -TimeoutSec 1800 -UseBasicParsing -WebSession $session

  if($response.StatusCode -eq 200)
  {
    "Sitefinity is starting ..." + $statusUrl
  }  

  while($response.StatusCode -eq 200)
  {    
    "Checking Sitefinity status: " + $statusUrl
	"Retry: " + $retryCount
	$retryCount++;
    $response = Invoke-WebRequest $statusUrl -TimeoutSec 1800 -UseBasicParsing -WebSession $session

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
    $response = Invoke-WebRequest $url -TimeoutSec 120 -UseBasicParsing -WebSession $session

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