import Bibliography
using Test

for file in ["test.bib"] #, "xampl.bib"] #, "ignace_ref.bib"]
    test_import = Bibliography.import_bibtex("../examples/$file")
    # @info "test_import" test_import
    Bibliography.export_web(test_import)
    println("Test import\n $(Bibliography.export_bibtex("result.bib", test_import))\n")

    if file == "test.bib"
        selection = ["CitekeyArticle", "CitekeyBook"]
        test_select = Bibliography.select(test_import, selection)
        println("Test select\n $(Bibliography.export_bibtex("result.bib", test_select))\n")
    end

    rm("result.bib")
end

testdata = """@inproceedings{demo2020proceedings,
 organization  = {DemoOrg},
 pages         = {1--10},
 doi           = {10.1000/001-1-001-00001-1_001},
 author        = {Demo, D},
 note          = {cited by 0},
 year          = {2020},
 booktitle     = {Demo Booktitle},
 title         = {Demo Title}
}"""

write("demo.bib",testdata)
mybib = Bibliography.import_bibtex("demo.bib")
Bibliography.export_bibtex("demo_export.bib",mybib)
mybib2 = Bibliography.import_bibtex("demo_export.bib")

rm("demo.bib")
rm("demo_export.bib")

include("sort_bibliography.jl")
