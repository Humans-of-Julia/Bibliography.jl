module Bibliography

# BibInternal
import BibInternal
import BibInternal: AbstractEntry, Entry

# BibParser
import BibParser, BibParser.BibTeX

# Others
import DataStructures
import DataStructures.OrderedSet

export export_bibtex, import_bibtex
export export_web, bibtex_to_web
export select

include("select.jl")
include("bibtex.jl")
include("csl.jl")
include("staticweb.jl")

"""
    export_bibtex(e::Entry)
    export_bibtex(bibliography::DataStructures.OrderedDict{String,Entry})
    export_bibtex(target::String, bibliography::DataStructures.OrderedDict{String,Entry})
Export an entry or a bibliography to BibTeX format.
"""
function export_bibtex(target::String, bibliography::DataStructures.OrderedDict{String,Entry})
    data = export_bibtex(bibliography)
    if target != ""
        f = open(target, "w")
        write(f, data)
        close(f)
    end
    return data
end

"""
    bibtex_to_web(source::String)
Convert a BibTeX file to a web compatible format, specifically for the [StaticWebPages.jl](https://github.com/Azzaare/StaticWebPages.jl) package.
"""
function bibtex_to_web(source::String)
    export_web(import_bibtex(source))
end

end # module
