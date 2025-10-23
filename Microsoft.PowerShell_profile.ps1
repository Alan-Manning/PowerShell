###############################################################################
# Enviroment Variables
###############################################################################
$Env:KOMOREBI_CONFIG_HOME = 'C:\Users\Alan_\.config\komorebi'

###############################################################################
# oh-my-posh
###############################################################################
# oh my posh setup the theme i want when using powershell
# oh-my-posh init pwsh --config 'C:\Users\Alan_\AppDataLocal\Programs\oh-my-posh\themes\atomic.omp.json' | Invoke-Expression
oh-my-posh init pwsh --config 'C:\Users\Alan_\.config\oh-my-posh\themes\atomic_edit.omp.json' | Invoke-Expression


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
# yazi
###############################################################################
# This provides the ability to change current working directory on yazi exit.
function y {
    $tmp = [System.IO.Path]::GetTempFileName()
    yazi $args --cwd-file="$tmp"
    $cwd = Get-Content -Path $tmp
    if (-not [String]::IsNullOrEmpty($cwd) -and $cwd -ne $PWD.Path) {
        Set-Location -LiteralPath $cwd
    }
    Remove-Item -Path $tmp
}

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

###############################################################################
# Python
###############################################################################

# Python aliases and functions.
Set-Alias -Name ipy -Value ipython

# Disable the virtual enviroment string at the front of the promt, this is shown in oh-my-posh and fucks up allignment
$env:VIRTUAL_ENV_DISABLE_PROMPT=1

# look for a .venv folder and activate that venv, or lookup all
# the python virtual enviroments in the ~\py_venvs directory and
# then pipe into fzf and activate the selection.
function pyvenv {

  $venvPaths = @(
          "$(Get-Location)\.venv",
          "$(Get-Location)\venv"
      )



  foreach ($venvPath in $venvPaths) {
    $activateScript = "$venvPath\Scripts\Activate.ps1"

    if (Test-Path $venvPath) {
      if (Test-Path $activateScript){

        $shortVenvName = Split-Path -Leaf $venvPath

        $message = " Activated $shortVenvName  "

        $cowFiles = @("bud-frogs", "turtle", "eyes", "milk", "stegosaurus", "moose")

        $randomCow = $cowFiles | Get-Random
        $pythonLogo = ""

        # The cow say business with lolcat for rainbow color.
        $message | & cowthink -f "$randomCow" | lolcat

        & $activateScript
        return
        }
      }
  }

  Get-ChildItem -Path ~\py_venvs -Name | Invoke-Fzf | % {& "C:\Users\Alan_\py_venvs\$_\Scripts\activate.ps1"}

}

###############################################################################
# Remaps and extra functions
###############################################################################

# aliases and functions.
Set-Alias -Name lg -Value lazygit

Set-Alias -Name vim -Value nvim

# aliases and functions.
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

# make the where command work nicer.
function whereis($name){
    gcm $name
}
