"""
    import_bibtex(input)
Import a BibTeX file or parse a BibTeX string and convert it to the internal bibliography format.
"""
function import_bibtex(input)
    return isfile(input) ? BibParser.parse_file(input) : BibParser.parse_entry(input)
end

"""
    int_to_spaces(n)

Make a string of `n` spaces.
"""
int_to_spaces(n) = repeat(" ", n)

const spaces = Dict{String,String}(map(
    s -> (string(s) => int_to_spaces(BibInternal.space(s))),
    BibInternal.fields)
)

"""
    field_to_bibtex(key, value)

Convert an entry field to BibTeX format.
"""
function field_to_bibtex(key, value)
    space = get(spaces, key, int_to_spaces(BibInternal.space(Symbol(key))))
    swp = length(key) > 3 && key[1:3] == "swp"
    o,f = isnothing(match(r"@", value)) ? ('{','}') : ('"','"')
    return value == "" || swp ? "" : " $key$space = $o$value$f,\n"
end

"""
    name_to_string(name::BibInternal.Name)

Convert a name in an `Entry` to a string.
"""
function name_to_string(name)
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

"""
    names_to_strings(names)

Convert a collection of names to a BibTeX string.
"""
function names_to_strings(names)
    return join(map(name_to_string, names), " and ")
end

"""
    access_to_bibtex!(fields, a)

Transform the how-to-`access` field to a BibTeX string.
"""
function access_to_bibtex!(fields, a)
    fields["doi"] = a.doi
    fields["howpublished"] = a.howpublished
    fields["url"] = a.url
end

"""
    date_to_bibtex!(fields, date)

Convert a date to a BibTeX string.
"""
function date_to_bibtex!(fields, date)
    fields["day"] = date.day
    fields["month"] = date.month
    fields["year"] = date.year
end

"""
    eprint_to_bibtex!(fields, eprint)

Convert eprint information to a BibTeX string.
"""
function eprint_to_bibtex!(fields, ep)
    fields["archivePrefix"] = ep.archive_prefix
    fields["eprint"] = ep.eprint
    fields["primaryClass"] = ep.primary_class
end

"""
    in_to_bibtex!(fields::BibInternal.Fields, i::BibInternal.In)

Convert the "published `in`" information to a BibTeX string.
"""
function in_to_bibtex!(fields, in_)
    fields["address"] = in_.address
    fields["chapter"] = in_.chapter
    fields["edition"] = in_.edition
    fields["institution"] = in_.institution
    fields["journal"] = in_.journal
    fields["number"] = in_.number
    fields["organization"] = in_.organization
    fields["pages"] = in_.pages
    fields["publisher"] = in_.publisher
    fields["school"] = in_.school
    fields["series"] = in_.series
    fields["volume"] = in_.volume
end

"""
    export_bibtex(e::Entry)

Export an `Entry` to a BibTeX string.
"""
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

"""
    export_bibtex(bibliography)

Export a bibliography to a BibTeX string.
"""
function export_bibtex(bibliography)
    str = ""
    for e in values(bibliography)
        str *= export_bibtex(e) * "\n\n"
    end
    return str[1:end - 1]
end
