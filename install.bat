@echo off

IF "%QHOME%"=="" (
    ECHO ERROR: Environment variable QHOME is NOT defined
    EXIT /B 1
)

REM Detect architecture: prefer w64, fall back to w32
IF EXIST "%QHOME%\w64" (
    SET Q_ARCH_DIR=w64
) ELSE IF EXIST "%QHOME%\w32" (
    SET Q_ARCH_DIR=w32
) ELSE (
    ECHO ERROR: Neither %QHOME%\w64 nor %QHOME%\w32 found
    EXIT /B 1
)

IF EXIST q (
    ECHO Copying q script to %QHOME%
    COPY q\* "%QHOME%"
    IF %ERRORLEVEL% NEQ 0 (
        ECHO ERROR: Copy failed
        EXIT /B %ERRORLEVEL%
    )
)

IF EXIST lib (
    ECHO Copying DLL to %QHOME%\%Q_ARCH_DIR%
    COPY lib\* "%QHOME%\%Q_ARCH_DIR%\"
    IF %ERRORLEVEL% NEQ 0 (
        ECHO ERROR: Copy failed
        EXIT /B %ERRORLEVEL%
    )
)

ECHO Installation complete
EXIT /B 0