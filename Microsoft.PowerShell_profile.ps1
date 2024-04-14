# oh my posh setup the theme i want when using powershell
oh-my-posh init pwsh --config 'C:\Users\Alan_\AppData\Local\Programs\oh-my-posh\themes\atomic.omp.json' | Invoke-Expression


# Import the Chocolatey Profile that contains the necessary code to enable
# tab-completions to function for `choco`.
# Be aware that if you are missing these lines from your profile, tab completion
# for `choco` will not function.
# See https://ch0.co/tab-completion for details.
$ChocolateyProfile = "$env:ChocolateyInstall\helpers\chocolateyProfile.psm1"
if (Test-Path($ChocolateyProfile)) {
  Import-Module "$ChocolateyProfile"
}


# replace 'Ctrl+t' and 'Ctrl+r' with your preferred bindings:
Set-PsFzfOption -PSReadlineChordProvider 'Ctrl+t' -PSReadlineChordReverseHistory 'Ctrl+Spacebar'

# PSFzf to replace the standard tab completeion
Set-PSReadLineKeyHandler -Key Tab -ScriptBlock { Invoke-FzfTabCompletion }

###############################################################################
# below used the setup found here - https://christitus.com/pretty-powershell  #
###############################################################################

# Simple function to start a new elevated process. If arguments are supplied
# then a single command is started with admin rights; if not then a new admin
# instance of PowerShell is started.
function admin {
    if ($args.Count -gt 0) {   
        $argList = "& '" + $args + "'"
        Start-Process "$psHome\powershell.exe" -Verb runAs -ArgumentList $argList
    } else {
        Start-Process "$psHome\powershell.exe" -Verb runAs
    }
}

# Set UNIX-like aliases for the admin command, so sudo <command> will run the
# command with elevated rights. 
Set-Alias -Name su -Value admin
Set-Alias -Name sudo -Value admin


# Python aliases and functions.
Set-Alias -Name ipy -Value ipython

# lookup all the python virtual enviroments in the ~\py_venvs directory and
# then pipe into fzf and activate the selection.
function pyvenv {
    Get-ChildItem -Path ~\py_venvs -Name | Invoke-Fzf | % {& "C:\Users\Alan_\py_venvs\$_\Scripts\activate.ps1"}
}


# Make it easy to edit nvim config.
function nvimconf{
    cd C:/Users/Alan_/AppData/Local/nvim
    nvim
}

# Make it easy to edit this profile once it's installed.
function Edit-Profile {
    nvim C:\Users\Alan_\Documents\PowerShell\Microsoft.PowerShell_profile.ps1
}

# function to just print all files in current directory excluding folders.
function ll { Get-ChildItem -Path $pwd -File }

# function to simply reload the powershell profile.
function reload-profile {
    & $profile
}

# function to find a file (case insensitive) in the current directory and
# directories below.
function find-file($name) {
    Get-ChildItem -recurse -filter "*${name}*" -ErrorAction SilentlyContinue | ForEach-Object {
        $place_path = $_.directory
        Write-Output "${place_path}\${_}"
    }
}
