@echo off

@REM 获取引擎目录
set ENGINE_PATH=**********************
set BUILD_CONFIG=%1

@REM 获取项目目录
set PROJECT_NAME=*****************
set "CUR_DIR=%~dp0"
set "PROJECT_PATH=%CUR_DIR:~0,-1%"
for %%I in ("%PROJECT_PATH%") do set "PROJECT_PATH=%%~dpI"

@REM 生成输出目录
cd %PROJECT_PATH%
if not exist "Output" (md "Output")
for /f "tokens=2 delims==" %%I in ('wmic os get localdatetime /value') do set datetime=%%I
set "year=%datetime:~0,4%"
set "month=%datetime:~4,2%"
set "day=%datetime:~6,2%"
set "hour=%datetime:~8,2%"
set "minute=%datetime:~10,2%"
set "second=%datetime:~12,2%"
set OUTPUT_NAME=%year%-%month%-%day%_%hour%%minute%%second%_%BUILD_CONFIG%
set OUTPUT_PATH=%PROJECT_PATH%Output\%OUTPUT_NAME%
md %OUTPUT_PATH%

cd /d %ENGINE_PATH%

Engine\Build\BatchFiles\RunUAT.bat BuildCookRun ^
 -project=%PROJECT_PATH%%PROJECT_NAME%.uproject ^
 -noP4 -platform=Win64 -clientconfig=%BUILD_CONFIG% -serverconfig=%BUILD_CONFIG% ^
 -cook -allmaps -build -stage -pak -archive -archivedirectory=%OUTPUT_PATH%

pause