@testset "Code linting (JET.jl)" begin
    JET.test_package(Bibliography; target_defined_modules = true)
end
