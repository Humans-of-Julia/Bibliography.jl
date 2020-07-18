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
    return value == "" || swp ? "" : " $key$space = {$value},\n"
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
    date_to_bibtex!(e.fields, e.date)
    e.fields["editor"] = names_to_strings(e.editors)
    eprint_to_bibtex!(e.fields, e.eprint)
    in_to_bibtex!(e.fields, e.in)
    e.fields["title"] = e.title

    str = "@$(e.type){$(e.id),\n"
    for (name, value) in collect(e.fields)
        m = match(r"swp-",name)
        if m === nothing || m.offset > 1
            str *= value == "" ? "" : field_to_bibtex(name, value)
        end
    end
    return str[1:end - 2] * "\n}"
end

# function export_bibtex(entry::Article)
#     str  = "@article{" * entry.id * ",\n"
#     str *= field_to_bibtex("author", bibtexnames_to_string(entry.author))
#     str *= field_to_bibtex("key", entry.key)
#     str *= field_to_bibtex("month", entry.month)
#     str *= field_to_bibtex("note", entry.note)
#     str *= field_to_bibtex("number", entry.number)
#     str *= field_to_bibtex("pages", entry.pages)
#     str *= field_to_bibtex("title", entry.title)
#     str *= field_to_bibtex("volume", entry.volume)
#     str *= field_to_bibtex("year", entry.year)
#     for (key, value) in pairs(entry.fields)        
#         str *= field_to_bibtex(key, value)
#     end
#     return str[1:end - 2] * "\n}"
# end

# function export_bibtex(entry::Book)
#     str  = "@book{" * entry.id * ",\n"
#     str *= field_to_bibtex("address", entry.address)
#     str *= field_to_bibtex("author", bibtexnames_to_string(entry.author))
#     str *= field_to_bibtex("edition", entry.edition)
#     str *= field_to_bibtex("editor", bibtexnames_to_string(entry.editor))
#     str *= field_to_bibtex("key", entry.key)
#     str *= field_to_bibtex("month", entry.month)
#     str *= field_to_bibtex("note", entry.note)
#     str *= field_to_bibtex("number", entry.number)
#     str *= field_to_bibtex("publisher", entry.publisher)
#     str *= field_to_bibtex("series", entry.series)
#     str *= field_to_bibtex("title", entry.title)
#     str *= field_to_bibtex("volume", entry.volume)
#     str *= field_to_bibtex("year", entry.year)
#     for (key, value) in pairs(entry.fields)        
#         str *= field_to_bibtex(key, value)
#     end
#     return str[1:end - 2] * "\n}"
# end

# function export_bibtex(entry::Booklet)
#     str  = "@booklet{" * entry.id * ",\n"
#     str *= field_to_bibtex("address", entry.address)
#     str *= field_to_bibtex("author", bibtexnames_to_string(entry.author))
#     str *= field_to_bibtex("howpublished", entry.howpublished)
#     str *= field_to_bibtex("key", entry.key)
#     str *= field_to_bibtex("month", entry.month)
#     str *= field_to_bibtex("note", entry.note)
#     str *= field_to_bibtex("title", entry.title)
#     str *= field_to_bibtex("year", entry.year)
#     for (key, value) in pairs(entry.fields)        
#         str *= field_to_bibtex(key, value)
#     end
#     return str[1:end - 2] * "\n}"
# end

# function export_bibtex(entry::Eprint)
#     str  = "@misc{" * entry.id * ",\n"
#     str *= field_to_bibtex("author", bibtexnames_to_string(entry.author))
#     str *= field_to_bibtex("eprint", entry.eprint)
#     str *= field_to_bibtex("title", entry.title)
#     str *= field_to_bibtex("year", entry.year)    
#     str *= field_to_bibtex("archivePrefix", entry.archivePrefix)
#     str *= field_to_bibtex("primaryClass", entry.primaryClass)
#     for (key, value) in pairs(entry.fields)        
#         str *= field_to_bibtex(key, value)
#     end
#     return str[1:end - 2] * "\n}"
# end

