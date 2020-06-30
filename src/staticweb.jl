function xtitle(entry::T) where T <: BibInternal.AbstractEntry
    return :title ∈ fieldnames(typeof(entry)) ? entry.title : get(entry.other, "title", "")
end

function xnames(entry::BibInternal.AbstractEntry, editors::Bool=false)
    if !editors && typeof(entry) ∈ [Proceedings]
        return xnames(entry, true)
    end
    names = editors ? entry.editor : entry.author
    str = ""
    start = true
    stop = 1
    for s in split(names, r"[\n\r ]and[\n\r ]")
        aux = split(s, r"[\n\r ],[\n\r ]")
        str *= start ? "" : ", "
        str *= aux[end]
        for t in aux[1:end - 1]
            str *= " " * t
        end
    end
    return str
end

# handle all entries
function xin(entry::BibInternal.AbstractEntry)
    fn = fieldnames(typeof(entry))
    str = ""
    if typeof(entry) == Article
        str *= entry.journal * ", " * entry.volume
        if entry.number != ""
            str *= "($(entry.number))"
        end
        if entry.pages != ""
            str *= ", " * entry.pages
        end
    elseif typeof(entry) == InProceedings
        str *= "Proceedings of the " * entry.booktitle
    end
    str *= str == "" ? "" : "."
    return str
end

function xyear(entry::BibInternal.AbstractEntry)
    return :year ∈ fieldnames(typeof(entry)) ? entry.year : get(entry.other, "year", "")
end

function xlink(entry::BibInternal.AbstractEntry)
    fn = fieldnames(typeof(entry))
    str = ""
    if :doi ∈ fn
        str = "https://doi.org/" * entry.doi
    elseif :url ∈ fn
        str = entry.url
    end
    return str
end

function xfile(entry::BibInternal.AbstractEntry)
    path = "files/$(entry.id).pdf"
    return isfile(path) ? path : ""
end

function xcite(entry::BibInternal.AbstractEntry)
    string(entry)
end

struct Publication
    type::AbstractString
    title::AbstractString
    names::AbstractString
    in::AbstractString
    year::AbstractString
    link::AbstractString
    file::AbstractString
    cite::AbstractString
end

function Publication(entry::T) where T <: BibInternal.AbstractEntry
    type = lowercase(string(T))
    title = xtitle(entry)
    names = xnames(entry)
    in_ = xin(entry)
    year = xyear(entry)
    link = xlink(entry)
    file = xfile(entry)
    cite = export_bibtex(entry)
    return Publication(type, title, names, in_, year, link, file, cite)
end

function publications(bibliography::Set{BibInternal.AbstractEntry})
    entries = Vector{Publication}()
    for entry in bibliography
        p = Publication(entry)
        push!(entries, p)
    end
    return entries
end
