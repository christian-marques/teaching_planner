@echo off
set DEVICE=%1

if "%1"=="chris" set DEVICE=e0aaa50b
if "%1"=="ozi" set DEVICE=ABC123
if "%1"=="tablet" set DEVICE=XYZ789

if "%1"=="" (
    flutter clean && flutter pub get && flutter run -d chrome
) else (
    flutter clean && flutter pub get && flutter run -d %DEVICE%
)