# function export_bibtex(entry::InBook)
#     str  = "@inbook{" * entry.id * ",\n"
#     str *= field_to_bibtex("address", entry.address)
#     str *= field_to_bibtex("author", bibtexnames_to_string(entry.author))
#     str *= field_to_bibtex("chapter", entry.chapter)
#     str *= field_to_bibtex("edition", entry.edition)
#     str *= field_to_bibtex("editor", bibtexnames_to_string(entry.editor))
#     str *= field_to_bibtex("key", entry.key)
#     str *= field_to_bibtex("month", entry.month)
#     str *= field_to_bibtex("note", entry.note)
#     str *= field_to_bibtex("number", entry.number)
#     str *= field_to_bibtex("pages", entry.pages)
#     str *= field_to_bibtex("publisher", entry.publisher)
#     str *= field_to_bibtex("series", entry.series)
#     str *= field_to_bibtex("title", entry.title)
#     str *= field_to_bibtex("type", entry.type)
#     str *= field_to_bibtex("volume", entry.volume)
#     str *= field_to_bibtex("year", entry.year)
#     for (key, value) in pairs(entry.fields)
#         str *= field_to_bibtex(key, value)
#     end
#     return str[1:end - 2] * "\n}"
# end

# function export_bibtex(entry::InCollection)
#     str  = "@incollection{" * entry.id * ",\n"
#     str *= field_to_bibtex("address", entry.address)
#     str *= field_to_bibtex("author", bibtexnames_to_string(entry.author))
#     str *= field_to_bibtex("booktitle", entry.booktitle)
#     str *= field_to_bibtex("chapter", entry.chapter)
#     str *= field_to_bibtex("edition", entry.edition)
#     str *= field_to_bibtex("editor", bibtexnames_to_string(entry.editor))
#     str *= field_to_bibtex("key", entry.key)
#     str *= field_to_bibtex("month", entry.month)
#     str *= field_to_bibtex("note", entry.note)
#     str *= field_to_bibtex("number", entry.number)
#     str *= field_to_bibtex("pages", entry.pages)
#     str *= field_to_bibtex("publisher", entry.publisher)
#     str *= field_to_bibtex("series", entry.series)
#     str *= field_to_bibtex("title", entry.title)
#     str *= field_to_bibtex("type", entry.type)
#     str *= field_to_bibtex("volume", entry.volume)
#     str *= field_to_bibtex("year", entry.year)
#     for (key, value) in pairs(entry.fields)        
#         str *= field_to_bibtex(key, value)
#     end
#     return str[1:end - 2] * "\n}"
# end

# function export_bibtex(entry::InProceedings)
#     str  = "@inproceedings{" * entry.id * ",\n"
#     str *= field_to_bibtex("address", entry.address)
#     str *= field_to_bibtex("author", bibtexnames_to_string(entry.author))
#     str *= field_to_bibtex("booktitle", entry.booktitle)
#     str *= field_to_bibtex("editor", bibtexnames_to_string(entry.editor))
#     str *= field_to_bibtex("key", entry.key)
#     str *= field_to_bibtex("month", entry.month)
#     str *= field_to_bibtex("note", entry.note)
#     str *= field_to_bibtex("number", entry.number)
#     str *= field_to_bibtex("pages", entry.pages)
#     str *= field_to_bibtex("publisher", entry.publisher)
#     str *= field_to_bibtex("series", entry.series)
#     str *= field_to_bibtex("title", entry.title)
#     str *= field_to_bibtex("volume", entry.volume)
#     str *= field_to_bibtex("year", entry.year)
#     for (key, value) in pairs(entry.fields)        
#         str *= field_to_bibtex(key, value)
#     end
#     return str[1:end - 2] * "\n}"
# end

# function export_bibtex(entry::Manual)
#     str  = "@manual{" * entry.id * ",\n"
#     str *= field_to_bibtex("address", entry.address)
#     str *= field_to_bibtex("author", bibtexnames_to_string(entry.author))
#     str *= field_to_bibtex("edition", entry.edition)
#     str *= field_to_bibtex("key", entry.key)
#     str *= field_to_bibtex("month", entry.month)
#     str *= field_to_bibtex("note", entry.note)
#     str *= field_to_bibtex("organization", entry.organization)
#     str *= field_to_bibtex("title", entry.title)
#     str *= field_to_bibtex("year", entry.year)
#     for (key, value) in pairs(entry.fields)        
#         str *= field_to_bibtex(key, value)
#     end
#     return str[1:end - 2] * "\n}"
# end

# function export_bibtex(entry::MasterThesis)
#     str  = "@masterthesis{" * entry.id * ",\n"
#     str *= field_to_bibtex("address", entry.address)
#     str *= field_to_bibtex("author", bibtexnames_to_string(entry.author))
#     str *= field_to_bibtex("key", entry.key)
#     str *= field_to_bibtex("month", entry.month)
#     str *= field_to_bibtex("note", entry.note)
#     str *= field_to_bibtex("school", entry.school)
#     str *= field_to_bibtex("title", entry.title)
#     str *= field_to_bibtex("type", entry.type)
#     str *= field_to_bibtex("year", entry.year)
#     for (key, value) in pairs(entry.fields)        
#         str *= field_to_bibtex(key, value)
#     end
#     return str[1:end - 2] * "\n}"
# end

