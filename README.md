# Rozhraní dodacích listů Lekis XML

XML schéma, příklady, validátor

## XML schéma (XSD)

[RozhraniDL-Lekis-XML.xsd](Schema/RozhraniDL-Lekis-XML.xsd)

## Dokumentace

Adresář [Documentation](Documentation) obsahuje skripty pro vygenerování HTML dokumentace výše uvedeného XSD souboru pomocí xs3p XSLT transformace s použitím různých XSLT SW. Uvnitř každého skriptu jsou popsány jeho další požadavky.

Vygenerovanou dokumentaci k aktuální verzi XSD souboru najdete také [zde](https://lekiscz.github.io/RozhraniDL-Lekis-XML/).

## Příklady

Několik příkladů je k dispozici v adresáři [Examples](Examples).

Jsou rozdělené na korektní (Good) a nekorektní (Bad), které neprojdou (a nemají projít) validací pomocí výše uvedeného XSD souboru.

## Validátory

Jde o velmi základní validátory příkladových XML souborů, zda odpovídají danému XML schématu. Oba validátory mají v sobě zadané pevné cesty a jsou tedy spustitelné pouze v rámci adresářové struktury tohoto repository. Další omezení validátorů jsou popsána níže.

### Validátor NodeJS

Používá [libxmljs](https://github.com/polotek/libxmljs).

Neumí pracovat se vstupními soubory v jiném kódování než UTF-8. Mezi příklady jsou také vstupní soubory v kódování Windows-1250, ty nebudou validovány správně.

#### Instalace balíčků a spuštění

Na Windows platformě je nutné použít příznak `--msvs_version=VERZEVS`, který umožní kompilaci nativních částí použitých balíčků.
Předpokládá se spuštění v kořenovém adresáři daného validátoru.


```
npm install --msvs_version=2012
node index.js
```

### Validátor .NET

Validátor běží pod .NET 4.5 a používá XML funkčnost .NET frameworku.

#### Kompilace a spuštění

Lze zkompilovat ve Visual Studio 2015 nebo pomocí command-line nástrojů instalovaných s Visual Studio 2015, případně s .NET Framework prostředím a podobně.
Předpokládá se spuštění v kořenovém adresáři daného validátoru.


```
msbuild.exe XmlSchemaValidator.DotNet.sln /t:Rebuild /p:Configuration=Debug
pushd Bin\Debug
XmlSchemaValidator.DotNet.exe
popd
```

## Užitečný software, odkazy

- xs3p [JM verze](https://github.com/jmarsik/xs3p) | [přepracovaná verze](https://github.com/bitfehler/xs3p) | [původní verze](http://xml.fiforms.org/xs3p/)
  - generování dokumentace s dílčími diagramy
- [XSD Digram](http://regis.cosnier.free.fr/?page=XSDDiagram)
  - zobrazení diagramu a interaktivní procházení
  - generování diagramu
  - generování dokumentace s dílčími diagramy
- [XML Grid online validace](http://xmlgrid.net/validator.html)
  - validace XML zadaným XSD
- [XML Grid online vizualizace](http://xmlgrid.net/)
  - zobrazení diagramu a interaktivní procházení (v prohlížeči jako SVG)
- [WM Help XmlPad](http://www.wmhelp.com/)
  - editor, validátor
  - zobrazení diagramu a interaktivní procházení
  - generování dokumentace s dílčími diagramy
  - sice jde o starší SW, ale je zadarmo a umí toho poměrně hodně
- [XsdVi](http://xsdvi.sourceforge.net/)
  - zobrazení diagramu a interaktivní procházení (v prohlížeči jako SVG)

