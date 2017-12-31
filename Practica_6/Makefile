#file = sudoku
file = tomografia

$(file): $(file).pl
	swipl -O -q -g main --stand_alone=true -o $(file) -c $(file).pl

clean:
	rm -rf $(file)
