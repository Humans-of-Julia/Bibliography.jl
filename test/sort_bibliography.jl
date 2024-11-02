module test_sort_bibliography

using Test
using Bibliography

# TODO: replace this sorting testbib with a full example bibliography like
#       https://github.com/plk/biblatex/tree/dev/bibtex/bib/biblatex
#       in order to have a more real life testing scenario (the results
#       could be adapted from
#       github.com/plk/biblatex/blob/dev/testfiles/19-alphabetic-prefixed.pdf
#       )

testbib = Bibliography.import_bibtex("../examples/test_sort.bib")

@testset "sort_bibliography! : Errors" begin
    @test_throws ArgumentError sort_bibliography!(testbib, :nnn)
    @test_throws MethodError sort_bibliography!(testbib, "nyt")
    @test_throws MethodError sort_bibliography!(testbib[testbib.keys[1]], :nyt)
end

result = ["1998BBaA1a"
          "1998BBbA2a"
          "2007JJaAbe"
          "2007JJbAbe"
          "2010JJBaAaa"
          "2010JJBbAaa"
          "2011JJBcAaa"
          "2018DJaMad"
          "2018DJaMae"
          "SaA3a2010"]
@testset "sort_bibliography! : Ordering: :key" begin
    sort_bibliography!(testbib)
    @test testbib.keys == result
    sort_bibliography!(testbib, :key)
    @test testbib.keys == result
end

result = ["2007JJbAbe"
          "2007JJaAbe"
          "2018DJaMae"
          "2018DJaMad"
          "2011JJBcAaa"
          "2010JJBaAaa"
          "2010JJBbAaa"
          "SaA3a2010"
          "1998BBbA2a"
          "1998BBaA1a"]
@testset "sort_bibliography! : Ordering: :nyt" begin
    sort_bibliography!(testbib, :nyt)
    @test testbib.keys == result
end

result = ["2007JJbAbe"
          "2007JJaAbe"
          "2018DJaMae"
          "2018DJaMad"
          "2011JJBcAaa"
          "2010JJBaAaa"
          "2010JJBbAaa"
          "SaA3a2010"
          "1998BBaA1a"
          "1998BBbA2a"]
@testset "sort_bibliography! : Ordering: :nty" begin
    sort_bibliography!(testbib, :nty)
    @test testbib.keys == result
end

result = ["2007JJbAbe"
          "2007JJaAbe"
          "2018DJaMae"
          "2018DJaMad"
          "2011JJBcAaa"
          "2010JJBaAaa"
          "2010JJBbAaa"
          "SaA3a2010"
          "1998BBaA1a"
          "1998BBbA2a"]
@testset "sort_bibliography! : Ordering: :y" begin
    sort_bibliography!(testbib, :nty)
    @test testbib.keys == result
end

end # module test_sort_bibliography
