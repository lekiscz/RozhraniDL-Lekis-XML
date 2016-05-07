#
# This PowerShell script will generate HTML documentation of the XML schema by using xs3p XSLT transformation.
# For this it must have access to cloned xs3p repo located at the same level as the root of this repo
#  and the directory must be called "xs3p" and switched to correct branch.
#
# So, just run something like this from <this repo>\Documentation:
#
#  git clone --branch pr-cdn-normalize-exmp https://github.com/jmarsik/xs3p.git ..\..\xs3p
#
# After that just run this script to generate RozhraniDL-Lekis-XML.xsd.htm file with documentation.
#

Param([string] $Xs3pRepo = "..\..\xs3p")

$xsltFile = "xs3p.xsl"
$xsdDir = "..\Schema"
$xsdFile = "RozhraniDL-Lekis-XML.xsd"

$xml = New-Object System.Xml.XmlDocument
$xml.Load((Join-Path (Join-Path (Get-Location) $xsdDir) $xsdFile -Resolve))

$xslt = New-Object System.Xml.Xsl.XslCompiledTransform
$xslt.Load((Join-Path (Join-Path (Get-Location) $Xs3pRepo) $xsltFile -Resolve))

# prevent indentation of the output stream - with that setting the PRE sections of the result
#  will be rendered correctly (with correct visual indentation)
$xsltOutputSettings = $xslt.OutputSettings.Clone();
$xsltOutputSettings.Indent = $false

$arglist = New-Object System.Xml.Xsl.XsltArgumentList
$arglist.AddParam("printGlossary", "", "false")
$arglist.AddParam("printLegend", "", "false")
$arglist.AddParam("title", "", $xsdFile)

$transformedWriter = [System.Xml.XmlWriter]::Create(((Join-Path (Get-Location) $xsdFile) + "a.htm"), $xsltOutputSettings)

$xslt.Transform($xml, $arglist, $transformedWriter)

$transformedWriter.Close()
