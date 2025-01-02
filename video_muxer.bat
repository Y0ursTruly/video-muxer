@echo off
setlocal enabledelayedexpansion



cd audios
set filetype=mp3
set files=files.txt
set output=../output.%filetype%

:: clear the output file without adding a blank line
break> "%files%"

:: loop through all files in the current directory (in lexically sorted order)
for %%F in (*) do (
    set "ext=%%~xF"
    :: will only consider those of desired filetype
    if /i "!ext!"==".%filetype%" (
        echo file '%%F' >> "%files%"
    )
)

ffmpeg -f concat -safe 0 -i %files% -c copy %output%
del %files%
cd ..


cd videos
set filetype=mp4
set files=files.txt
set output=../output.%filetype%

:: clear the output file without adding a blank line
break> "%files%"

:: loop through all files in the current directory (in lexically sorted order)
for %%F in (*) do (
    set "ext=%%~xF"
    :: will only consider those of desired filetype
    if /i "!ext!"==".%filetype%" (
        echo file '%%F' >> "%files%"
    )
)

ffmpeg -f concat -safe 0 -i %files% -c copy %output%
del %files%
cd ..



ffmpeg -i output.mp4 -i output.mp3 -c:v copy -map 0:v -map 1:a -y muxed.mp4
del /f /q output.mp3
del /f /q output.mp4

echo Video Successfully Compiled as muxed.mp4
pause
