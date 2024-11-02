import Dates: Dates, Date
import YAML

"""
    import_cff(input) -> Entry
Import a CFF file and convert it to the internal bibliography format.
"""
function import_cff(input)
    # TODO decide how to treat errors
    entry, _ = BibParser.parse_file(input, :CFF)
    return entry
end

const BIB_TO_CFF_TYPES = Dict{String, String}(
    ["article" => "article"
     "book" => "book"
     "booklet" => "pamphlet"
     "manual" => "manual"
     "proceedings" => "proceedings"
     "unpublished" => "unpublished"]
)
"""
    export_cff(e::Entry, destination::String="CITATION.cff", version::String="1.2.0", add_preferred::Bool=true) -> Dict{String, Any}

Export an `Entry` to a CFF file (default is `CITATION.cff`).
"""
function export_cff(e::Entry; destination::String = "CITATION.cff",
        version::String = "1.2.0", add_preferred::Bool = true)
    cff = Dict{String, Any}()

    # mandatory fields
    cff["authors"] = map(
        name -> Dict(
            "family-names" => na_if_empty(name.last),
            "given-names" => na_if_empty(name.first * name.middle),
            "name-particle" => na_if_empty(name.particle),
            "name-suffix" => na_if_empty(name.junior)
        ),
        e.authors
    )
    cff["cff-version"] = version
    cff["message"] = "If you use this software, please cite it using the metadata from this file."
    cff["title"] = e.title

    cff["doi"] = na_if_empty(e.access.doi)
    cff["repository-code"] = na_if_empty(e.access.url)
    cff["date-released"] = "$(cff_parse_date(e.date))"

    if add_preferred
        preferred = deepcopy(cff)
        delete!(preferred, "cff-version")
        delete!(preferred, "message")

        start = split(e.in.pages, "--")
        preferred["start"] = na_if_empty(start[1])
        preferred["end"] = na_if_empty(length(start) == 2 ? start[2] : "")
        preferred["journal"] = na_if_empty(e.in.journal)
        preferred["issue"] = na_if_empty(e.in.number)
        preferred["volume"] = na_if_empty(e.in.volume)
        publisher = Dict{String, String}()
        publisher["name"] = na_if_empty(e.in.publisher)
        preferred["publisher"] = publisher
        preferred["type"] = get(BIB_TO_CFF_TYPES, e.type, "generic")

        cff["preferred-citation"] = preferred
    end

    YAML.write_file(destination, cff)

    return cff
end

function cff_parse_date(date::BibInternal.Date)
    Date(parse(Int, date.year), parse(Int, date.month), parse(Int, date.day))
end

"""
    na_if_empty(str::AbstractString) -> AbstractString

Use placeholder value if string param is empty.
"""
function na_if_empty(str::AbstractString)
    isempty(str) ? "N/A" : str
end
