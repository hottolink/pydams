all: build test install

clean:
	rm -rf ./build ./pydams.egg-info ./pydams.DAMS.so

build:
	python setup.py build_ext --inplace

test:
	python setup.py test

install:
	python setup.py install