using Compat

vers = "1.12.1"

tagfile = "installed_vers"
target = "libblosc.$(Compat.Libdl.dlext)"
url = "https://bintray.com/artifact/download/julialang/generic/"

if !isfile(target) || !isfile(tagfile) || readchomp(tagfile) != "$vers $(Sys.WORD_SIZE)"
    if Compat.Sys.iswindows()
        download(url*"libblosc$(Sys.WORD_SIZE)-$vers.dll", target)
    elseif Compat.Sys.isapple()
        download(url*"libblosc$(Sys.WORD_SIZE)-$vers.dylib", target)
    else
        tarball = "c-blosc-$vers.tar.gz"
        srcdir = "c-blosc-$vers/blosc"
        if !isfile(tarball)
            download("https://github.com/Blosc/c-blosc/archive/v$vers.tar.gz", tarball)
        end
        run(`tar xzf $tarball`)
        cd(srcdir) do
            println("Compiling libblosc...")
            run(`make -f ../../make.blosc LIB=../../$target`)
        end
    end
    open(tagfile, "w") do f
        println(f, "$vers $(Sys.WORD_SIZE)")
    end
end
