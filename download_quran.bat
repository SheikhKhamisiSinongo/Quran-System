@echo off
chcp 65001 >nul
echo.
echo ╔══════════════════════════════════════╗
echo ║   Quran Audio Downloader             ║
echo ║   Abdul Basit + Hani Al-Rifai        ║
echo ║   All 114 Surahs                     ║
echo ╚══════════════════════════════════════╝
echo.

:: Create folders
if not exist "audio\abdulbasit" mkdir "audio\abdulbasit"
if not exist "audio\rifai" mkdir "audio\rifai"

set BASE_BASIT=https://download.quranicaudio.com/quran/abdulbasit_murattal
set BASE_RIFAI=https://download.quranicaudio.com/quran/hani_rifai

echo Starting download of 228 files (114 surahs x 2 reciters)
echo This may take 20-40 minutes depending on your connection...
echo.

for /L %%i in (1,1,9) do (
  set /a NUM=%%i
  call :download 00%%i
)
for /L %%i in (10,1,99) do (
  call :download 0%%i
)
for /L %%i in (100,1,114) do (
  call :download %%i
)

echo.
echo ============================================
echo  Download Complete! Jazakum Allahu Khayran
echo ============================================
pause
goto :eof

:download
set F=%1
if not exist "audio\abdulbasit\%F%.mp3" (
  echo [%F%] Downloading Abdul Basit...
  curl -s -L -o "audio\abdulbasit\%F%.mp3" "%BASE_BASIT%/%F%.mp3"
) else (
  echo [%F%] Abdul Basit already exists, skipping...
)
if not exist "audio\rifai\%F%.mp3" (
  echo [%F%] Downloading Hani Al-Rifai...
  curl -s -L -o "audio\rifai\%F%.mp3" "%BASE_RIFAI%/%F%.mp3"
) else (
  echo [%F%] Hani Al-Rifai already exists, skipping...
)
goto :eof
