using Documenter, Bibliography, BibParser, BibInternal

makedocs(
    sitename = "Bibliography.jl",
    authors = "Jean-François BAFFIER",
    repo="https://github.com/Humans-of-Julia/Bibliography.jl/blob/{commit}{path}#L{line}",
    format = Documenter.HTML(
        prettyurls = get(ENV, "CI", nothing) == "true"
    ),
    pages = [
        "Bibliography" => "index.md",
        # "BibTeX" => "bibtex.md",
        # "BibTeX - automa" => "bibtex_automa.md",
        # "CSL-JSON" => "csl.md",
        "BibInternal" => "internal.md",
        "BibParser" => "parser.md"
    ]
)

deploydocs(; repo = "github.com/Humans-of-Julia/Bibliography.jl.git", devbranch = "master")
