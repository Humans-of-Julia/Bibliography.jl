@testset "FileIO interface functions." begin
    F = FileIO.File{FileIO.format"BIB"}
    S = FileIO.Stream{FileIO.format"BIB"}

    # Load, export and reload as file.
    let
        bib = Bibliography.fileio_load(F("test.bib"))
        Bibliography.fileio_save(F("test-fileio.bib"), bib)
        bib2 = Bibliography.fileio_load(F("test-fileio.bib"))
        @test_broken bib == bib2
        rm("test-fileio.bib")
    end

    # Load, export and reload as stream.
    let
        bib = open("test.bib") do f
            Bibliography.fileio_load(S(f))
        end
        open("test-fileio.bib", "w") do f
            Bibliography.fileio_save(S(f), bib)
        end
        bib2 = open("test-fileio.bib") do f
            Bibliography.fileio_load(S(f))
        end
        @test_broken bib == bib2
        rm("test-fileio.bib")
    end
end