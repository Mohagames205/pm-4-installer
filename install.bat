@echo off

TITLE PocketMine 4.x install utility
SET pocketminedir=%cd%\PocketMine-MP
SET php=%pocketminedir%\bin\php\php.exe
where git >nul 2>nul || (call :pm-echo-error "git is required" & exit 1)

call :pm-echo "Downloading PocketMine-MP 4"
git clone --branch=master --recursive https://github.com/pmmp/PocketMine-MP

cd %pocketminedir%


call :pm-echo "Downloading PHP binaries"
curl -Lo php.zip "http://ci.appveyor.com/api/buildjobs/r59lr8c98cp53d6c/artifacts/php-7.4.12-vc15-x64.zip"

call :pm-echo "Unzipping PHP binaries"
powershell.exe -nologo -noprofile -command "& { $shell = New-Object -COM Shell.Application; $target = $shell.NameSpace('%pocketminedir%'); $zip = $shell.NameSpace('%pocketminedir%\php.zip'); $target.CopyHere($zip.Items(), 16); }"

call :pm-echo "Downloading composer"
%php% -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
%php% -r "if (hash_file('sha384', 'composer-setup.php') === 'c31c1e292ad7be5f49291169c0ac8f683499edddcfd4e42232982d0fd193004208a58ff6f353fde0012d35fdd72bc394') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;"
%php% composer-setup.php
%php% -r "unlink('composer-setup.php');"


call :pm-echo "Installing composer depedencies"
%php% composer.phar install

call :pm-echo "PocketMine-MP 4.0 downloaded and setup succesfully"

:pm-echo-error
call :pm-echo "[ERROR] %~1"
exit /B 0

:pm-echo
echo ===============================
echo [PocketMine-MP Installation Utility] %~1
echo ===============================
exit /B 0