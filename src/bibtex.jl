function import_bib(
    language::BibTeXLanguage,
    file::AbstractString
    )
    return BibParser.parsebibfile(file)[1]
end

function string(
    entry::BibInternal.Entry,
    language::BibTeXLanguage
    )
    str = "@" * string(entry.kind) * "{" * entry.key
    for key in BibInternal.fields
        if haskey(entry.fields, key)
            spaces = ""
            l = BibInternal.space(key)
            for i in 1:l
                spaces *= " "
            end
            str *= ",\n  " * string(key) * spaces * " = {" * entry.fields[key] * "}"
        end
    end
    str *= "\n}"
    return str
end

function export_bib(
    # entries::SortedBibliography,
    entries,
    language::BibTeXLanguage
    )
    str = ""
    for e in values(entries)
        str *= string(e, BibTeXLanguage()) * "\n"
    end
    return str[1:end - 1]
end
