set-location C:\Users\admin\.config\powershell\

function custom_edit_powershell{
		vim "C:\Users\admin\Documents\WindowsPowerShell\Microsoft.PowerShell_profile.ps1"

		# from https://lazyadmin.nl/powershell/powershell-profile/
}
function custom_edit_neovim_config {
	nvim "~/Appdata/Local/nvim/init.lua"
}

function custom_goto_school{
	pushd E:
	cd \
	cd school
	cd 3rdyr
	cd 2ndsem
}

function custom_goto_neovim_config{
	cd ~
	cd Appdata
	cd Local
	cd nvim
}

function custom_goto_powershell_config{
	pushd C:
	cd \
	cd Users
	cd admin
	cd Documents
	cd WindowsPowerShell
}

function custom_neovide_run {
	neovide $args --opengl 
}

function custom_git_push_nomessage{
	git add .
	git commit --allow-empty-message -m ' '
	git push
}




# edit
set-alias vimpower custom_edit_powershell
set-alias nvimconfig custom_edit_neovim_config

# editor
set-alias nn custom_neovide_run	 
set-alias gitnomsg custom_git_push_nomessage

# goto
set-alias cds custom_goto_school
set-alias cdnn custom_goto_neovim_config
set-alias cdps custom_goto_powershell_config


# for starship
Invoke-Expression (&starship init powershell)

# Import the Chocolatey Profile that contains the necessary code to enable
# tab-completions to function for `choco`.
# Be aware that if you are missing these lines from your profile, tab completion
# for `choco` will not function.
# See https://ch0.co/tab-completion for details.
$ChocolateyProfile = "$env:ChocolateyInstall\helpers\chocolateyProfile.psm1"
if (Test-Path($ChocolateyProfile)) {
  Import-Module "$ChocolateyProfile"
}
