module PathsAndURIs

export AbstractURI, URI, URIParts, @uri_str, Path, @path_str, scheme, authority, path, query, fragment

include("Paths/Paths.jl")
include("URIs/URIs.jl")

using .Paths: Path, @path_str
using .URIs: AbstractURI, URI, URIParts, @uri_str, scheme, authority, path, query, fragment

end
