@echo off
REM Build script for eiffel_sqlite_2025

echo ========================================
echo Building Eiffel SQLite 2025
echo ========================================
echo.

REM Set environment
set EIFFEL_SQLITE_2025=%~dp0
set EIFFEL_SQLITE_2025=%EIFFEL_SQLITE_2025:~0,-1%

echo Project root: %EIFFEL_SQLITE_2025%
echo.

REM Check for Visual Studio
where cl >nul 2>&1
if %ERRORLEVEL% neq 0 (
    echo ERROR: Visual Studio command line tools not found!
    echo Please run this from a Visual Studio Command Prompt.
    echo.
    pause
    exit /b 1
)

REM Build
cd /d "%EIFFEL_SQLITE_2025%\Clib"
echo Building C library...
nmake /f Makefile

if %ERRORLEVEL% equ 0 (
    echo.
    echo ========================================
    echo Build SUCCESS!
    echo ========================================
    echo.
    echo Library: %EIFFEL_SQLITE_2025%\spec\msvc\win64\lib\sqlite_2025.lib
    echo.
    echo To use in your project:
    echo 1. Set environment: set EIFFEL_SQLITE_2025=%EIFFEL_SQLITE_2025%
    echo 2. Reference sqlite_2025.ecf in your project
    echo.
) else (
    echo.
    echo ========================================
    echo Build FAILED!
    echo ========================================
    echo.
)

pause
