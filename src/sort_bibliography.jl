"""
    const sorting_rules = Dict{Symbol, Vector{Symbol}}(
        :nty  => [:authors;:editors;:title;:date],
        :nyt  => [:authors;:editors;:date;:title]
    );

Implemented sorting rules for bibliography entry sorting.

See also [`sort_bibliography!`](@ref).
"""
const sorting_rules = Dict{Symbol, Vector{Symbol}}(
    :nty  => [:authors;:editors;:title;:date],
    :nyt  => [:authors;:editors;:date;:title]
);

"""
    sort_bibliography!(
        bibliography::DataStructures.OrderedDict{String,Entry},
        sorting_rule::Symbol = :key
        )

Sorts the bibliography in place.

The sorting order can be set by specifying the `sorting_rule`. The sorting is
implemented via `isless()` functions. For detailed insight have a look at the
`isless()` implementation of Julia and `BibInternal.jl`.

Supported symbols for `sorting_rule` are:
- `:key` __(default)__: sort by bibliography keys e.g. BibTeX keys or `:id`
- the sorting rules defined in [`sorting_rules`](@ref)

!!! info "Note:"
    The sorting is not following explicitly bibliographic alphabetizing
    conventions. It follows standard comparator behaviour implied by the
    implemented `isless()` functions (string comparators).
"""
function sort_bibliography!(
    bibliography::DataStructures.OrderedDict{String,Entry},
    sorting_rule::Symbol = :key
    )
# TODO: allow Union{Symbol,Vector{Symbol}} for a arbitrary custom sorting order
#       this needs one additional type check and a check for allowed symbols in
#       vector (check against fieldnames(Bibliography.BibInternal.Entry) )
    if sorting_rule == :key
        sort!(bibliography);
    elseif sorting_rule in keys(sorting_rules)
        sort!(bibliography,
              lt = (a,b) -> recursive_isless(a,b,sorting_rules[sorting_rule]),
              by = x -> bibliography[x]);
    else
        throw(ArgumentError("Unsupported sorting order!"));
    end
end

"""
    recursive_isless(a::Entry, b::Entry, fields::Tuple{Symbol},
                     depth::Int = 0)

Helper function for [`sort_bibliography!`](@ref).

This function allows recursive checking if `a < b` with descending importance.
The importance set for the comparison is defined by the argument `fields`. This
argument is a tuple consisting of symbols denoting the fields of the data type
`BibInternal.Entry`. The ordering implies the importance.

The `depth` argument is purely for iterating/recursive purposes.
"""
function recursive_isless(a::Entry, b::Entry, fields::Vector{Symbol},
                          depth::Int = 0)::Bool
    i = depth + 1;
    a_field = getfield(a,fields[i]);
    b_field = getfield(b,fields[i]);

    if (a_field == b_field)
        if i == length(fields)
            return false;
        else
            return recursive_isless(a,b,fields,i);
        end
    else
        return a_field < b_field;
    end
end
