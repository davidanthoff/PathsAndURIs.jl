# URIs2

A different take on types for URIs (and also a Path type, that should probably eventually move into its own repo).

This is more of an experiment at the moment and _not_ production ready. It might eventually be picked up by the language
server, where the kind of functionality here would be very useful (and a slightly less developed version of this is already
used internally).

## Overview

The core idea is that for different situations different memory layouts for storing a URI a preferable. So this package
provides an abstract type `AbstractURI` that represents a URI, and then two different concrete types that can be
used to store a URI, where each of these two types has a different memory layout.

`URI` stores a URI as a percent encoded string. If the goal is to for example use an URI as a key in a dict, or a similar
design, then this can be be a good choice. The downside of this format is that accessing individual parts is expensive:
the string needs to be parsed, and then each part needs to be decoded before one can access any given part.

`URIParts` stores a URI as a collection of strings, i.e. it stores the URI content by part. Each of these parts is
already percent decoded, i.e. the field for each part just stores the raw part content as a string. This format is useful
when indvidual parts need to be accessed repeatedly, as no parsing or decoding needs to happen for that. On the flipside,
this representation puts more stress on the memory system, as each URI requires multiple strings to be stored.

The package also has a type `Path` that stores a filesystem path, plus a flag whether the path is a Windows path or not.
This type should probably eventually moved into a Paths.jl (or similar) package, but for now it lives here as well.
The path itself is simply stored as a `String`. The main use case is that it becomes easy to convert between a URI with
the `file` scheme a filesystem paths.
