
"""
A normalized file system path
"""
struct NormalizedPath
    _inner::Path

    function NormalizedPath(path::String, windows::Union{Bool,Nothing}=nothing)
        return new(normpath(Path(path, windows)))
    end
end

Base.homedir(::Type{NormalizedPath}) = NormalizedPath(homedir(), Sys.iswindows())
Base.isabspath(path::NormalizedPath) = isabspath(path._inner)
is_current_platform(path::NormalizedPath) = is_current_platform(path._inner)

Base.normpath(path::NormalizedPath) = path
