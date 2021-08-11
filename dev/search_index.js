var documenterSearchIndex = {"docs":
[{"location":"internal/","page":"BibInternal","title":"BibInternal","text":"","category":"page"},{"location":"internal/","page":"BibInternal","title":"BibInternal","text":"Modules = [BibInternal]","category":"page"},{"location":"internal/#BibInternal.entries","page":"BibInternal","title":"BibInternal.entries","text":"const entries = [\n    :article,\n    :book,\n    :booklet,\n    :inbook,\n    :incollection,\n    :inproceedings,\n    :manual,\n    :mastersthesis,\n    :misc,\n    :phdthesis,\n    :proceedings,\n    :techreport,\n    :unpublished,\n]\n\nList of possible entries (currently based on bibtex). Keep it sorted for readability.\n\n\n\n\n\n","category":"constant"},{"location":"internal/#BibInternal.fields","page":"BibInternal","title":"BibInternal.fields","text":"const fields = [\n    :address,\n    :annote,\n    :archivePrefix,\n    :author,\n    :booktitle,\n    :chapter,\n    :crossref,\n    :edition,\n    :editor,\n    :eprint,\n    :howpublished,\n    :institution,\n    :journal,\n    :key,\n    :month,\n    :note,\n    :number,\n    :organization,\n    :pages,\n    :primaryClass,\n    :publisher,\n    :school,\n    :series,\n    :title,\n    :type,\n    :volume,\n    :year\n]\n\nList of possible fields (currently based on bibtex). Keep it sorted for readability\n\n\n\n\n\n","category":"constant"},{"location":"internal/#BibInternal.maxfieldlength","page":"BibInternal","title":"BibInternal.maxfieldlength","text":"const maxfieldlength\n\nFor output formatting purpose, for instance, export to BibTeX format.\n\n\n\n\n\n","category":"constant"},{"location":"internal/#BibInternal.rules","page":"BibInternal","title":"BibInternal.rules","text":"const rules = Dict([\n    \"article\"       => [\"author\", \"journal\", \"title\", \"year\"]\n    \"book\"          => [(\"author\", \"editor\"), \"publisher\", \"title\", \"year\"]\n    \"booklet\"       => [\"title\"]\n    \"eprint\"        => [\"author\", \"eprint\", \"title\", \"year\"]\n    \"inbook\"        => [(\"author\", \"editor\"), (\"chapter\", \"pages\"), \"publisher\", \"title\", \"year\"]\n    \"incollection\"  => [\"author\", \"booktitle\", \"publisher\", \"title\", \"year\"]\n    \"inproceedings\" => [\"author\", \"booktitle\", \"title\", \"year\"]\n    \"manual\"        => [\"title\"]\n    \"mastersthesis\" => [\"author\", \"school\", \"title\", \"year\"]\n    \"misc\"          => []\n    \"phdthesis\"     => [\"author\", \"school\", \"title\", \"year\"]\n    \"proceedings\"   => [\"title\", \"year\"]\n    \"techreport\"    => [\"author\", \"institution\", \"title\", \"year\"]\n    \"unpublished\"   => [\"author\", \"note\", \"title\"]\n])\n\nList of BibTeX rules bases on the entry type. A field value as a singleton represents a required field. A pair of values represents mutually exclusive required fields.\n\n\n\n\n\n","category":"constant"},{"location":"internal/#BibInternal.AbstractEntry","page":"BibInternal","title":"BibInternal.AbstractEntry","text":"Abstract entry supertype.\n\n\n\n\n\n","category":"type"},{"location":"internal/#BibInternal.Access","page":"BibInternal","title":"BibInternal.Access","text":"struct Access\n    doi::String\n    howpublished::String\n    url::String\nend\n\nStore the online access of an entry as a String. Handles the fields doi and url and the arXiv entries. For additional fields or entries, please fill an issue or make a pull request.\n\n\n\n\n\n","category":"type"},{"location":"internal/#BibInternal.Access-Tuple{Any}","page":"BibInternal","title":"BibInternal.Access","text":"Access(fields::Fields)\n\nConstruct the online access information based on the entry fields.\n\n\n\n\n\n","category":"method"},{"location":"internal/#BibInternal.Date","page":"BibInternal","title":"BibInternal.Date","text":"struct Date\n    day::String\n    month::String\n    year::String\nend\n\nStore the date information as day, month, and year.\n\n\n\n\n\n","category":"type"},{"location":"internal/#BibInternal.Date-Tuple{Any}","page":"BibInternal","title":"BibInternal.Date","text":"Date(fields::Fields)\n\nConstruct the date information based on the entry fields.\n\n\n\n\n\n","category":"method"},{"location":"internal/#BibInternal.Entry","page":"BibInternal","title":"BibInternal.Entry","text":"struct Entry <: AbstractEntry\n    access::Access\n    authors::Names\n    booktitle::String\n    date::Date\n    editors::Names\n    eprint::Eprint\n    id::String\n    in::In\n    fields::Dict{String,String}\n    title::String\n    type::String\nend\n\nGeneric Entry type. If some construction rules are required, it should be done beforehand. Check bibtex.jl as the example of rules implementation for BibTeX format.\n\n\n\n\n\n","category":"type"},{"location":"internal/#BibInternal.Entry-Tuple{Any, Any}","page":"BibInternal","title":"BibInternal.Entry","text":"Entry(id::String, fields::Fields)\n\nConstruct an entry with a unique id and a list of Fields.\n\n\n\n\n\n","category":"method"},{"location":"internal/#BibInternal.Eprint","page":"BibInternal","title":"BibInternal.Eprint","text":"struct Eprint\n    archive_prefix::String\n    eprint::String\n    primary_class::String\nend\n\nStore the information related to arXiv eprint format.\n\n\n\n\n\n","category":"type"},{"location":"internal/#BibInternal.Eprint-Tuple{Any}","page":"BibInternal","title":"BibInternal.Eprint","text":"Eprint(fields::Fields)\n\nConstruct the eprint arXiv information based on the entry fields. Handle old and current arXiv format.\n\n\n\n\n\n","category":"method"},{"location":"internal/#BibInternal.Fields","page":"BibInternal","title":"BibInternal.Fields","text":"Fields = Dict{String, String}. Stores the fields name => value of an entry.\n\n\n\n\n\n","category":"type"},{"location":"internal/#BibInternal.In","page":"BibInternal","title":"BibInternal.In","text":"struct In\n    address::String\n    chapter::String\n    edition::String\n    institution::String\n    journal::String\n    number::String\n    organization::String\n    pages::String\n    publisher::String\n    school::String\n    series::String\n    volume::String\nend\n\nStore all the information related to how an entry was published.\n\n\n\n\n\n","category":"type"},{"location":"internal/#BibInternal.In-Tuple{Any}","page":"BibInternal","title":"BibInternal.In","text":"In(fields::Fields)\n\nConstruct the information of how an entry was published based on its fields\n\n\n\n\n\n","category":"method"},{"location":"internal/#BibInternal.Name-Tuple{Any}","page":"BibInternal","title":"BibInternal.Name","text":"Name(str::String)\n\nDecompose without ambiguities a name as particle (optional) last, junior (optional), first middle (optional) based on BibTeX possible input. As for BibTeX, the decomposition of a name in the form of first last is also possible, but ambiguities can occur.\n\n\n\n\n\n","category":"method"},{"location":"internal/#Base.isless-Tuple{BibInternal.Date, BibInternal.Date}","page":"BibInternal","title":"Base.isless","text":"Base.isless(a::BibInternal.Date,b::BibInternal.Date)::Bool\n\nFunction to check for a < b on BibInternal.Date data types.\n\nThis function will throw an ArgumentError if the year can not parsed into Int. If it is not possible to parse month or day to Int those entries will be silently ignored for comparison. This function will not check if the date fields are given in a correct format all fields are parsed into and compared as Int (no checking if date format is correct or valid!).\n\ndanger: Note:\nThe silent ignoring of not parseable month or day fields will lead to misbehaviour if using comparators like == or !==!\n\n\n\n\n\n","category":"method"},{"location":"internal/#Base.isless-Tuple{BibInternal.Name, BibInternal.Name}","page":"BibInternal","title":"Base.isless","text":"Base.isless(a::BibInternal.Name,b::BibInternal.Name)::Bool\n\nFunction to check for a < b on BibInternal.Name data types.\n\nThis function will check the fields last, first and middle in this order of priority. The other fields are ignored for now. The field comparison is done by string comparison no advanced alphabetizing rules are used for now.\n\ndanger: Note:\nThe silent ignoring of the other fields might lead to misbehaviour if using comparators like == or !==!\n\n\n\n\n\n","category":"method"},{"location":"internal/#BibInternal.arxive_url-Tuple{Any}","page":"BibInternal","title":"BibInternal.arxive_url","text":"arxive_url(fields::Fields)\n\nMake an arxiv url from an eprint entry. Work with both old and current arxiv BibTeX format.\n\n\n\n\n\n","category":"method"},{"location":"internal/#BibInternal.check_entry-Tuple{Any}","page":"BibInternal","title":"BibInternal.check_entry","text":"check_entry(fields::Fields)\n\nCheck the validity of the fields of a BibTeX entry.\n\n\n\n\n\n","category":"method"},{"location":"internal/#BibInternal.erase_spaces-Tuple{Any}","page":"BibInternal","title":"BibInternal.erase_spaces","text":"erase_spaces(str::String)\n\nErase extra spaces, i.e. r\"[  ]+\", from str and return a new string.\n\n\n\n\n\n","category":"method"},{"location":"internal/#BibInternal.get_delete!-Tuple{Any, Any}","page":"BibInternal","title":"BibInternal.get_delete!","text":"get_delete!(fields::Fields, key::String)\n\nGet the value of a field and delete it afterward.\n\n\n\n\n\n","category":"method"},{"location":"internal/#BibInternal.make_bibtex_entry-Tuple{Any, Any}","page":"BibInternal","title":"BibInternal.make_bibtex_entry","text":"make_bibtex_entry(id::String, fields::Fields)\n\nMake an entry if the entry follows the BibTeX guidelines. Throw an error otherwise.\n\n\n\n\n\n","category":"method"},{"location":"internal/#BibInternal.names-Tuple{Any}","page":"BibInternal","title":"BibInternal.names","text":"names(str::String)\n\nDecompose into parts a list of names in BibTeX compatible format. That is names separated by and.\n\n\n\n\n\n","category":"method"},{"location":"internal/#BibInternal.space-Tuple{Any}","page":"BibInternal","title":"BibInternal.space","text":"space(field::Symbol)\n\nReturn the amount of spaces needed to export entries, for instance to BibTeX format.\n\n\n\n\n\n","category":"method"},{"location":"","page":"Bibliography","title":"Bibliography","text":"","category":"page"},{"location":"","page":"Bibliography","title":"Bibliography","text":"Modules = [Bibliography]","category":"page"},{"location":"#Bibliography.sorting_rules","page":"Bibliography","title":"Bibliography.sorting_rules","text":"const sorting_rules = Dict{Symbol, Vector{Symbol}}(\n    :nty  => [:authors;:editors;:title;:date],\n    :nyt  => [:authors;:editors;:date;:title],\n    :y    => [:date]\n);\n\nImplemented sorting rules for bibliography entry sorting.\n\nSee also sort_bibliography!.\n\n\n\n\n\n","category":"constant"},{"location":"#Bibliography.Publication","page":"Bibliography","title":"Bibliography.Publication","text":"Publication\n\nA structure to store all the information necessary to web export.\n\n\n\n\n\n","category":"type"},{"location":"#Bibliography.Publication-Tuple{Any}","page":"Bibliography","title":"Bibliography.Publication","text":"Publication(entry)\n\nConstruct a Publication (compatible with web export) from an Entry.\n\n\n\n\n\n","category":"method"},{"location":"#Bibliography.access_to_bibtex!-Tuple{Any, Any}","page":"Bibliography","title":"Bibliography.access_to_bibtex!","text":"access_to_bibtex!(fields, a)\n\nTransform the how-to-access field to a BibTeX string.\n\n\n\n\n\n","category":"method"},{"location":"#Bibliography.bibtex_to_web-Tuple{Any}","page":"Bibliography","title":"Bibliography.bibtex_to_web","text":"bibtex_to_web(source::String)\n\nConvert a BibTeX file to a web compatible format, specifically for the StaticWebPages.jl package.\n\n\n\n\n\n","category":"method"},{"location":"#Bibliography.date_to_bibtex!-Tuple{Any, Any}","page":"Bibliography","title":"Bibliography.date_to_bibtex!","text":"date_to_bibtex!(fields, date)\n\nConvert a date to a BibTeX string.\n\n\n\n\n\n","category":"method"},{"location":"#Bibliography.eprint_to_bibtex!-Tuple{Any, Any}","page":"Bibliography","title":"Bibliography.eprint_to_bibtex!","text":"eprint_to_bibtex!(fields, eprint)\n\nConvert eprint information to a BibTeX string.\n\n\n\n\n\n","category":"method"},{"location":"#Bibliography.export_bibtex-Tuple{Any, Any}","page":"Bibliography","title":"Bibliography.export_bibtex","text":"export_bibtex(target, bibliography)\n\nExport a bibliography to BibTeX format.\n\n\n\n\n\n","category":"method"},{"location":"#Bibliography.export_bibtex-Tuple{Any}","page":"Bibliography","title":"Bibliography.export_bibtex","text":"export_bibtex(bibliography)\n\nExport a bibliography to a BibTeX string.\n\n\n\n\n\n","category":"method"},{"location":"#Bibliography.export_bibtex-Tuple{BibInternal.Entry}","page":"Bibliography","title":"Bibliography.export_bibtex","text":"export_bibtex(e::Entry)\n\nExport an Entry to a BibTeX string.\n\n\n\n\n\n","category":"method"},{"location":"#Bibliography.export_web-Tuple{Any}","page":"Bibliography","title":"Bibliography.export_web","text":"export_web(bibliography::DataStructures.OrderedDict{String,BibInternal.Entry})\n\nExport a bibliography in internal format to the web format of the StaticWebPages.jl package. Also used by DocumenterCitations.jl.\n\n\n\n\n\n","category":"method"},{"location":"#Bibliography.field_to_bibtex-Tuple{Any, Any}","page":"Bibliography","title":"Bibliography.field_to_bibtex","text":"field_to_bibtex(key, value)\n\nConvert an entry field to BibTeX format.\n\n\n\n\n\n","category":"method"},{"location":"#Bibliography.import_bibtex-Tuple{Any}","page":"Bibliography","title":"Bibliography.import_bibtex","text":"import_bibtex(input)\n\nImport a BibTeX file or parse a BibTeX string and convert it to the internal bibliography format.\n\n\n\n\n\n","category":"method"},{"location":"#Bibliography.in_to_bibtex!-Tuple{Any, Any}","page":"Bibliography","title":"Bibliography.in_to_bibtex!","text":"in_to_bibtex!(fields::BibInternal.Fields, i::BibInternal.In)\n\nConvert the \"published in\" information to a BibTeX string.\n\n\n\n\n\n","category":"method"},{"location":"#Bibliography.int_to_spaces-Tuple{Any}","page":"Bibliography","title":"Bibliography.int_to_spaces","text":"int_to_spaces(n)\n\nMake a string of n spaces.\n\n\n\n\n\n","category":"method"},{"location":"#Bibliography.name_to_string-Tuple{Any}","page":"Bibliography","title":"Bibliography.name_to_string","text":"name_to_string(name::BibInternal.Name)\n\nConvert a name in an Entry to a string.\n\n\n\n\n\n","category":"method"},{"location":"#Bibliography.names_to_strings-Tuple{Any}","page":"Bibliography","title":"Bibliography.names_to_strings","text":"names_to_strings(names)\n\nConvert a collection of names to a BibTeX string.\n\n\n\n\n\n","category":"method"},{"location":"#Bibliography.recursive_isless-Tuple{BibInternal.Entry, BibInternal.Entry, Vector{Symbol}}","page":"Bibliography","title":"Bibliography.recursive_isless","text":"recursive_isless(a::Entry, b::Entry, fields::Tuple{Symbol},\n                 depth::Int = 0)\n\nHelper function for sort_bibliography!.\n\nThis function allows recursive checking if a < b with descending importance. The importance set for the comparison is defined by the argument fields. This argument is a tuple consisting of symbols denoting the fields of the data type BibInternal.Entry. The ordering implies the importance.\n\nThe depth argument is purely for iterating/recursive purposes.\n\n\n\n\n\n","category":"method"},{"location":"#Bibliography.select-Tuple{OrderedCollections.OrderedDict{String, BibInternal.Entry}, Vector{String}}","page":"Bibliography","title":"Bibliography.select","text":"select(\n    bibliography::DataStructures.OrderedDict{String,Entry},\n    selection::Vector{String};\n    complementary::Bool = false\n    )\n\nSelect a part of a bibliography based on a given selection set of keys. If complementary is true, selection designates which entries will not be kept. By default, complementary is set to false.\n\n\n\n\n\n","category":"method"},{"location":"#Bibliography.sort_bibliography!","page":"Bibliography","title":"Bibliography.sort_bibliography!","text":"sort_bibliography!(\n    bibliography::DataStructures.OrderedDict{String,Entry},\n    sorting_rule::Symbol = :key\n    )\n\nSorts the bibliography in place.\n\nThe sorting order can be set by specifying the sorting_rule. The sorting is implemented via isless() functions. For detailed insight have a look at the isless() implementation of Julia and BibInternal.jl.\n\nSupported symbols for sorting_rule are:\n\n:key (default): sort by bibliography keys e.g. BibTeX keys or :id\nthe sorting rules defined in sorting_rules\n\ninfo: Note:\nThe sorting is not following explicitly bibliographic alphabetizing conventions. It follows standard comparator behaviour implied by the implemented isless() functions (string comparators).\n\n\n\n\n\n","category":"function"},{"location":"#Bibliography.xcite-Tuple{Any}","page":"Bibliography","title":"Bibliography.xcite","text":"xcite(entry)\n\nFormat the BibTeX cite output of an Entry for web export.\n\n\n\n\n\n","category":"method"},{"location":"#Bibliography.xfile-Tuple{Any}","page":"Bibliography","title":"Bibliography.xfile","text":"xfile(entry)\n\nFormat the downloadable path of an Entry file for web export.\n\n\n\n\n\n","category":"method"},{"location":"#Bibliography.xin-Tuple{Any}","page":"Bibliography","title":"Bibliography.xin","text":"xin(entry)\n\nFormat the appears-in field of an Entry for web export.\n\n\n\n\n\n","category":"method"},{"location":"#Bibliography.xlabels-Tuple{Any}","page":"Bibliography","title":"Bibliography.xlabels","text":"xlabels(entry)\n\nFormat the labels of an Entry for web export.\n\n\n\n\n\n","category":"method"},{"location":"#Bibliography.xlink-Tuple{Any}","page":"Bibliography","title":"Bibliography.xlink","text":"xlink(entry)\n\nFormat the download link of an Entry for web export.\n\n\n\n\n\n","category":"method"},{"location":"#Bibliography.xnames","page":"Bibliography","title":"Bibliography.xnames","text":"xnames(entry, editors = false; names = :full)\n\nFormat the name of an Entry for web export.\n\nArguments:\n\nentry: an entry\neditors: true if the name describes editors\nnames: :full (full names) or :last (last names + first name abbreviation)\n\n\n\n\n\n","category":"function"},{"location":"#Bibliography.xtitle-Tuple{Any}","page":"Bibliography","title":"Bibliography.xtitle","text":"xtitle(entry\n\nFormat the title of an Entry for web export.\n\n\n\n\n\n","category":"method"},{"location":"#Bibliography.xyear-Tuple{Any}","page":"Bibliography","title":"Bibliography.xyear","text":"xyear(entry)\n\nFormat the year of an Entry for web export.\n\n\n\n\n\n","category":"method"},{"location":"parser/","page":"BibParser","title":"BibParser","text":"","category":"page"},{"location":"parser/","page":"BibParser","title":"BibParser","text":"Modules = [BibParser]","category":"page"},{"location":"parser/#Base.iszero-Tuple{Tuple}","page":"BibParser","title":"Base.iszero","text":"Base.iszero(t::Tuple)\n\nExtends iszero to Tuple types. Return true iff all elements of t are equal to zero.\n\n\n\n\n\n","category":"method"},{"location":"parser/#Base.occursin-Tuple{Any, Char}","page":"BibParser","title":"Base.occursin","text":"Base.occursin(re, char::Char)\n\nExtends occursin to test if a regular expression re is a match with a Char.\n\n\n\n\n\n","category":"method"},{"location":"parser/#BibParser.parse_entry-Tuple{Any}","page":"BibParser","title":"BibParser.parse_entry","text":"parse_entry(entry::String; parser::Symbol = :BibTeX)\n\nParse a string entry. Default to BibTeX format. No other options available yet (CSL-JSON coming soon).\n\n\n\n\n\n","category":"method"},{"location":"parser/#BibParser.parse_file-Tuple{Any}","page":"BibParser","title":"BibParser.parse_file","text":"parse_file(path::String; parser::Symbol = :BibTeX)\n\nParse a bibliography file. Default to BibTeX format. No other options available yet (CSL-JSON coming soon).\n\n\n\n\n\n","category":"method"}]
}
