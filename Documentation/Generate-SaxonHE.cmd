rem
rem This batch file will generate HTML documentation of the XML schema by using xs3p XSLT transformation.
rem For this it must have access to cloned xs3p repo located at the same level as the root of this repo
rem  and the directory must be called "xs3p" and switched to correct branch.
rem
rem So, just run something like this from <this repo>\Documentation:
rem
rem  git clone --branch pr-cdn-normalize-exmp https://github.com/jmarsik/xs3p.git ..\..\xs3p
rem
rem You must also have Transform.exe tool in your PATH. It can be installed on Windows by using the Chocolatey
rem  package manager as part of SaxonHE package (see https://chocolatey.org/packages/SaxonHE).
rem
rem To install it run something like this:
rem
rem  choco install SaxonHE --yes
rem
rem After that just run this batch file to generate RozhraniDL-Lekis-XML.xsd.htm file with documentation.
rem

set XS3P_REPO=..\..\xs3p
IF NOT "%1"=="" (
    set XS3P_REPO=%1
)

set XSLT_FILE=xs3p.xsl
set XSD_DIR=..\Schema
set XSD_FILE=RozhraniDL-Lekis-XML.xsd

Transform.exe ^
    -s:"%XSD_DIR%\%XSD_FILE%" ^
    -xsl:"%XS3P_REPO%\%XSLT_FILE%" ^
    -o:"%XSD_FILE%.htm" ^
    printGlossary=false ^
    printLegend=false ^
    "title=%XSD_FILE%" ^
    !indent=no
