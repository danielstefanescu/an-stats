$username = "johndoe"
$pass = "foobar"
$nodesFilePath = "C:\Users\john\nodes.csv"
$nodesList = Import-Csv -Path $nodesFilePath


$webDriver = Start-SeChrome
$webDriver.Navigate().GoToUrl("https://airnode.worldmobile.net/auth/login")
# Wait for the page to load
Start-Sleep -Seconds 3
$acceptButton = $webDriver.FindElementByXPath("//button[text()='Accept All']")
$acceptButton.Click()

$form = $webDriver.FindElementByTagName("form")
$inputFields = $form.FindElementsByTagName("input")
$loginButton = $webDriver.FindElementByXPath("//form/following-sibling::button")
if ($inputFields.Count -eq 2) {
    $usernameField = $inputFields[0]
    $passwordField = $inputFields[1]
    $usernameField.SendKeys($username)
    $passwordField.SendKeys($pass)   
    $loginButton.Click() 
    Start-Sleep -Seconds 5
    $gmapsUrl = "https://www.google.com/maps?q="
    $coords = ""
    $nodesList | % { 
        $nodeId = $_.id
        if ($_.type -eq "spark") {
            $nodeUrl = "https://airnode.worldmobile.net/app/airnodes/operate-spark/$($nodeId)"
        }
        elseif ($_.type -eq "link") {
            $nodeUrl = "https://airnode.worldmobile.net/app/airnodes/operate-cpe/$($nodeId)"
        }
        
        $webDriver.Navigate().GoToUrl($nodeUrl)
        Start-Sleep -Seconds 3
        $nameElement = $webDriver.FindElementByXPath("/html/body/div[1]/div[1]/div/div/div/div/main/div[1]/div/div/div/p")
        $name = $nameElement.Text.Trim()       
        $url = $webDriver.FindElementByClassName("mapbox-improve-map").GetAttribute("href")

        if ($url -match "\?(.*)$") {
            $queryString = $matches[1]
            $parameters = $queryString -split "&"
            $last = $parameters[2] -split "/"
            $lat = $last[2]
            $long = $last[1]
            "$($name),$($lat),$($long)"
        }        
    }
}


$webDriver.Quit()

