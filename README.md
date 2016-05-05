# Rozhraní dodacích listů Lekis XML

XML schéma, příklady, validátor

## XML schéma (XSD)

[RozhraniDL-Lekis-XML.xsd](Schema/RozhraniDL-Lekis-XML.xsd)

## Příklady

Několik příkladů je k dispozici v adresáři [Examples](Examples).

Jsou rozdělené na korektní (Good) a nekorektní (Bad), které neprojdou (a nemají projít) validací pomocí výše uvedeného XSD souboru.

## Validátory

Jde o velmi základní validátory příkladových XML souborů, zda odpovídají danému XML schématu. Oba validátory mají v sobě zadané pevné cesty a jsou tedy spustitelné pouze v rámci adresářové struktury tohoto repository. Další omezení validátorů jsou popsána níže.

## Validátor NodeJS

Používá [libxmljs](https://github.com/polotek/libxmljs).

Neumí pracovat se vstupními soubory v jiném kódování než UTF-8. Mezi příklady jsou také vstupní soubory v kódování Windows-1250, ty nebudou validovány správně.

### Instalace balíčků a spuštění

Na Windows platformě je nutné použít příznak `--msvs_version=VERZEVS`, který umožní kompilaci nativních částí použitých balíčků.

```
npm install --msvs_version=2012
node index.js
```

## Validátor .NET

Lze zkompilovat ve Visual Studio 2015, běží pod .NET 4.5.2.
