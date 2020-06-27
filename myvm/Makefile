SAN=-fsanitize=address

ben : ben.cc
	g++ -std=c++2a $(SAN) -ggdb $^ -o $@

clean:
	rm -f ben
