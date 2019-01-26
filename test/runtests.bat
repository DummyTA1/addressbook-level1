@ECHO OFF

REM change current directory to the location of this script
pushd %~dp0

REM create bin directory if it doesn't exist
if not exist ..\bin mkdir ..\bin

REM compile the code into the bin folder
javac ..\src\seedu\addressbook\AddressBook.java -d ..\bin
IF ERRORLEVEL 1 (
    echo ********** BUILD FAILURE ********** 
    REM return to previous directory
    popd
    exit /b 1
)
REM no error here, errorlevel == 0

REM (invalid) no parent directory, invalid filename with no extension
java -classpath ..\bin seedu.addressbook.AddressBook " " < NUL > ACTUAL.TXT
REM (invalid) invalid parent directory that does not exist, valid filename
java -classpath ..\bin seedu.addressbook.AddressBook "directoryThatDoesNotExist/valid.filename" < NUL >> ACTUAL.TXT
REM (invalid) no parent directory, invalid filename with dot on first character
java -classpath ..\bin seedu.addressbook.AddressBook ".noFilename" < NUL >> ACTUAL.TXT
REM (invalid) valid parent directory, non regular file
if not exist data\notRegularFile.txt mkdir data\notRegularFile.txt
java -classpath ..\bin seedu.addressbook.AddressBook "data/notRegularFile.txt" < NUL >> ACTUAL.TXT
REM (valid) valid parent directory, valid filename with extension.
copy /y NUL data\valid.filename
java -classpath ..\bin seedu.addressbook.AddressBook "data/valid.filename" < exitinput.txt >> ACTUAL.TXT
REM run the program, feed commands from input.txt file and redirect the output to the ACTUAL.TXT
java -classpath ..\bin seedu.addressbook.AddressBook < input.txt >> ACTUAL.TXT

REM compare the output to the expected output
FC ACTUAL.TXT EXPECTED.TXT

REM return to previous directory
popd
