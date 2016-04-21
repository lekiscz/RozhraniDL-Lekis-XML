var async = require('async');
var fs = require('fs');
var glob = require("glob");
var libxml = require("libxmljs");

// inicializace pole dostupnych schemat, temi budeme pak validovat vsechny nalezene prikladove dokumenty
var xsdDocs = [];

function loadSchemas(callback) {
    glob("../../Schema/**/*.xsd", null, function (er, files) {
        async.eachSeries(
            files,
            function (file, notifyItemDoneCallback) {
                console.log('Schema: ' + file);
                fs.readFile(file, function (err, dataxsd) {
                    if (err) {
                        console.log('Schema: ' + file + ' ... NOT loaded');
                        console.log(err);
                        // nezpracovava dale aktualne zpracovavany soubor; jelikoz jde o anonymni funkci pro zpracovani jedne polozky seznamu,
                        //  tak se pokracuje zpracovanim dalsich souboru
                        notifyItemDoneCallback();
                        return;
                    };

                    var xsdDoc = libxml.parseXml(dataxsd);
                    if (xsdDoc != null) {
                        console.log('Schema: ' + file + ' ... loaded');
                        // ulozi nactene schema do kolekce pro pozdejsi praci, klicem je relativni cesta k souboru
                        xsdDocs[file] = xsdDoc;
                    } else {
                        console.log('Schema: ' + file + ' ... NOT loaded');
                    }

                    notifyItemDoneCallback();
                });
            },
            function (err) {
                console.log();
                callback(err);
            });
    });
}

function validate(xmlname, notifyItemDoneCallback) {
    console.log();
    console.log();
    console.log('==================================================');

    fs.readFile(xmlname, function (err, dataxml) {
        if (err) {
            console.log('File: ' + xmlname + ' ... NOT loaded');
            console.log(err);
        } else {
            console.log('File: ' + xmlname + ' ... loaded');
        }

        console.log('==================================================');

        try
        {
            var xmlDoc = libxml.parseXml(dataxml);

            async.eachSeries(Object.keys(xsdDocs), function (xsdKey, notifyItemDoneCallback) {
                console.log();
                console.log();
                console.log('==================================================');
                console.log('File: ' + xmlname);
                console.log('Schema: ' + xsdKey);
                console.log();
                console.log(xmlDoc.validate(xsdDocs[xsdKey]));
                console.log();
                console.log(xmlDoc.validationErrors
                    .map(function (item) {
                        return item.toString();
                        return JSON.stringify(item, null, "  ");
                    })
                    .join("\n"));
                notifyItemDoneCallback();
            });
        } catch (ex) {
            // v pripade chyby pri parsovani XML souboru nebo pri validaci XSD schematem
            //  pokracuje na dalsi XML soubor (zbyle XSD soubory uz nezkousi v pripade
            //  chyby pri validaci nekterym z nich)
            // libxmljs neumi pracovat s XML soubory ve Windows-1250 kodovani, pri jejich
            //  zpracovani se take vyskytne vyjimka
            console.log('File: ' + xmlname + ' ... NOT parsed');
            console.log(ex);
        }

        notifyItemDoneCallback();
    });
}

function validateAll(xmlglobpattern, callback) {
    glob(xmlglobpattern, null, function (er, files) {
        async.eachSeries(
            files,
            function (file, notifyItemDoneCallback) {
                validate(file, notifyItemDoneCallback);
            },
            function (err) {
                callback(err);
            });
    });
}

async.series([
    function (callback) { loadSchemas(callback); },
    function (callback) { validateAll("../../Examples/**/*.xml", callback); }
]);
