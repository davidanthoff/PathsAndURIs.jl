macro uri_str(ex)
    return URI(ex)
end

function scheme(uri::AbstractURI)
    parts = URIParts(uri)

    return parts._scheme
end

function authority(uri::AbstractURI)
    parts = URIParts(uri)

    return parts._authority
end

function path(uri::AbstractURI)
    parts = URIParts(uri)

    return parts._path
end

function query(uri::AbstractURI)
    parts = URIParts(uri)

    return parts._query
end

function fragment(uri::AbstractURI)
    parts = URIParts(uri)

    return parts._fragment
end
