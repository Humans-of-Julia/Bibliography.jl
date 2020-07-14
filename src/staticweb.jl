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
    return :title ∈ fieldnames(typeof(entry)) ? entry.title : get(entry.fields, "title", "")
end

function xnames(
    entry::BibInternal.AbstractEntry,
    editors::Bool=false;
    names::Symbol=:full # Current options: :last, :full
    )
    # forces the names to be editors' name if the entry are Proceedings
    if !editors && typeof(entry) ∈ [Proceedings]
        return xnames(entry, true)
    end
    entry_names = editors ? entry.editor : entry.author
    str = ""

    start = true
    for s in entry_names
        str *= start ? "" : ", "
        start = false
        if names == :last
            str *= s.particle * " " * s.last * " " * s.junior
        else
            str *= s.first * " " * s.middle * " " * s.particle * " " * s.last * " " * s.junior
        end
    end
    return replace(str, r"[\n\r ]+" => " ") # TODO: hack for extra space char, make it cleaner
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
        str *= get(entry.fields, "booktitle", "")
    end
    str *= str == "" ? "" : "."
    return str
end

function xyear(entry::BibInternal.AbstractEntry)
    return :year ∈ fieldnames(typeof(entry)) ? entry.year : get(entry.fields, "year", "")
end

function xlink(entry::BibInternal.AbstractEntry)
    fn = fieldnames(typeof(entry))
    str = ""
    if :doi ∈ fn
        str = "https://doi.org/" * entry.doi
    elseif "doi" ∈ keys(entry.fields)
        str = "https://doi.org/" * entry.fields["doi"]
    elseif :url ∈ fn
        str = entry.url
    elseif "url" ∈ keys(entry.fields)
        str = entry.fields["url"]
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
    str = get(entry.fields, "labels", "")
    return split(str, r"[\n\r ]*,[\n\r ]*")
end

struct Publication
    id::String
    type::String
    title::String
    names::String
    in::String
    year::String
    link::String
    file::String
    cite::String
    labels::Vector{String}
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

function export_web(bibliography::DataStructures.OrderedDict{String,BibInternal.AbstractEntry})
    entries = Vector{Publication}()
    for entry in values(bibliography)
        p = Publication(entry)
        push!(entries, p)
    end
    return entries
end
