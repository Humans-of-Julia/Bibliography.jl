[![Docs](https://img.shields.io/badge/docs-dev-blue.svg)](https://Humans-of-Julia.github.io/Bibliography.jl/dev)
[![Docs](https://img.shields.io/badge/docs-stable-blue.svg)](https://Humans-of-Julia.github.io/Bibliography.jl/stable)
[![Build Status](https://github.com/Humans-of-Julia/Bibliography.jl/workflows/CI/badge.svg)](https://github.com/Humans-of-Julia/Bibliography.jl/actions)
[![codecov](https://codecov.io/gh/Humans-of-Julia/Bibliography.jl/branch/master/graph/badge.svg?token=iiIHSFqA31)](https://codecov.io/gh/Humans-of-Julia/Bibliography.jl)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

# Bibliography.jl

Bibliography.jl is a Julia package for handling both import/export from various bibliographic format.

### Organization

This package comes as a set of 3 packages to convert bibliographies. This tool was split into three for the sake of the precompilation times.
- [Bibliography.jl](https://github.com/Humans-of-Julia/Bibliography.jl): the interface to import/export bibliographic items.
- [BibInternal.jl](https://github.com/Humans-of-Julia/BibInternal.jl): A julian internal format to translate from and into.
- [BibParser.jl](https://github.com/Humans-of-Julia/BibParser.jl): A container for different bibliographic format parsers (such as BibTeX).

### Packages using Bibliographies

- [StaticWebPages.jl]((https://github.com/Humans-of-Julia/StaticWebPages.jl)): a black-box generator for static websites oriented towards personal and/or academic pages. No knowledge of Julia nor any other programming language is required.

### Contributions are welcome
- Write new or integrate existing parsers to [BibParser.jl]((https://github.com/Humans-of-Julia/BibParser.jl)) (currently only a light BibTeX parser is available)
- Add import/export from existing bibliographic formats to [Bibliography.jl]((https://github.com/Humans-of-Julia/Bibliography.jl))
- Add export for non-bibliographic formats (such as in [StaticWebPages.jl]((https://github.com/Humans-of-Julia/StaticWebPages.jl)))

## Short documentation 

```julia
# Import a BibTeX file to the internal bib structure
imported_bib = import_bibtex(source_path::AbstractString)


# Select a part of a bibliography
selection = ["key1", "key2"]
selected_bib = select(imported_bib, selection) # select the intersection between the bibliography and `selection`
diff_bib = select(imported_bib, selection; complementary = true) # select the difference between the bibliography and `selection`

# Export from internal to BibTeX format
export_bibtex(target_path::AbstractString, bibliography)

# Check BibTeX rules, entry validity, clean and sort a bibtex file.
export_bibtex(target_path::AbstractString, import_bibtex(path_to_file::AbstractString))

# Export from internal to the Web Format of StaticWebPages.jl
export_web(bibliography)

# Export from BibTeX to the Web Format of StaticWebPages.jl
bibtex_to_web(source_path::AbstractString)
```
