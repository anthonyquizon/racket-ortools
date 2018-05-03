
CC=clang
LIBS=-lortools
LDFLAGS=-L./extern/or-tools/lib
INCLUDE=-I./extern/or-tools/include
OPTS=-undefined dynamic_lookup -shared -fpic -std=c++11 -rpath ./extern/or-tools/lib

cwrapper.o: private/cwrapper.cpp
	$(CC) -std=c++11 -c $(INCLUDE) $(LDFLAGS) $(LIBS) $^ -o cwrapper.o

libcwrapper.dylib: cwrapper.o
	$(CC) $(OPTS) $(INCLUDE) $(LDFLAGS) $(LIBS) $^ -o libcwrapper.dylib 

foo: example.cpp
	$(CC) -undefined dynamic_lookup -rpath ./extern/or-tools/lib -std=c++11 $(INCLUDE) $(LDFLAGS) $(LIBS) $^ -o foo

clean: 
	rm -f cwrapper.o libcwrapper.dylib




#foo.o: private/foo.cpp
	#$(CC) -std=c++11 $(INCLUDE) $(LDFLAGS) $(LIBS) -o extern/foo $^

