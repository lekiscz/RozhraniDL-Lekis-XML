rem
rem This batch file will generate HTML documentation of XML schemas by using xs3p XSLT transformation.
rem For this it must have access to cloned xs3p repo located at the same level as the root of this repo
rem  and the directory must be called "xs3p" and switched to correct branch.
rem
rem So, just run something like this from <this repo>\Documentation:
rem
rem  git clone --branch pr-cdn-normalize-exmp https://github.com/jmarsik/xs3p.git ..\..\xs3p
rem
rem You must also have xsltproc.exe tool in your PATH. It can be installed on Windows by using the Chocolatey
rem  package manager as part of Strawberry Perl package (see https://chocolatey.org/packages/StrawberryPerl).
rem
rem To install it run something like this:
rem
rem  choco install StrawberryPerl --yes
rem
rem After that just run this batch file to generate .xsd.htm files with documentation.
rem

Setlocal EnableDelayedExpansion

set XS3P_REPO=..\..\xs3p
IF NOT "%1"=="" (
    set XS3P_REPO=%1
)

set XSLT_FILE=xs3p.xsl
set XSD_DIR=..\Schema

for /r "%XSD_DIR%" %%g in (*.xsd) do (
    for %%A in ("%%g") do (
        set XSD_FILE_FOLDER=%%~dpA
        set XSD_FILE=%%~nxA
    )

    xsltproc.exe ^
        --nonet ^
        --stringparam printGlossary false ^
        --stringparam printLegend false ^
        --stringparam title "!XSD_FILE!" ^
        --output "!XSD_FILE!.htm" ^
        "%XS3P_REPO%\%XSLT_FILE%" ^
        "%XSD_DIR%\!XSD_FILE!"
)
