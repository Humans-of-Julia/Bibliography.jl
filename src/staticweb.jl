const type_to_label = Dict{String, String}([
    "article"         => "journal",
    "book"            => "book",
    "booklet"         => "booklet",
    "eprint"          => "eprint",
    "inbook"          => "book chapter",
    "incollection"    => "book section",
    "inproceedings"   => "conference",
    "manual"          => "manual",
    "mastersthesis"   => "master's thesis",
    "misc"            => "other",
    "phdthesis"       => "doctoral thesis",
    "proceedings"     => "proceedings",
    "techreport"      => "report",
    "unpublished"     => "other"
])

"""
    xtitle(entry

Format the title of an `Entry` for web export.
"""
function xtitle(entry)
    return :title ∈ fieldnames(typeof(entry)) ? entry.title : get(entry.fields, "title", "")
end

"""
    xnames(entry, editors = false; names = :full)

Format the name of an `Entry` for web export.

# Arguments:
- `entry`: an entry
- `editors`: `true` if the name describes editors
- `names`: :full (full names) or :last (last names + first name abbreviation)
"""
function xnames(
    entry,
    editors=false;
    names=:full # Current options: :last, :full
    )
    # forces the names to be editors' name if the entry are Proceedings
    if !editors && entry.type ∈ ["proceedings"]
        return xnames(entry, true)
    end
    entry_names = editors ? entry.editors : entry.authors

    if names == :last
        parts = map(s -> [ s.particle, s.last, s.junior ], entry_names)
    else
        parts = map(s -> [ s.first, s.middle, s.particle, s.last, s.junior ], entry_names)
    end

    entry_names = map(parts) do s
        return join(filter(!isempty, s), " ")
    end
    str = join(entry_names, ", ")
    return replace(str, r"[\n\r ]+" => " ") # TODO: make it cleaner (is replace still necessary)
end

"""
    xin(entry)

Format the appears-`in` field of an `Entry` for web export.
"""
function xin(entry)
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
    elseif entry.type ∈ ["mastersthesis", "phdthesis"]
        str *= entry.type == "mastersthesis" ? "Master's" : "PhD"
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

"""
    xyear(entry)

Format the year of an `Entry` for web export.
"""
xyear(entry) = entry.date.year

"""
    xlink(entry)

Format the download link of an `Entry` for web export.
"""
function xlink(entry)
    if entry.access.doi != ""
        return "https://doi.org/" * entry.access.doi
    elseif entry.access.url != ""
        return entry.access.url
    end
    return ""
end

"""
    xfile(entry)

Format the downloadable path of an `Entry` file for web export.
"""
xfile(entry) = "files/$(entry.id).pdf"

"""
    xcite(entry)

Format the BibTeX cite output of an `Entry` for web export.
"""
xcite(entry) = string(entry)

"""
    xlabels(entry)

Format the labels of an `Entry` for web export.
"""
function xlabels(entry)
    str = get(entry.fields, "swp-labels", "")
    str = str == "" ? get(entry.fields, "labels", "") : str
    return str == "" ? [entry.type] : split(str, r"[\n\r ]*,[\n\r ]*")
end

"""
    Publication

A structure to store all the information necessary to web export.
"""
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

"""
    Publication(entry)

Construct a `Publication` (compatible with web export) from an `Entry`.
"""
function Publication(entry)
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
Export a biblography in internal format to the web format of the [StaticWebPages.jl](https://github.com/Humans-of-Julia/StaticWebPages.jl) pakcage. Also used by [DocumenterCitations.jl](https://github.com/ali-ramadhan/DocumenterCitations.jl).
"""
function export_web(bibliography)
    entries = Vector{Publication}()
    for entry in values(bibliography)
        p = Publication(entry)
        push!(entries, p)
    end
    return entries
end
