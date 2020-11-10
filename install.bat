@echo off

TITLE PocketMine-MP Install Utility
SET pocketminedir=%cd%\PocketMine-MP
SET php=%pocketminedir%\bin\php\php.exe
where git >nul 2>nul || (call :print-error "git is required" & exit 1)

call :print "Downloading PocketMine-MP 4"
git clone --branch=master --recursive https://github.com/pmmp/PocketMine-MP

cd %pocketminedir%

call :print "Downloading PHP binaries"
curl -Lo php.zip "http://ci.appveyor.com/api/buildjobs/r59lr8c98cp53d6c/artifacts/php-7.4.12-vc15-x64.zip"

call :print "Unzipping PHP binaries"
powershell.exe -nologo -noprofile -command "& { $shell = New-Object -COM Shell.Application; $target = $shell.NameSpace('%pocketminedir%'); $zip = $shell.NameSpace('%pocketminedir%\php.zip'); $target.CopyHere($zip.Items(), 16); }"

call :print "Downloading composer"
%php% -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
%php% -r "if (hash_file('sha384', 'composer-setup.php') === 'c31c1e292ad7be5f49291169c0ac8f683499edddcfd4e42232982d0fd193004208a58ff6f353fde0012d35fdd72bc394') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;"
%php% composer-setup.php
%php% -r "unlink('composer-setup.php');"

call :print "Installing composer depedencies"
%php% composer.phar install

curl -Lo startserver.bat "https://gist.githubusercontent.com/Mohagames205/ecba223243404e9ac4d21be8019f66cd/raw/9821481de066da1dc33e6a79ef862a8583bfceb3/start.bat"

call :print "PocketMine-MP 4.0 downloaded and setup succesfully"

:print-error
call :print "[ERROR] %~1"
exit /B 0

:print
echo ===============================
echo [PocketMine-MP Installation Utility] %~1
echo ===============================
exit /B 0
