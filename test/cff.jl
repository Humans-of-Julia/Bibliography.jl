using Bibliography
using ReferenceTests

@testset "cff" begin
    bib = Bibliography.import_cff("../examples/CITATION.cff")
    rm("CITATION.cff", force=true)
    Bibliography.export_cff(bib)
    # TODO - generate a test file for 32 bits architecture
    if Sys.WORD_SIZE == 64
        @test_reference "CITATION.cff.txt" read("CITATION.cff", String)
    end
    rm("CITATION.cff")
end
