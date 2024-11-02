"""
    select(
        bibliography::DataStructures.OrderedDict{String,Entry},
        selection::Vector{String};
        complementary::Bool = false
        )
Select a part of a bibliography based on a given selection set of keys. If complementary is true, selection designates which entries will not be kept. By default, complementary is set to false.
"""
function select(
        bibliography::DataStructures.OrderedDict{String, Entry},
        selection::Vector{String};
        complementary::Bool = false
)
    selected_bib = DataStructures.OrderedDict{String, Entry}()
    old_keys = keys(bibliography)
    new_keys = complementary ? setdiff(old_keys, selection) : intersect(old_keys, selection)

    for key in new_keys
        selected_bib[key] = bibliography[key]
    end

    return selected_bib
end
