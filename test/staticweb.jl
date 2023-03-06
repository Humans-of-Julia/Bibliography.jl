using ReferenceTests

@testset "staticweb helpers" for file in ["test.bib"] #, "xampl.bib"] #, "ignace_ref.bib"]
    bib = Bibliography.import_bibtex("../examples/$file")
    for names in [:full, :last, :lastonly]
        result = ""
        and = (names == :full)
        for (key, val) in bib
            result *= """
                key: $(key)
                title: '$(Bibliography.xtitle(val))'
                names: '$(Bibliography.xnames(val; names=names, and=and))'
                    in: '$(Bibliography.xin(val))'
                year: '$(Bibliography.xyear(val))'
                link: '$(Bibliography.xlink(val))'
                file: '$(Bibliography.xfile(val))'

                """
        end
        @test_reference "$file-$names.txt" result
    end
end
