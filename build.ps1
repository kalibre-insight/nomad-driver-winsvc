Push-Location (Split-Path $MyInvocation.MyCommand.Path)

try {

    # Updated and get config
    Write-Host "Current Location: $(get-location)"   

    Push-Location .\src

    $path = '../bin'

    if (-not ($path | Test-Path)) {
        New-Item $path -force -itemtype directory
    }

    $currentlocation = $(get-location)
    $invokelocation = (Split-Path $MyInvocation.MyCommand.Path)
    # $goroot = "c:\program files\go"
    # $gopath = "c:\dashs"

    Write-Host "Source (src) dir:	$currentlocation"
    Write-Host "Script dir:		$invokelocation"
    # Write-Host "GOROOT dir:		$goroot"
    # Write-Host "GOPATH dir:		$gopath"

    $env:GOOS = "windows";
    $env:GOARCH = "amd64";
    $env:CGO_ENABLED = 0
    $env:GO111MODULE = "on"
    # $env:GOROOT="$goroot"
    # $env:GOPATH="$gopath"

    # go get -u -d ./...

    go mod tidy

    $output = $path + "/winsvc-driver.exe"
    
    go build -o $output .

}
catch {
    Write-Host "An error occurred that could not be resolved."
    Write-Host $_.ScriptStackTrace
}
finally {
    Pop-Location
}

Pop-Location

Write-Host "Build Complete"