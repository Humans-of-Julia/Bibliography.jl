using Bibliography

using Aqua
using ExplicitImports
using JET
using Test
using TestItemRunner

@testset "Package tests: Bibliography" begin
    include("internal.jl")
    include("Aqua.jl")
    include("ExplicitImports.jl")
    include("JET.jl")
    include("TestItemRunner.jl")
end
