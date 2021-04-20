const type_to_label = Dict{String, String}([
    "article"         => "journal",
    "book"            => "book",
    "booklet"         => "booklet",
    "eprint"          => "eprint",
    "inbook"          => "book chapter",
    "incollection"    => "book section",
    "inproceedings"   => "conference",
    "manual"          => "manual",
    "masterthesis"    => "master thesis",
    "misc"            => "other",
    "phdthesis"       => "doctoral thesis",
    "proceedings"     => "proceedings",
    "techreport"      => "report",
    "unpublished"     => "other"
])

function xtitle(entry::T) where T <: BibInternal.Entry
    return :title ∈ fieldnames(typeof(entry)) ? entry.title : get(entry.fields, "title", "")
end

function xnames(
    entry::BibInternal.Entry,
    editors::Bool=false;
    names::Symbol=:full # Current options: :last, :full
    )
    # forces the names to be editors' name if the entry are Proceedings
    if !editors && entry.type ∈ ["proceedings"]
        return xnames(entry, true)
    end
    entry_names = editors ? entry.editors : entry.authors
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
    # str *= editors ? ", editors" : ""
    return replace(str, r"[\n\r ]+" => " ") # TODO: make it cleaner (is replace still necessary)
end

function xin(entry::BibInternal.Entry)
    # @info "Entry type" entry entry.type
    str = ""
    if entry.type == "article"
        str *= entry.in.journal * ", " * entry.in.volume
        str *= entry.in.number != "" ? "($(entry.in.number))" : ""
        str *= entry.in.pages != "" ? ", $(entry.in.pages)" : ""
        str *= ", " * entry.date.year
    elseif entry.type == "book"
        str *= entry.in.publisher
        str *= entry.in.address != "" ? ", $(entry.in.address)" : ""
        str *= ", " * entry.date.year
    elseif entry.type == "booklet"
        str *= entry.access.howpublished * ", " * entry.date.year
    elseif entry.type == "eprint"
        if entry.eprint.archive_prefix == ""
            str *= entry.eprint.eprint
        else
            str *= "$(entry.eprint.archive_prefix):$(entry.eprint.eprint) [$(entry.eprint.primary_class)]"
        end
    elseif entry.type == "inbook"
        aux = entry.in.chapter == "" ? entry.in.pages : entry.in.chapter
        str *= entry.booktitle * ", " * aux * ", " * entry.in.publisher
        str *= entry.in.address != "" ? ", " * entry.in.address : ""
    elseif entry.type == "incollection"
        str = "In " * xnames(entry, true) * ", editors, " * entry.booktitle * ", " * entry.in.pages * "."
        str *= " " * entry.in.publisher
        str *= entry.in.address != "" ? ", $(entry.in.address)" : ""
        str *= ", " * entry.date.year
    elseif entry.type == "inproceedings"
        str *= " In " * entry.booktitle
        str *= entry.in.series != "" ? ", " * entry.in.series : ""
        str *= entry.in.pages != "" ? ", $(entry.in.pages)" : ""
        str *= entry.in.address != "" ? ", $(entry.in.address)" : ""
        str *= ", " * entry.date.year
        str *= entry.in.publisher != "" ? ". $(entry.in.publisher)" : ""
    elseif entry.type == "manual"
        str *= entry.in.organization
        str *= entry.in.address != "" ? ", $(entry.in.address)" : ""
        str *= ", " * entry.date.year
    elseif entry.type ∈ ["masterthesis", "phdthesis"]
        str *= entry.type == "masterthesis" ? "Master's" : "PhD"
        str *= " thesis, " * entry.in.school
        str *= entry.in.address != "" ? ", $(entry.in.address)" : ""
        str *= ", " * entry.date.year
    elseif entry.type == "misc"
        aux = entry.access.howpublished != "" != entry.date.year ? ", " : ""
        str *= entry.access.howpublished * aux * entry.date.year
        str *= aux != "" && get(entry.fields, "note", "") != "" ? ". " : ""
        str *= get(entry.fields, "note", "")
    elseif entry.type == "proceedings"
        str *= entry.in.volume != "" ? "Volume " * entry.in.volume * " of " : ""
        str *= entry.in.series
        str *= entry.in.address != "" ? ", $(entry.in.address)" : ""
        str *= ", " * entry.date.year
        str *= entry.in.publisher != "" ? ". $(entry.in.address)" : ""
    elseif entry.type == "techreport"
        str *= entry.in.number != "" ? "Technical Report " * entry.in.number * ", " : ""
        str *= entry.in.institution
        str *= entry.in.address != "" ? ", $(entry.in.address)" : ""
        str *= ", " * entry.date.year
    elseif entry.type == "unpublished"
        aux = get(entry.fields, "note", "")
        str *= aux != "" != entry.date.year ? aux * ", " : ""
        str *= entry.date.year
    end
    str *= str == "" ? "" : "."
    return str
end

function xyear(entry::BibInternal.Entry)
    return entry.date.year
end

function xlink(entry::BibInternal.Entry)
    if entry.access.doi != ""
        return "https://doi.org/" * entry.access.doi
    elseif entry.access.url != ""
        return entry.access.url
    end
    return ""
end

function xfile(entry::BibInternal.Entry)
    return "files/$(entry.id).pdf"
end

function xcite(entry::BibInternal.Entry)
    string(entry)
end

function xlabels(entry::BibInternal.Entry)
    str = get(entry.fields, "swp-labels", "")
    str = str == "" ? get(entry.fields, "labels", "") : str
    return str == "" ? [entry.type] : split(str, r"[\n\r ]*,[\n\r ]*")
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

function Publication(entry::BibInternal.Entry)
    # @info "New Publication for StaticWebPages" entry
    id = entry.id
    type = entry.type
    title = entry.title
    names = xnames(entry)
    in_ = xin(entry)
    year = xyear(entry)
    link = xlink(entry)
    file = xfile(entry)
    cite = export_bibtex(entry)
    labels = xlabels(entry)
    return Publication(id, type, title, names, in_, year, link, file, cite, labels)
end

"""
    export_web(bibliography::DataStructures.OrderedDict{String,BibInternal.Entry})
Export a biblography in internal format to the web format of the [StaticWebPages.jl](https://github.com/Azzaare/StaticWebPages.jl) pakcage.
"""
function export_web(
    bibliography::DataStructures.OrderedDict{String,BibInternal.Entry}
    )
    # @show values(bibliography)
    entries = Vector{Publication}()
    for entry in values(bibliography)
        p = Publication(entry)
        push!(entries, p)
    end
    return entries
end
