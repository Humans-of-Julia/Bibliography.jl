import Bibliography
using Test

for file in ["test.bib" , "test2.bib"]
    test_import = Bibliography.import_bibtex("../examples/$file")
    for e in test_import
        println(e)
    end    
    println("publications: $(Bibliography.publications(test_import))")
    println(Bibliography.export_bibtex("result.bib", test_import))
end
