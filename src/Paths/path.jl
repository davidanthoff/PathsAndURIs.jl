"""
A file system path
"""
struct Path <: AbstractPath
    _inner::SubString{String}
    _windows::Bool

    function Path(path::AbstractString, windows::Union{Bool,Nothing}=nothing)
        return new(SubString{String}(path), something(windows, Sys.iswindows()))
    end
end

Base.homedir(::Type{Path}) = Path(homedir())
Base.isabspath(path::Path) = isabspath(path._inner)
Base.normpath(path::Path) = Path(normpath(path._inner))
Sys.iswindows(path::Path) = path._windows
is_current_platform(path::Path) = Sys.iswindows() == path._windows

function Base.string(path::Path)
    return path._inner
end

macro path_str(ex)
    return Path(ex)
end