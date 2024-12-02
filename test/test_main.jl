@testitem "filepath2uri to string" begin
    @test string(URI(path"c:/win/path")) == "file:///c%3A/win/path"
    @test string(URI(path"C:/win/path")) == "file:///C%3A/win/path"
    @test string(URI(path"c:/win/path/")) == "file:///c%3A/win/path/"
    @test string(URI(path"/c:/win/path")) == "file:///c%3A/win/path"
end

@testitem "filepath2uri to string - Windows special" begin
    @test string(URI(path"c:\\win\\path")) == "file:///c%3A/win/path"
    @test string(URI(path"c:\\win/path")) == "file:///c%3A/win/path"
    @test string(URI(Path("c:\\win\\path", false))) == "file:///c%3A%5Cwin%5Cpath"
    @test string(URI(Path("c:\\win/path", false))) == "file:///c%3A%5Cwin/path"
end

@testitem "uri2filepath to string - Windows special" begin
    @test string(Path(URI(path"c:\\win\\path"), true)) == "c:\\win\\path"
    @test string(Path(URI(path"c:\\win/path"), true)) == "c:\\win\\path"

    @test string(Path(URI(path"c:/win/path"), true)) == "c:\\win\\path"
    @test string(Path(URI(path"c:/win/path/"), true)) == "c:\\win\\path\\"
    @test string(Path(URI(path"C:/win/path"), true)) == "C:\\win\\path"
    @test string(Path(URI(path"/c:/win/path"), true)) == "c:\\win\\path"
    @test_throws ArgumentError URI(path"./c/win/path")
    @test string(Path(URI(path"c:/win/path"))) == "c:/win/path"
    @test string(Path(URI(path"c:/win/path/"))) == "c:/win/path/"
    @test string(Path(URI(path"C:/win/path"))) == "C:/win/path"
    @test string(Path(URI(path"/c:/win/path"))) == "c:/win/path"
    @test_throws ArgumentError URI(path"./c/win/path")
end

@testitem "uri2filepath - no `uri2filepath` when no `path`" begin
    value = uri"file://%2Fhome%2Fticino%2Fdesktop%2Fcpluscplus%2Ftest.cpp"

    @test authority(value) == "/home/ticino/desktop/cpluscplus/test.cpp"
    @test path(value) == ""    
end

@testitem "parse" begin
    value = URIParts("http:/api/files/test.me?t=1234")
    @test scheme(value) == "http"
    @test authority(value) === nothing
    @test path(value) == "/api/files/test.me"
    @test query(value) == "t=1234"
    @test fragment(value) === nothing

    value = URIParts("http://api/files/test.me?t=1234")
    @test scheme(value) == "http"
    @test authority(value) == "api"
    @test path(value) == "/files/test.me"
    @test query(value) == "t=1234"
    @test fragment(value) === nothing

    value = URIParts("file:///c:/test/me")
    @test scheme(value) == "file"
    @test authority(value) == ""
    @test path(value) == "/c:/test/me"
    @test fragment(value) === nothing
    @test query(value)=== nothing
    @test string(Path(value, true)) == "c:\\test\\me"
    @test string(Path(value, false)) == "c:/test/me"

    value = URIParts("file://shares/files/c%23/p.cs")
    @test scheme(value) == "file"
    @test authority(value) == "shares"
    @test path(value) == "/files/c#/p.cs"
    @test fragment(value) === nothing
    @test query(value) === nothing
    @test string(Path(value, true)) == "\\\\shares\\files\\c#\\p.cs"
    @test string(Path(value, false)) == "//shares/files/c#/p.cs"

    value = URIParts("file:///c:/Source/Z%C3%BCrich%20or%20Zurich%20(%CB%88zj%CA%8A%C9%99r%C9%AAk,/Code/resources/app/plugins/c%23/plugin.json")
    @test scheme(value) == "file"
    @test authority(value) == ""
    @test path(value) == "/c:/Source/Zürich or Zurich (ˈzjʊərɪk,/Code/resources/app/plugins/c#/plugin.json"
    @test fragment(value) === nothing
    @test query(value) === nothing

    value = URIParts("file:///c:/test %25/path")
    @test scheme(value) == "file"
    @test authority(value) == ""
    @test path(value) == "/c:/test %/path"
    @test fragment(value) === nothing
    @test query(value) === nothing

    value = URIParts("inmemory:")
    @test scheme(value) == "inmemory"
    @test authority(value) === nothing
    @test path(value) === ""
    @test query(value) === nothing
    @test fragment(value) === nothing

    value = URIParts("foo:api/files/test")
    @test scheme(value) == "foo"
    @test authority(value) === nothing
    @test path(value) == "api/files/test"
    @test query(value) === nothing
    @test fragment(value) === nothing

    value = URIParts("file:?q")
    @test scheme(value) == "file"
    @test authority(value) === nothing
    @test path(value) == ""
    @test query(value) == "q"
    @test fragment(value) === nothing

    value = URIParts("file:#d")
    @test scheme(value) == "file"
    @test authority(value) === nothing
    @test path(value) == ""
    @test query(value) === nothing
    @test fragment(value) == "d"

    value = URIParts("f3ile:#d")
    @test scheme(value) == "f3ile"
    @test authority(value) === nothing
    @test path(value) === ""
    @test query(value) === nothing
    @test fragment(value) == "d"

    value = URIParts("foo+bar:path")
    @test scheme(value) == "foo+bar"
    @test authority(value) === nothing
    @test path(value) == "path"
    @test query(value) === nothing
    @test fragment(value) === nothing

    value = URIParts("foo-bar:path")
    @test scheme(value) == "foo-bar"
    @test authority(value) === nothing
    @test path(value) == "path"
    @test query(value) === nothing
    @test fragment(value) === nothing

    value = URIParts("foo.bar:path")
    @test scheme(value) == "foo.bar"
    @test authority(value) === nothing
    @test path(value) == "path"
    @test query(value) === nothing
    @test fragment(value) === nothing
end
