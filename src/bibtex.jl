function import_bibtex(file::String)
    return BibParser.BibTeX.parse_file(file)[1]
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
    return value == "" ? "" : " $key$space = {$value},\n"
end

function export_bibtex(entry::Article)
    str  = "@article{" * entry.id * ",\n"
    str *= field_to_bibtex("author", entry.author)
    str *= field_to_bibtex("key", entry.key)
    str *= field_to_bibtex("month", entry.month)
    str *= field_to_bibtex("note", entry.note)
    str *= field_to_bibtex("number", entry.number)
    str *= field_to_bibtex("pages", entry.pages)
    str *= field_to_bibtex("title", entry.title)
    str *= field_to_bibtex("volume", entry.volume)
    str *= field_to_bibtex("year", entry.year)
    for (key, value) in pairs(entry.fields)        
        str *= field_to_bibtex(key, value)
    end
    return str[1:end - 2] * "\n}"
end

function export_bibtex(entry::Book)
    str  = "@book{" * entry.id * ",\n"
    str *= field_to_bibtex("address", entry.address)
    str *= field_to_bibtex("author", entry.author)
    str *= field_to_bibtex("edition", entry.edition)
    str *= field_to_bibtex("editor", entry.editor)
    str *= field_to_bibtex("key", entry.key)
    str *= field_to_bibtex("month", entry.month)
    str *= field_to_bibtex("note", entry.note)
    str *= field_to_bibtex("number", entry.number)
    str *= field_to_bibtex("publisher", entry.publisher)
    str *= field_to_bibtex("series", entry.series)
    str *= field_to_bibtex("title", entry.title)
    str *= field_to_bibtex("volume", entry.volume)
    str *= field_to_bibtex("year", entry.year)
    for (key, value) in pairs(entry.fields)        
        str *= field_to_bibtex(key, value)
    end
    return str[1:end - 2] * "\n}"
end

function export_bibtex(entry::Booklet)
    str  = "@booklet{" * entry.id * ",\n"
    str *= field_to_bibtex("address", entry.address)
    str *= field_to_bibtex("author", entry.author)
    str *= field_to_bibtex("howpublished", entry.howpublished)
    str *= field_to_bibtex("key", entry.key)
    str *= field_to_bibtex("month", entry.month)
    str *= field_to_bibtex("note", entry.note)
    str *= field_to_bibtex("title", entry.title)
    str *= field_to_bibtex("year", entry.year)
    for (key, value) in pairs(entry.fields)        
        str *= field_to_bibtex(key, value)
    end
    return str[1:end - 2] * "\n}"
end

function export_bibtex(entry::InBook)
    str  = "@inbook{" * entry.id * ",\n"
    str *= field_to_bibtex("address", entry.address)
    str *= field_to_bibtex("author", entry.author)
    str *= field_to_bibtex("chapter", entry.chapter)
    str *= field_to_bibtex("edition", entry.edition)
    str *= field_to_bibtex("editor", entry.editor)
    str *= field_to_bibtex("key", entry.key)
    str *= field_to_bibtex("month", entry.month)
    str *= field_to_bibtex("note", entry.note)
    str *= field_to_bibtex("number", entry.number)
    str *= field_to_bibtex("pages", entry.pages)
    str *= field_to_bibtex("publisher", entry.publisher)
    str *= field_to_bibtex("series", entry.series)
    str *= field_to_bibtex("title", entry.title)
    str *= field_to_bibtex("type", entry.type)
    str *= field_to_bibtex("volume", entry.volume)
    str *= field_to_bibtex("year", entry.year)
    for (key, value) in pairs(entry.fields)
        str *= field_to_bibtex(key, value)
    end
    return str[1:end - 2] * "\n}"
end

function export_bibtex(entry::InCollection)
    str  = "@incollection{" * entry.id * ",\n"
    str *= field_to_bibtex("address", entry.address)
    str *= field_to_bibtex("author", entry.author)
    str *= field_to_bibtex("booktitle", entry.booktitle)
    str *= field_to_bibtex("chapter", entry.chapter)
    str *= field_to_bibtex("edition", entry.edition)
    str *= field_to_bibtex("editor", entry.editor)
    str *= field_to_bibtex("key", entry.key)
    str *= field_to_bibtex("month", entry.month)
    str *= field_to_bibtex("note", entry.note)
    str *= field_to_bibtex("number", entry.number)
    str *= field_to_bibtex("pages", entry.pages)
    str *= field_to_bibtex("publisher", entry.publisher)
    str *= field_to_bibtex("series", entry.series)
    str *= field_to_bibtex("title", entry.title)
    str *= field_to_bibtex("type", entry.type)
    str *= field_to_bibtex("volume", entry.volume)
    str *= field_to_bibtex("year", entry.year)
    for (key, value) in pairs(entry.fields)        
        str *= field_to_bibtex(key, value)
    end
    return str[1:end - 2] * "\n}"
end

function export_bibtex(entry::InProceedings)
    str  = "@inproceedings{" * entry.id * ",\n"
    str *= field_to_bibtex("address", entry.address)
    str *= field_to_bibtex("author", entry.author)
    str *= field_to_bibtex("booktitle", entry.booktitle)
    str *= field_to_bibtex("editor", entry.editor)
    str *= field_to_bibtex("key", entry.key)
    str *= field_to_bibtex("month", entry.month)
    str *= field_to_bibtex("note", entry.note)
    str *= field_to_bibtex("number", entry.number)
    str *= field_to_bibtex("pages", entry.pages)
    str *= field_to_bibtex("publisher", entry.publisher)
    str *= field_to_bibtex("series", entry.series)
    str *= field_to_bibtex("title", entry.title)
    str *= field_to_bibtex("volume", entry.volume)
    str *= field_to_bibtex("year", entry.year)
    for (key, value) in pairs(entry.fields)        
        str *= field_to_bibtex(key, value)
    end
    return str[1:end - 2] * "\n}"
