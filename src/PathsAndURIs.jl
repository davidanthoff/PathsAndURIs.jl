module PathsAndURIs

export AbstractURI, URI, URIParts, @uri_str, Path, @path_str, scheme, authority, path, query, fragment

include("decode.jl")
include("encode.jl")
include("vendored_from_uris.jl")
include("types.jl")
include("uri.jl")
include("uriparts.jl")
include("path.jl")
include("public_api.jl")

end
