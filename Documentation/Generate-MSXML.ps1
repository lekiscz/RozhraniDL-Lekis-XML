#
# This PowerShell script will generate HTML documentation of XML schemas by using xs3p XSLT transformation.
# For this it must have access to cloned xs3p repo located at the same level as the root of this repo
#  and the directory must be called "xs3p" and switched to correct branch.
#
# So, just run something like this from <this repo>\Documentation:
#
#  git clone --branch pr-cdn-normalize-exmp https://github.com/jmarsik/xs3p.git ..\..\xs3p
#
# After that just run this script to generate .xsd.htm files with documentation.
#

Param([string] $Xs3pRepo = "..\..\xs3p")

$xs3pDir = Resolve-Path $Xs3pRepo
$xsltFile = "xs3p.xsl"
$xsdDir = "..\Schema"

Get-ChildItem -Path $xsdDir -Filter *.xsd -Recurse | ForEach-Object -Process {
    $xml = New-Object System.Xml.XmlDocument
    $xml.Load($_.FullName)

    $xslt = New-Object System.Xml.Xsl.XslCompiledTransform
    $xslt.Load((Join-Path $xs3pDir $xsltFile -Resolve))

    # prevent indentation of the output stream - with that setting the PRE sections of the result
    #  will be rendered correctly (with correct visual indentation)
    $xsltOutputSettings = $xslt.OutputSettings.Clone();
    $xsltOutputSettings.Indent = $false

    $arglist = New-Object System.Xml.Xsl.XsltArgumentList
    $arglist.AddParam("printGlossary", "", "false")
    $arglist.AddParam("printLegend", "", "false")
    $arglist.AddParam("title", "", $_.Name)

    $transformedWriter = [System.Xml.XmlWriter]::Create(((Join-Path (Get-Location) $_.Name) + ".htm"), $xsltOutputSettings)

    $xslt.Transform($xml, $arglist, $transformedWriter)

    $transformedWriter.Close()
}
