var async = require('async');
var fs = require('fs');
var glob = require("glob");
var libxml = require("libxmljs2");
var path = require("path");

// inicializace pole dostupnych schemat, temi budeme pak validovat vsechny nalezene prikladove dokumenty
var xsdDocs = [];

function loadSchemas(callback) {
    glob("../../Schema/**/*.xsd", null, function(er, files) {
        async.eachSeries(
            files,
            function iteratee(file, notifyItemDoneCallback) {
                console.log('==================================================');
                console.log('Schema: ' + file);
                console.log('==================================================');
                console.log();

                fs.readFile(file, function(err, dataxsd) {
                    if (err) {
                        console.log('    ' + 'NOT loaded');
                        console.log();
                        console.log('    ' + err);
                        console.log();

                        // nezpracovava dale aktualne zpracovavany soubor; jelikoz jde o anonymni funkci pro zpracovani jedne polozky seznamu,
                        //  tak se pokracuje zpracovanim dalsich souboru
                        notifyItemDoneCallback();

                        return;
                    };

                    var xsdDoc = libxml.parseXml(dataxsd);
                    if (xsdDoc != null) {
                        console.log('    ' + 'Loaded');
                        console.log();

                        // ulozi nactene schema do kolekce pro pozdejsi praci, klicem je relativni cesta k souboru
                        xsdDocs[file] = xsdDoc;
                    } else {
                        console.log('    ' + 'NOT loaded');
                        console.log();
                    }

                    notifyItemDoneCallback();
                });
            },
            function done(err) {
                callback(err);
            });
    });
}

function validate(xmlname, xsdKey, callback) {
    console.log('==================================================');
    console.log('File: ' + xmlname);
    console.log('==================================================');
    console.log();

    fs.readFile(xmlname, function(err, dataxml) {
        if (err) {
            console.log('    ' + 'XML text NOT loaded');
            console.log();
            console.log('    ' + err);
        } else {
            console.log('    ' + 'XML text loaded');
        }
        console.log();

        try {
            var xmlDoc = libxml.parseXml(dataxml);

            console.log('    ' + 'XML loaded');
            console.log();

            console.log('    ' + 'Schema: ' + xsdKey);
            console.log();

            var ok = xmlDoc.validate(xsdDocs[xsdKey]);

            if (xmlDoc.validationErrors.length > 0) {
                console.log(
                    xmlDoc.validationErrors
                    .map(function(item) {
                        return '    ' + '    ' + item.toString().trim() + "\n" +
                            '    ' + '    ' + JSON.stringify(item);
                    })
                    .join("\n\n")
                );
                console.log();
            }

            console.log('    ' + '    ' + (ok ? 'Validation OK' : 'Validation NOT OK'));
            console.log();
            
            callback(false);
        } catch (ex) {
            // v pripade chyby pri parsovani XML souboru nebo pri validaci XSD schematem
            //  pokracuje na dalsi XML soubor (zbyle XSD soubory uz nezkousi v pripade
            //  chyby pri validaci nekterym z nich)
            // libxmljs neumi pracovat s XML soubory ve Windows-1250 kodovani, pri jejich
            //  zpracovani se take vyskytne vyjimka
            console.log('    ' + 'Exception occured! Will continue with next XML file.');
            console.log();
            console.log('    ' + ex);

            // chybu neoznami vyse, aby se pokracovalo s dalsim XML souborem
            callback(false);
        }
    });
}

function validateAll(xmlglobpattern, xsdKey, callback) {
    glob(xmlglobpattern, null, function(er, files) {
        async.eachSeries(
            files,
            function iteratee(file, notifyItemDoneCallback) {
                validate(file, xsdKey, notifyItemDoneCallback);
            },
            function done(err) {
                callback(err);
            });
    });
}

async.series([
    function(callback) { loadSchemas(callback); },
    function(callback) {
        async.eachSeries(
            Object.keys(xsdDocs),
            function iteratee(xsdKey, notifyItemDoneCallback) {
                var schemaBaseName = path.basename(xsdKey, '.xsd');
                // pro kazde schema bere prikladove soubory z adresare pojmenovaneho podle schematu
                validateAll("../../Examples/" + schemaBaseName + "/**/*.xml", xsdKey, notifyItemDoneCallback);
            },
            function done(err) {
                callback(err);
            });
    }
]);