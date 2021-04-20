"""
    import_bibtex(file::String)
Import a BibTeX file and convert it to the internal bibliography format.
"""
function import_bibtex(file::String)
    return BibParser.parse_file(file)
end

function int_to_spaces(n::Int)
    str = ""
    for i in 1:n
        str *= " "
    end
    return str
end

# Dictionnary to handle spaces while exporting BibTeX
const spaces = Dict{String,String}(map(
    s -> (string(s) => int_to_spaces(BibInternal.space(s))),
    BibInternal.fields)
)

# Function to write required fields
function field_to_bibtex(
    key::String,
    value::String
    )
    space = get(spaces, key, int_to_spaces(BibInternal.space(Symbol(key))))
    swp = length(key) > 3 && key[1:3] == "swp"
    o,f = isnothing(match(r"@", value)) ? ('{','}') : ('"','"')
    return value == "" || swp ? "" : " $key$space = $o$value$f,\n"
end

function name_to_string(name::BibInternal.Name)
    str = "$(name.particle)"
    if str != "" != name.last
        str *= " "
    end
    str *= name.last
    str *= name.junior == "" ? "" : ", $(name.junior)"
    if name.first != ""
        str *= ", $(name.first)"
    end
    if name.middle != ""
        str *= " $(name.middle)"
    end
    return str
end

function names_to_strings(names::BibInternal.Names)
    if length(names) ≥ 1
        str = name_to_string(names[1])
    end
    if length(names) > 1
        for name in names[2:end]
            str *= " and " * name_to_string(name)
        end
    end
    return str
end

function access_to_bibtex!(
    fields::BibInternal.Fields,
    a::BibInternal.Access
    )
    fields["doi"] = a.doi
    fields["howpublished"] = a.howpublished
    fields["url"] = a.url
end

function date_to_bibtex!(
    fields::BibInternal.Fields,
    d::BibInternal.Date
    )
    fields["day"] = d.day
    fields["month"] = d.month
    fields["year"] = d.year
end

function eprint_to_bibtex!(
    fields::BibInternal.Fields,
    e::BibInternal.Eprint
    )
    fields["archivePrefix"] = e.archive_prefix
    fields["eprint"] = e.eprint
    fields["primaryClass"] = e.primary_class
end

function in_to_bibtex!(
    fields::BibInternal.Fields,
    i::BibInternal.In
    )
    fields["address"] = i.address
    fields["chapter"] = i.chapter
    fields["edition"] = i.edition
    fields["institution"] = i.institution
    fields["journal"] = i.journal
    fields["number"] = i.number
    fields["organization"] = i.organization
    fields["pages"] = i.pages
    fields["publisher"] = i.publisher
    fields["school"] = i.school
    fields["series"] = i.series
    fields["volume"] = i.volume
end

function export_bibtex(e::Entry)
    access_to_bibtex!(e.fields, e.access)
    e.fields["author"] = names_to_strings(e.authors)
    e.fields["booktitle"] = e.booktitle
    date_to_bibtex!(e.fields, e.date)
    e.fields["editor"] = names_to_strings(e.editors)
    eprint_to_bibtex!(e.fields, e.eprint)
    in_to_bibtex!(e.fields, e.in)
    e.fields["title"] = e.title

    str = "@$(e.type == "eprint" ? "misc" : e.type){$(e.id),\n"
    for (name, value) in collect(e.fields)
        m = match(r"swp-",name)
        if m === nothing || m.offset > 1
            str *= value == "" ? "" : field_to_bibtex(name, value)
        end
    end
    return str[1:end - 2] * "\n}"
end

function export_bibtex(bibliography::DataStructures.OrderedDict{String,Entry})
    str = ""
    for e in values(bibliography)
        # @info "Test for eprint" e
        str *= export_bibtex(e) * "\n\n"
    end
    return str[1:end - 1]
end
