module Bibliography

# BibInternal
import BibInternal
import BibInternal: AbstractEntry
import BibInternal.BibTeX: Article, Book, Booklet, InBook, InCollection, InProceedings, Manual, MasterThesis, Misc, PhDThesis, Proceedings, TechReport, Unpublished, BibtexName

# BibParser
import BibParser, BibParser.BibTeX

# Others
import DataStructures
import DataStructures.OrderedSet

export export_bibtex, import_bibtex
export export_web, bibtex_to_web

include("bibtex.jl")
include("staticweb.jl")

function export_bibtex(target::String, bibliography::DataStructures.OrderedDict{String,AbstractEntry})
    data = export_bibtex(bibliography)
    if target != ""
        f = open(target, "w")
        write(f, data)
        close(f)
    end
    return data
end

function bibtex_to_web(source::String)
    export_web(import_bibtex(source))
end

end # module
