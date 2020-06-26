using Bibliography
using Test

for file in ["test.bib", "test2.bib"]
    test_import = import_bib("../examples/$file")
    for e in test_import
        println(e)
    end
    println(export_bib(test_import; target="result.bib"))
end
