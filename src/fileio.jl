"""
    fileio_load(file; check)
    fileio_load(stream; check)

The FileIO interface to import a BibTeX file or parse a BibTeX string and convert it to the internal bibliography format.
The `check` keyword argument can be set to `:none` (or `nothing`), `:warn`, or `:error` to raise appropriate logs.
"""
function fileio_load(file::FileIO.File{FileIO.format"BIB"}; check = :error)
    BibParser.parse_file(file.filename; check)
end

function fileio_load(stream::FileIO.Stream{FileIO.format"BIB"}; check = :error)
    BibParser.parse_entry(read(stream, String); check)
end

"""
    fileio_save(file, data)
    fileio_save(stream, data)

Export a bibliography as a BibTeX string to a file or stream.
"""
function fileio_save(file::FileIO.File{FileIO.format"BIB"}, data)
    open(file, "w") do f
        write(f, export_bibtex(data))
    end
end

function fileio_save(stream::FileIO.Stream{FileIO.format"BIB"}, data)
    write(stream, export_bibtex(data))
end
