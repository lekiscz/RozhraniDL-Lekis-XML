rem This batch file will generate HTML documentation of the XML schema by using xs3p XSLT transformation.
rem For this it must have access to cloned xs3p repo located at the same level as the root of this repo
rem  and the directory must be called "xs3p" and switched to correct branch.
rem
rem So, just run something like this from <this repo>\Documentation:
rem
rem  git clone --branch pr-cdn-normalize-exmp https://github.com/jmarsik/xs3p.git ..\..\xs3p
rem
rem After that just run this batch file to generate RozhraniDL-Lekis-XML.xsd.htm file with documentation.
rem

set XS3P_REPO=..\..\xs3p

set XSLT_FILE=xs3p.xsl
set XSD_DIR=..\Schema
set XSD_FILE=RozhraniDL-Lekis-XML.xsd

copy /y %XS3P_REPO%\%XSLT_FILE% .
xsltproc.exe --nonet --stringparam printGlossary false --stringparam printLegend false --stringparam title %XSD_FILE% --output %XSD_FILE%.htm %XSLT_FILE% %XSD_DIR%\%XSD_FILE%
del /f /q %XSLT_FILE%
