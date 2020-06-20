using Bibliography
using Test

test_import = import_bib("../examples/test.bib")
for e in test_import
    println(e)
end
println(export_bib(test_import; target="result.bib"))
