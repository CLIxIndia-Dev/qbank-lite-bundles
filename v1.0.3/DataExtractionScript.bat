
@ECHO OFF

REM Create unique temporary folder using the current date.
set TIMESTAMP=%DATE:~10,4%-%DATE:~4,2%-%DATE:~7,2%-%TIME:~0,2%-%TIME:~3,2%-%TIME:~6,2%
set Dirname=QBank-%TIMESTAMP%
set /a inx=2

:LOOP
IF NOT EXIST "%Dirname%" GOTO CREATE
set Dirname=QBank-%TIMESTAMP% (%inx%)
set /a inx+=1
if %inx% gtr 9 goto :END REM Eh, giving up.
goto LOOP
:END



:CREATE
echo ===========================================================================
echo Creating temporary directory called "%Dirname%"
echo ===========================================================================
md "%Dirname%"
md "%Dirname%\assessment"
md "%Dirname%\assessment\AssessmentOffered"
md "%Dirname%\assessment\AssessmentTaken"
md "%Dirname%\logging"
md "%Dirname%\logging\Log"
md "%Dirname%\logging\LogEntry"
md "%Dirname%\Repository"
md "%Dirname%\Repository\Asset"
md "%Dirname%\Repository\AssetContent"
:END

REM Copy QBank data directories to temporary folder.
:GETDATA
echo ===========================================================================
echo Coping data from assessment folders
echo ===========================================================================
copy "webapps\CLIx\datastore\assessment" "%Dirname%\Assessment"
copy "webapps\CLIx\datastore\assessment\AssessmentOffered" "%Dirname%\Assessment\AssessmentOffered"
copy "webapps\CLIx\datastore\assessment\AssessmentTaken" "%Dirname%\Assessment\AssessmentTaken"

echo ===========================================================================
echo Coping data from logging folders
echo ===========================================================================
copy "webapps\CLIx\datastore\logging" "%Dirname%\logging"
copy "webapps\CLIx\datastore\logging\Log" "%Dirname%\logging\Log"
copy "webapps\CLIx\datastore\logging\LogEntry" "%Dirname%\logging\LogEntry"

echo ===========================================================================
echo Coping data from repository folders
echo ===========================================================================
copy "webapps\CLIx\datastore\repository" "%Dirname%/repository"
copy "webapps\CLIx\datastore\repository\Asset" "%Dirname%\repository\Asset"
copy "webapps\CLIx\datastore\studentResponseFiles" "%Dirname%\repository\AssetContent"

echo ===========================================================================
echo Coping data from unplatform
echo ===========================================================================
copy "unplatform\db.sqlite3" "%Dirname%/db.%TIMESTAMP%.sqlite3"
:END

REM Zip QBank Data directory
:ZIPDATA
echo ===============================================================================
echo Creating QBank data zip file ... please wait ... this can take upto 5 minutes
echo ===============================================================================

call zipjs.bat zipItem -source "%Dirname%" -destination "%Dirname%.zip" -keep yes -force no
:END

REM Remove temporary folder.
:DELFOLDER
echo ===========================================================================
echo Deleting temporary files ...please wait...
echo ===========================================================================
rmdir "%Dirname%" /s /q
:END

echo ======================================================
echo QBank Data Collection Complete
echo ======================================================
