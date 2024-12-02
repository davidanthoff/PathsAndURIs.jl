abstract type AbstractURI end

"""
A type that stores a URI as an percent encoded string
"""
struct URI <: AbstractURI
    _inner::String

    function URI(uri::String)
        return new(uri)
    end
   
end

"""
A type that stores a URI as individual parts (that are not encoded)
"""
struct URIParts <: AbstractURI
    _scheme::Union{String,Nothing}
    _authority::Union{String,Nothing}
    _path::String
    _query::Union{String,Nothing}
    _fragment::Union{String,Nothing}
end

"""
A file system path
"""
struct Path
    _inner::String
    _windows::Bool

    function Path(path::String, windows::Union{Bool,Nothing}=nothing)
        return new(path, something(windows, true))
    end
end