# function export_bibtex(entry::Misc)
#     str  = "@misc{" * entry.id * ",\n"
#     str *= field_to_bibtex("author", bibtexnames_to_string(entry.author))
#     str *= field_to_bibtex("howpublished", entry.howpublished)
#     str *= field_to_bibtex("key", entry.key)
#     str *= field_to_bibtex("month", entry.month)
#     str *= field_to_bibtex("note", entry.note)
#     str *= field_to_bibtex("title", entry.title)
#     str *= field_to_bibtex("year", entry.year)
#     for (key, value) in pairs(entry.fields)        
#         str *= field_to_bibtex(key, value)
#     end
#     return str[1:end - 2] * "\n}"
# end

# function export_bibtex(entry::PhDThesis)
#     str  = "@phdthesis{" * entry.id * ",\n"
#     str *= field_to_bibtex("address", entry.address)
#     str *= field_to_bibtex("author", bibtexnames_to_string(entry.author))
#     str *= field_to_bibtex("key", entry.key)
#     str *= field_to_bibtex("month", entry.month)
#     str *= field_to_bibtex("note", entry.note)
#     str *= field_to_bibtex("school", entry.school)
#     str *= field_to_bibtex("title", entry.title)
#     str *= field_to_bibtex("type", entry.type)
#     str *= field_to_bibtex("year", entry.year)
#     for (key, value) in pairs(entry.fields)        
#         str *= field_to_bibtex(key, value)
#     end
#     return str[1:end - 2] * "\n}"
# end

# function export_bibtex(entry::Proceedings)
#     str  = "@proceedings{" * entry.id * ",\n"
#     str *= field_to_bibtex("address", entry.address)
#     str *= field_to_bibtex("editor", bibtexnames_to_string(entry.editor))
#     str *= field_to_bibtex("key", entry.key)
#     str *= field_to_bibtex("month", entry.month)
#     str *= field_to_bibtex("note", entry.note)
#     str *= field_to_bibtex("number", entry.number)
#     str *= field_to_bibtex("organization", entry.organization)
#     str *= field_to_bibtex("publisher", entry.publisher)
#     str *= field_to_bibtex("series", entry.series)
#     str *= field_to_bibtex("title", entry.title)
#     str *= field_to_bibtex("volume", entry.volume)
#     str *= field_to_bibtex("year", entry.year)
#     for (key, value) in pairs(entry.fields)        
#         str *= field_to_bibtex(key, value)
#     end
#     return str[1:end - 2] * "\n}"
# end

# function export_bibtex(entry::TechReport)
#     str  = "@techreport{" * entry.id * ",\n"
#     str *= field_to_bibtex("address", entry.address)
#     str *= field_to_bibtex("author", bibtexnames_to_string(entry.author))
#     str *= field_to_bibtex("institution", entry.institution)
#     str *= field_to_bibtex("key", entry.key)
#     str *= field_to_bibtex("month", entry.month)
#     str *= field_to_bibtex("note", entry.note)
#     str *= field_to_bibtex("number", entry.number)
#     str *= field_to_bibtex("title", entry.title)
#     str *= field_to_bibtex("type", entry.type)
#     str *= field_to_bibtex("year", entry.year)
#     for (key, value) in pairs(entry.fields)        
#         str *= field_to_bibtex(key, value)
#     end
#     return str[1:end - 2] * "\n}"
# end

# function export_bibtex(entry::Unpublished)
#     str  = "@unpublished{" * entry.id * ",\n"
#     str *= field_to_bibtex("author", bibtexnames_to_string(entry.author))
#     str *= field_to_bibtex("key", entry.key)
#     str *= field_to_bibtex("month", entry.month)
#     str *= field_to_bibtex("note", entry.note)
#     str *= field_to_bibtex("title", entry.title)
#     str *= field_to_bibtex("year", entry.year)
#     for (key, value) in pairs(entry.fields)        
#         str *= field_to_bibtex(key, value)
#     end
#     return str[1:end - 2] * "\n}"
# end

function export_bibtex(bibliography::DataStructures.OrderedDict{String,Entry})
    str = ""
    for e in values(bibliography)
        str *= export_bibtex(e) * "\n"
    end
    return str[1:end - 1]
end