end

function export_bibtex(entry::Manual)
    str  = "@manual{" * entry.id * ",\n"
    str *= field_to_bibtex("address", entry.address)
    str *= field_to_bibtex("author", entry.author)
    str *= field_to_bibtex("edition", entry.edition)
    str *= field_to_bibtex("key", entry.key)
    str *= field_to_bibtex("month", entry.month)
    str *= field_to_bibtex("note", entry.note)
    str *= field_to_bibtex("organization", entry.organization)
    str *= field_to_bibtex("title", entry.title)
    str *= field_to_bibtex("year", entry.year)
    for (key, value) in pairs(entry.fields)        
        str *= field_to_bibtex(key, value)
    end
    return str[1:end - 2] * "\n}"
end

function export_bibtex(entry::MasterThesis)
    str  = "@masterthesis{" * entry.id * ",\n"
    str *= field_to_bibtex("address", entry.address)
    str *= field_to_bibtex("author", entry.author)
    str *= field_to_bibtex("key", entry.key)
    str *= field_to_bibtex("month", entry.month)
    str *= field_to_bibtex("note", entry.note)
    str *= field_to_bibtex("school", entry.school)
    str *= field_to_bibtex("title", entry.title)
    str *= field_to_bibtex("type", entry.type)
    str *= field_to_bibtex("year", entry.year)
    for (key, value) in pairs(entry.fields)        
        str *= field_to_bibtex(key, value)
    end
    return str[1:end - 2] * "\n}"
end

function export_bibtex(entry::Misc)
    str  = "@misc{" * entry.id * ",\n"
    str *= field_to_bibtex("author", entry.author)
    str *= field_to_bibtex("howpublished", entry.howpublished)
    str *= field_to_bibtex("key", entry.key)
    str *= field_to_bibtex("month", entry.month)
    str *= field_to_bibtex("note", entry.note)
    str *= field_to_bibtex("title", entry.title)
    str *= field_to_bibtex("year", entry.year)
    for (key, value) in pairs(entry.fields)        
        str *= field_to_bibtex(key, value)
    end
    return str[1:end - 2] * "\n}"
end

function export_bibtex(entry::PhDThesis)
    str  = "@phdthesis{" * entry.id * ",\n"
    str *= field_to_bibtex("address", entry.address)
    str *= field_to_bibtex("author", entry.author)
    str *= field_to_bibtex("key", entry.key)
    str *= field_to_bibtex("month", entry.month)
    str *= field_to_bibtex("note", entry.note)
    str *= field_to_bibtex("school", entry.school)
    str *= field_to_bibtex("title", entry.title)
    str *= field_to_bibtex("type", entry.type)
    str *= field_to_bibtex("year", entry.year)
    for (key, value) in pairs(entry.fields)        
        str *= field_to_bibtex(key, value)
    end
    return str[1:end - 2] * "\n}"
end

function export_bibtex(entry::Proceedings)
    str  = "@proceedings{" * entry.id * ",\n"
    str *= field_to_bibtex("address", entry.address)
    str *= field_to_bibtex("editor", entry.editor)
    str *= field_to_bibtex("key", entry.key)
    str *= field_to_bibtex("month", entry.month)
    str *= field_to_bibtex("note", entry.note)
    str *= field_to_bibtex("number", entry.number)
    str *= field_to_bibtex("organization", entry.organization)
    str *= field_to_bibtex("publisher", entry.publisher)
    str *= field_to_bibtex("series", entry.series)
    str *= field_to_bibtex("title", entry.title)
    str *= field_to_bibtex("volume", entry.volume)
    str *= field_to_bibtex("year", entry.year)
    for (key, value) in pairs(entry.fields)        
        str *= field_to_bibtex(key, value)
    end
    return str[1:end - 2] * "\n}"
end

function export_bibtex(entry::TechReport)
    str  = "@techreport{" * entry.id * ",\n"
    str *= field_to_bibtex("address", entry.address)
    str *= field_to_bibtex("author", entry.author)
    str *= field_to_bibtex("institution", entry.institution)
    str *= field_to_bibtex("key", entry.key)
    str *= field_to_bibtex("month", entry.month)
    str *= field_to_bibtex("note", entry.note)
    str *= field_to_bibtex("number", entry.number)
    str *= field_to_bibtex("title", entry.title)
    str *= field_to_bibtex("type", entry.type)
    str *= field_to_bibtex("year", entry.year)
    for (key, value) in pairs(entry.fields)        
        str *= field_to_bibtex(key, value)
    end
    return str[1:end - 2] * "\n}"
end

function export_bibtex(entry::Unpublished)
    str  = "@unpublished{" * entry.id * ",\n"
    str *= field_to_bibtex("author", entry.author)
    str *= field_to_bibtex("key", entry.key)
    str *= field_to_bibtex("month", entry.month)
    str *= field_to_bibtex("note", entry.note)
    str *= field_to_bibtex("title", entry.title)
    str *= field_to_bibtex("year", entry.year)
    for (key, value) in pairs(entry.fields)        
        str *= field_to_bibtex(key, value)
    end
    return str[1:end - 2] * "\n}"
end

function export_bibtex(bibliography::DataStructures.OrderedDict{String,AbstractEntry})
    str = ""
    for e in values(bibliography)
        str *= export_bibtex(e) * "\n"
    end
    return str[1:end - 1]
end
