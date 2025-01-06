function Paths.Path(uri::AbstractURI, windows=false)
    uri_parts = URIParts(uri)
    
    if scheme(uri_parts) != "file"
        throw(ArgumentError("$uri does not have the file scheme."))
    end

    path_part = path(uri_parts)
    host = authority(uri_parts)

    if host!==nothing && host != "" && length(path_part) > 1
        # unc path: file://shares/c$/far/boo
        value = "//$host$path_part"
    elseif length(path_part) >= 3 &&
            path_part[1] == '/' &&
            isascii(path_part[2]) && isletter(path_part[2]) &&
            path_part[3] == ':'
        # windows drive letter: file:///c:/far/boo
        value = path_part[2] * path_part[3:end]
    else
        # other path
        value = path_part
    end

    if windows
        value = replace(value, '/' => '\\')
    end

    return Paths.Path(value)
end

function URIParts(path::Paths.Path)
    isabspath(path) || throw(ArgumentError("Relative path `$path` is not valid."))

    if Sys.iswindows(path)
        path = normpath(path)
    end

    path_as_string = Sys.iswindows(path) ? replace(path._inner, "\\" => "/") : path._inner

    authority = ""

    if startswith(path_as_string, "//")
        # UNC path //foo/bar/foobar
        idx = findnext("/", path_as_string, 3)
        if idx===nothing
            authority = path_as_string[3:end]
            path_as_string = "/"
        else
            authority = path_as_string[3:idx.start-1]
            path_as_string = path_as_string[idx.start:end]
        end
    elseif length(path_as_string)>=2 && isascii(path_as_string[1]) && isletter(path_as_string[1]) && path_as_string[2]==':'
        path_as_string = string('/', path_as_string)
    end

    return URIParts(scheme="file", authority=authority, path=path_as_string)
end

function URI(path::Paths.Path)
    return URI(URIParts(path))
end

