import Bibliography
using Test

for file in ["test.bib"]
    test_import = Bibliography.import_bibtex("../examples/$file")
    selection = ["CitekeyArticle", "CitekeyBook"]
    test_select = Bibliography.select(test_import, selection)
    Bibliography.export_web(test_import)
    println("Test import\n $(Bibliography.export_bibtex("result.bib", test_import))\n")
    println("Test select\n $(Bibliography.export_bibtex("result.bib", test_select))\n")
    rm("result.bib")
end
