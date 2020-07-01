import Bibliography
using Test

for file in ["test.bib"]
    test_import = Bibliography.import_bibtex("../examples/$file")
    println(typeof(test_import))
    for e in test_import
        println(e)
    end    
    println("publications: $(Bibliography.export_web(test_import))")
    println(Bibliography.export_bibtex("result.bib", test_import))
    rm("result.bib")
end
