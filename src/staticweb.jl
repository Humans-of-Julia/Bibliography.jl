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

struct BibtexName  
    particle::String
    last::String
    junior::String
    first::String
    middle::String  
end

function string_to_bibtex_name(str::String)
    subnames = split(str, r"[\n\r ]*,[\n\r ]*")
    # for s in subnames
    #     println("s = $s")
    # end
    
    # subnames containers
    first::String = ""
    middle::String = ""
    particle::String = ""
    last::String = ""
    junior::String = ""

    # mark for string parsing
    mark_in = 1
    mark_out = 0

    # BibTeX form 1: First Second von Last
    if length(subnames) == 1
        aux = split(subnames[1], r"[\n\r ]+")
        mark_out = length(aux) - 1
        last = aux[end]
        if length(aux) > 1 && isuppercase(aux[1][1])
            first = aux[1]
            for s in aux[2:end-1]
                mark_in += 1
                if islowercase(s[1])
                    break;
                end
                middle *= " $s"
            end
            for s in reverse(aux[mark_in:mark_out])
                if islowercase(s[1])
                    break;
                end
                mark_out -= 1
                last = "$s " * last
            end
            for s in aux[mark_in:mark_out]
                particle *= " $s"
            end
        end
    end
    # BibTeX form 2: von Last, First Second
    if length(subnames) == 2
        aux = split(subnames[1], r"[\n\r ]+") # von Last
        mark_out = length(aux) - 1
        last = string(aux[end])
        for s in reverse(aux[1:mark_out])
            if islowercase(s[1])
                break;
            end
            mark_out -= 1
            last = "$s " * last
        end
        for s in aux[1:mark_out]
            particle *= " $s"
        end
        aux = split(subnames[2], r"[\n\r ]+")
        # println("aux = $aux")
        first = aux[1]
        if length(aux) > 1
            for s in aux[2:end]
                middle *= " $s"
            end
        end
    end
    if length(subnames) == 3
        aux = split(subnames[1], r"[\n\r ]+") # von Last
        mark_out = length(aux) - 1
        last = aux[end]
        for s in reverse(aux[1:mark_out])
            if islowercase(s[1])
                break;
            end
            mark_out -= 1
            last = "$s " * last
        end
        for s in aux[1:mark_out]
            particle *= " $s"
        end
        junior = subnames[2]
        aux =split(subnames[3], r"[\n\r ]+")
        first = aux[1]
        if length(aux) > 1
            for s in aux[2:end]
                middle *= " $s"
            end
        end
    end

    # for t in map(typeof, [particle, last, junior, first, middle])
    #     println("type = $t")
    # end
    return BibtexName(particle, last, junior, first, middle)
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
    names = editors ? entry.editor : entry.author
    str = ""

    split_names = split(names, r"[\n\r ]and[\n\r ]")
    start = true
    for s in split_names
        bib = string_to_bibtex_name(String(s))
        str *= start ? "" : ", "
        start = false
        if names == :last
            str *= bib.particle * " " * bib.last * " " * bib.junior
        else
            str *= bib.first * " " * bib.middle * " " * bib.particle * " " * bib.last * " " * bib.junior
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
