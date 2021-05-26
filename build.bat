@echo off

setlocal

if not "%VSCMD_ARG_TGT_ARCH%"=="x64" (
    echo This batch file must be run with the "x64 Native Tools Command Prompt for VS2019"!
    goto :error
)

if "%1" == "" (
  set VCPKG_DIR=out/vcpkg/master
  set VCPKG_URL=https://github.com/microsoft/vcpkg
  set VCPKG_BRANCH=master
) else (
  set VCPKG_DIR=out/vcpkg/patched
  set VCPKG_URL=https://github.com/Ziriax/vcpkg
  set VCPKG_BRANCH=libde265_static
)

cd /d %~dp0
if errorlevel 1 goto :error

SET TARGET_TRIPLET=x64-windows-static
REM SET TARGET_TRIPLET=x64-windows

if not exist out (
    mkdir out
    if errorlevel 1 goto :error
)

if not exist %VCPKG_DIR% (
    echo Cloning vcpkg...

    git clone %VCPKG_URL% %VCPKG_DIR% -b %VCPKG_BRANCH%
    if errorlevel 1 goto :error

    cd /d %VCPKG_DIR%
    if errorlevel 1 goto :error

    echo Bootstrapping vcpkg...
    call bootstrap-vcpkg.bat
    if errorlevel 1 goto :error
)

echo Installing libs...
vcpkg install libheif --triplet %TARGET_TRIPLET%
if errorlevel 1 goto :error

echo Deleting CMake cache...
if exist "%~dp0out\build\%TARGET_TRIPLET%\CMakeCache.txt" (
  del "%~dp0out\build\%TARGET_TRIPLET%\CMakeCache.txt"
  if errorlevel 1 goto :error
)

set BUILD_DIR="%~dp0out/build/%TARGET_TRIPLET%"

if not exist "%~dp0%VCPKG_DIR%\scripts\buildsystems\vcpkg.cmake" (
  echo vcpkg cmake toolchain file not found!
  goto :error
)

REM https://devblogs.microsoft.com/cppblog/vcpkg-updates-static-linking-is-now-available/

echo Generating Ninja build files...
cmake ^
    -G "Ninja Multi-Config" ^
    -D CMAKE_TOOLCHAIN_FILE="%~dp0%VCPKG_DIR%\scripts\buildsystems\vcpkg.cmake" ^
    -D VCPKG_TARGET_TRIPLET=%TARGET_TRIPLET% ^
    -B %BUILD_DIR% ^
    -S "%~dp0"
if errorlevel 1 goto :error

echo Building/Debug...
cmake --build %BUILD_DIR% --config Debug
if errorlevel 1 goto :error

echo Building/Release...
cmake --build %BUILD_DIR% --config Release
if errorlevel 1 goto :error

echo Building/RelWithDebInfo...
cmake --build %BUILD_DIR% --config RelWithDebInfo
if errorlevel 1 goto :error


echo  %~n0 :-) success!
goto :exit

:error
echo %~n0 :-( failure!

:exit
endlocal
cd /d %~dp0


