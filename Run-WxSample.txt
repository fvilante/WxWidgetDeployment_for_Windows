function compile_wx { mingw32-make -j4 -f makefile.gcc BUILD=release UNICODE=1 SHARED=0 CXXFLAGS="-std=gnu++11"}

$name = $args[0]
cd $name
compile_wx
cd gcc_mswu
Invoke-Expression (dir *.exe)
cd ..\..