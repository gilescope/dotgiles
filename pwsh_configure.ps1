Install-Module PSReadLine -AllowPrerelease -Force -Confirm:$false

Set-PSRepository -Name PSGallery -InstallationPolicy Trusted
Install-Module posh-git -Scope CurrentUser -Confirm:$false
Install-Module oh-my-posh -Scope CurrentUser -Confirm:$false
