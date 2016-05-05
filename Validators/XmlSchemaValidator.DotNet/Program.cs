using System;
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
            var schemaDir = @"..\..\..\..\Schema";
            var xmlDir = @"..\..\..\..\Examples";

            var schemaFiles = Directory.EnumerateFiles(Path.Combine(Directory.GetCurrentDirectory(), schemaDir), "*.xsd", SearchOption.AllDirectories);
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

            var xmlFiles = Directory.EnumerateFiles(Path.Combine(Directory.GetCurrentDirectory(), xmlDir), "*.xml", SearchOption.AllDirectories);
            foreach (var file in xmlFiles)
            {
                Console.WriteLine();
                Console.WriteLine();
                var s1 = "File: " + Path.GetFileName(file);
                var s2 = "".PadLeft(s1.Length + 1, '=');
                Console.WriteLine(s2 + @"\");
                Console.WriteLine(s1 + " |");
                Console.WriteLine(s2 + @"/");
                Console.WriteLine();
                Console.WriteLine();
                Console.WriteLine("".PadLeft(80, '='));

                XDocument xmlDoc;
                try
                {
                    xmlDoc = XDocument.Load(file);

                    foreach (var schema in schemas)
                    {
                        Console.WriteLine();
                        Console.WriteLine(s1);
                        Console.WriteLine("Schema: {0}", Path.GetFileName(schema.SchemaFile));
                        Console.WriteLine();

                        xmlDoc.Validate(schema.SchemaSet,
                            (sender, eventArgs) =>
                            {
                                Console.WriteLine(eventArgs.Message);
                                Console.WriteLine();
                            });

                        Console.WriteLine("".PadLeft(80, '='));
                    }
                }
                catch (Exception ex)
                {
                    // vyjimku pri nacitani XML nebo validaci pomoci XSD vypiseme a pokracujeme dalsim XML
                    Console.Error.WriteLine(ex.ToString());
                }
            }
        }
    }
}
