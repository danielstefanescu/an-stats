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
        $locationElement = $webDriver.FindElementByXPath("/html/body/div[1]/div[1]/div/div/div/div/main/div[2]/div[2]/div/p[2]")
        $location = $locationElement.Text.Trim().Replace(",", "")
        $usdElement = $webDriver.FindElementByXPath("/html/body/div[1]/div[1]/div/div/div/div/main/div[7]/div/div/div[1]/div/div/span[1]")
        $earnings = $usdElement.Text.Trim()
        try {
            $trafficElement = $webDriver.FindElementByXPath("/html/body/div[1]/div[1]/div/div/div/div/main/div[7]/div/div/div[2]/div/div/div/span[1]")
            $traffic = $trafficElement.Text.Trim()
            $trafficGBElement = $webDriver.FindElementByXPath("/html/body/div[1]/div[1]/div/div/div/div/main/div[7]/div/div/div[2]/div/div/div/span[2]")
            $trafficUnits = $trafficGBElement.Text.Trim()
        }
        catch {
            $traffic = "N/A"
            $trafficUnits = ""
        }
        Write-Output "$($name),$($location),$($earnings),$($traffic),$($trafficUnits)"
    }
}

$webDriver.Quit()

