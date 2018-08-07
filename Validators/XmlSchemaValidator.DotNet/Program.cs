using System;
using System.CodeDom.Compiler;
using System.IO;
using System.Linq;
using System.Xml.Linq;
using System.Xml.Schema;

namespace XmlSchemaValidator.DotNet
{
    class Program
    {
        public static void Main(string[] args)
        {
            using (var tw = new IndentedTextWriter(Console.Out))
            {
                var schemaDir = @"..\..\..\..\Schema";
                var xmlDir = @"..\..\..\..\Examples";

                var schemaDirResolved = Path.GetFullPath(Path.Combine(Directory.GetCurrentDirectory(), schemaDir));
                var xmlDirResolved = Path.GetFullPath(Path.Combine(Directory.GetCurrentDirectory(), xmlDir));

                var schemaFiles = Directory.EnumerateFiles(schemaDirResolved, "*.xsd", SearchOption.AllDirectories);
                var schemas = schemaFiles.Select(
                    schemaFile =>
                    {
                        var ss = new XmlSchemaSet();
                        ss.Add("", schemaFile);
                        return new
                        {
                            SchemaFile = schemaFile,
                            SchemaSet = ss,
                        };
                    });

                foreach (var schema in schemas)
                {
                    // pro kazde schema bere prikladove soubory z adresare pojmenovaneho podle schematu
                    var xmlFiles = Directory.EnumerateFiles(Path.Combine(xmlDirResolved, Path.GetFileNameWithoutExtension(schema.SchemaFile)), "*.xml", SearchOption.AllDirectories);
                    foreach (var file in xmlFiles)
                    {
                        var s1 = "File: " + file.Replace(xmlDirResolved + Path.DirectorySeparatorChar, "")
                                     .Replace(Path.DirectorySeparatorChar.ToString(),
                                         " " + Path.DirectorySeparatorChar + " ");
                        var s2 = "".PadLeft(s1.Length + 1, '=');
                        tw.WriteLine(s2 + @"\");
                        tw.WriteLine(s1 + " |");
                        tw.WriteLine(s2 + @"/");
                        tw.WriteLine();

                        var oldIndent = tw.Indent;
                        tw.Indent++;

                        XDocument xmlDoc;

                        try
                        {
                            xmlDoc = XDocument.Load(file);

                            tw.WriteLine("XML loaded");
                            tw.WriteLine();

                            var ok = true;

                            tw.WriteLine("Schema: {0}", schema.SchemaFile.Replace(schemaDirResolved + Path.DirectorySeparatorChar, "").Replace(Path.DirectorySeparatorChar.ToString(), " " + Path.DirectorySeparatorChar + " "));
                            tw.WriteLine();

                            tw.Indent++;

                            xmlDoc.Validate(
                                schema.SchemaSet,
                                (sender, eventArgs) =>
                                {
                                    if (eventArgs.Severity == XmlSeverityType.Error) ok = false;

                                    tw.WriteLine(eventArgs.Severity.ToString() + ": " + eventArgs.Message);
                                    tw.WriteLine();
                                });

                            tw.WriteLine(ok ? "Validation OK" : "Validation NOT OK");
                            tw.WriteLine();
                        }
                        catch (Exception ex)
                        {
                            // vyjimku pri nacitani XML nebo validaci pomoci XSD vypiseme a pokracujeme dalsim XML
                            tw.WriteLine("Exception occured! Will continue with next XML file.");
                            tw.WriteLine();
                            tw.WriteLine(ex);
                            tw.WriteLine();
                        }

                        tw.Indent = oldIndent;
                    }
                }
            }
        }
    }
}
