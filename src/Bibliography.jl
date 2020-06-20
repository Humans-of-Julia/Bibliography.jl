module Bibliography

import Base.string,
       BibInternal,
       BibParser,
       DataStructures

export export_bib,
       import_bib

# SortedBibliography = DataStructures.SortedDict{Int,BibInternal.Entry}

abstract type AbstractLanguage end
struct BibTeXLanguage <: AbstractLanguage end
include("bibtex.jl")

function import_bib(
    file::AbstractString;
    language::AbstractLanguage=BibTeXLanguage()
    )
    return import_bib(language, file)
end

function string(
    entry::BibInternal.Entry;
    language::AbstractLanguage=BibTeXLanguage()
    )
    return string(entry, language)
end

function export_bib(
    entries; # TODO: Supertype of iterable objects ?
    language::AbstractLanguage=BibTeXLanguage(),
    target::AbstractString=""
    )
    data = export_bib(entries, language)
    if target != ""
        f = open(target, "w")
        write(f, data)
        close(f)
    end
    return data
end

end # module
