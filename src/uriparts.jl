function URIParts(uri::URIParts)
    return uri
end

function URIParts(uri::URI)
    return URIParts(uri._inner)
end

function URIParts(uri::String)
    m = match(r"^(([^:/?#]+):)?(//([^/?#]*))?([^?#]*)(\?([^#]*))?(#(.*))?", uri)

    m===nothing && throw(ArgumentError("`$uri` is not a valid URI."))

    return URIParts(
        m.captures[2],
        m.captures[4]===nothing ? nothing : percent_decode(m.captures[4]),
        m.captures[5]===nothing ? nothing : percent_decode(m.captures[5]),
        m.captures[7]===nothing ? nothing : percent_decode(m.captures[7]),
        m.captures[9]===nothing ? nothing : percent_decode(m.captures[9])
    )
end

function URIParts(;
    scheme::Union{AbstractString,Nothing}=nothing,
    authority::Union{AbstractString,Nothing}=nothing,
    path::AbstractString="",
    query::Union{AbstractString,Nothing}=nothing,
    fragment::Union{AbstractString,Nothing}=nothing
    )
    return URIParts(scheme, authority, path, query, fragment)
end

function Base.print(io::IO, uri::URIParts)
 	if scheme(uri)!==nothing
        print(io, scheme(uri))
        print(io, ':')
 	end

 	if authority(uri)!==nothing
        print(io, "//")

		idx = findfirst("@", authority(uri))
		if idx !== nothing
			# <user>@<auth>
			userinfo = SubString(authority(uri), 1:idx.start-1)
			host_and_port = SubString(authority(uri), idx.start + 1)
			encode(io, userinfo, is_rfc3986_userinfo)
            print(io, '@')
        else
            host_and_port = SubString(authority(uri), 1)
		end

		idx3 = findfirst(":", host_and_port)
		if idx3 === nothing
            encode_host(io, host_and_port)
		else
			# <auth>:<port>
            encode_host(io, SubString(host_and_port, 1:idx3.start-1))
			print(io, SubString(host_and_port, idx3.start))
        end
     end

     # Append path
     encode_path(io, path(uri))

    if query(uri)!==nothing
        print(io, '?')
        encode(io, query(uri), is_rfc3986_query)
    end

 	if fragment(uri)!==nothing
        print(io, '#')
        encode(io, fragment(uri), is_rfc3986_fragment)
    end

    return nothing
end

function Base.string(uri::URIParts)
    io = IOBuffer()

    print(io, uri)

    return String(take!(io))
end
