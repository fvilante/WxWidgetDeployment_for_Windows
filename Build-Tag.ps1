$git_tag_version = $args[0]
cd $env:wxwin
git reset --hard $git_tag_version
git clean -x -d -f
cp $env:wxwin\include\wx\msw\setup0.h $env:wxwin\include\wx
mv $env:wxwin\include\wx\setup0.h $env:wxwin\include\wx\setup.h
cd  $env:wxwin\build\msw
mingw32-make -j4 -f makefile.gcc BUILD=release UNICODE=1 SHARED=0 CXXFLAGS="-std=gnu++11"