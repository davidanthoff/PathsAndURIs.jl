function Base.string(uri::URI)
    return uri._inner
end

function URI(uri::URIParts)
    return URI(string(uri))
end
