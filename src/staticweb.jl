function xtype(entry::BibInternal.AbstractEntry)
    str = "other"
    if typeof(entry) == Article
        str = "journal"
    elseif typeof(entry) == InProceedings
        str = "conference"
    end
    return str
end

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
        aux = split(s, r"[\n\r ]*,[\n\r ]*")
        str *= start ? "" : ", "
        start = false
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
    elseif typeof(entry) == InBook
        str *= get(entry.other, "booktitle", "")
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
    elseif "doi" == keys(entry.other)
        str = "https://doi.org/" * entry.other["doi"]
    elseif :url ∈ fn
        str = entry.url
    elseif "url" == keys(entry.other)
        str = entry.other["url"]
    end
    return str
end

function xfile(entry::BibInternal.AbstractEntry)
    return "files/$(entry.id).pdf"
end

function xcite(entry::BibInternal.AbstractEntry)
    string(entry)
end

function xlabels(entry::BibInternal.AbstractEntry)
    str = get(entry.other, "labels", "")
    return split(str, r"[\n\r ]*,[\n\r ]*")
end

struct Publication
    id::AbstractString
    type::AbstractString
    title::AbstractString
    names::AbstractString
    in::AbstractString
    year::AbstractString
    link::AbstractString
    file::AbstractString
    cite::AbstractString
    labels::Vector{AbstractString}
end

function Publication(entry::T) where T <: BibInternal.AbstractEntry
    id = entry.id
    type = xtype(entry)
    title = xtitle(entry)
    names = xnames(entry)
    in_ = xin(entry)
    year = xyear(entry)
    link = xlink(entry)
    file = xfile(entry)
    cite = export_bibtex(entry)
    labels = xlabels(entry)
    return Publication(id, type, title, names, in_, year, link, file, cite, labels)
end

function export_web(bibliography::DataStructures.OrderedSet{BibInternal.AbstractEntry})
    entries = Vector{Publication}()
    for entry in bibliography
        p = Publication(entry)
        push!(entries, p)
    end
    return entries
end
