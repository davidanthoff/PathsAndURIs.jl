@inline function is_rfc3986_unreserved(c::Char)
    return 'A' <= c <= 'Z' ||
        'a' <= c <= 'z' ||
        '0' <= c <= '9' ||
        c == '-' ||
        c == '.' ||
        c == '_' ||
        c == '~'
end

@inline function is_rfc3986_sub_delim(c::Char)
    return c == '!' ||
        c == '$' ||
        c == '&' ||
        c == '\'' ||
        c == '(' ||
        c == ')' ||
        c == '*' ||
        c == '+' ||
        c == ',' ||
        c == ';' ||
        c == '='
end

@inline function is_rfc3986_pchar(c::Char)
    return is_rfc3986_unreserved(c) ||
        is_rfc3986_sub_delim(c) ||
        c == ':' ||
        c == '@'
end

@inline function is_rfc3986_query(c::Char)
    return is_rfc3986_pchar(c) || c=='/' || c=='?'
end

@inline function is_rfc3986_fragment(c::Char)
    return is_rfc3986_pchar(c) || c=='/' || c=='?'
end

@inline function is_rfc3986_userinfo(c::Char)
    return is_rfc3986_unreserved(c) ||
        is_rfc3986_sub_delim(c) ||
        c == ':'
end

@inline function is_rfc3986_reg_name(c::Char)
    return is_rfc3986_unreserved(c) ||
        is_rfc3986_sub_delim(c)
end

function encode(io::IO, s::AbstractString, issafe::Function)
    for c in s
        if issafe(c)
            print(io, c)
        else
            print(io, '%')
            print(io, uppercase(string(Int(c), base=16, pad=2)))
        end
    end
end

@inline function is_ipv4address(s::AbstractString)
    if length(s)==1
        return '0' <= s[1] <= '9'
    elseif length(s)==2
        return '1' <= s[1] <= '9' && '0' <= s[2] <= '9'
    elseif length(s)==3
        return (s[1]=='1' && '0' <= s[2] <= '9' && '0' <= s[3] <= '9') ||
            (s[1]=='2' && '0' <= s[2] <= '4' && '0' <= s[3] <= '9') ||
            (s[1]=='2' && s[2] == '5' && '0' <= s[3] <= '5')
    else
        return false
    end
end

@inline function is_ipliteral(s::AbstractString)
    # TODO Implement this
    return false
end

function encode_host(io::IO, s::AbstractString)
    if is_ipv4address(s) || is_ipliteral(s)
        print(io, s)
    else
        # The host must be a reg-name
        encode(io, s, is_rfc3986_reg_name)
    end
end

function encode_path(io::IO, s::AbstractString)
    # TODO Write our own version
    print(io, escapepath(s))
end
