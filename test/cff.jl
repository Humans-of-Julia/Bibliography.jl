using Bibliography
using ReferenceTests

@testset "cff" begin
    bib = Bibliography.import_cff("../examples/CITATION.cff")
    rm("CITATION.cff", force=true)
    Bibliography.export_cff(bib)
    @test_reference "CITATION.cff.txt" read("CITATION.cff", String)
    rm("CITATION.cff")
end
