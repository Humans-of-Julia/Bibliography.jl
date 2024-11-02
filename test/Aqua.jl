@testset "Aqua.jl" begin
    # TODO: Fix the broken tests and remove the `broken = true` flag
    Aqua.test_all(
        Bibliography;
        ambiguities = (broken = false,),
        deps_compat = false,
        piracies = (broken = false,)
    )

    @testset "Ambiguities: Bibliography" begin
        Aqua.test_ambiguities(Bibliography;)
    end

    @testset "Piracies: Bibliography" begin
        Aqua.test_piracies(Bibliography;)
    end

    @testset "Dependencies compatibility (no extras)" begin
        Aqua.test_deps_compat(
            Bibliography;
            check_extras = false            # ignore = [:Random]
        )
    end
end
