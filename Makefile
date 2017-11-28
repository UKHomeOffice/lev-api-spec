arch = amd64
os = linux
dapperdox-version = 1.1.1

test-url = http://localhost/
token = DUMMY
username = test
client = test

.PHONY: all clean dapperbox dapperbox-theme-gov-uk deps deps-listen deps-test dredd docker docker-test got-swag listen npm test

all: deps test listen

clean:
	rm -rf ".deps/dapperdox"*
	rm -rf ".deps/node_modules/"
	rm -f "bin/dredd"
	rm -f "bin/got-swag"

listen: deps-listen
	bin/dapperdox

test: deps-test contract-test monkey-test

contract-test: dredd
	bin/dredd "./swagger.yaml" "$(test-url)" \
	          -h "Authorization: Bearer $(token)" \
	          -h "X-Auth-Username: $(username)" \
	          -h "X-Auth-Aud: $(client)"

monkey-test: got-swag
	bin/got-swag "./swagger-internal.yaml" -m

docker: docker-test

docker-test: deps-test
	docker build \
	       -t lev-api-test \
	       -f ./test.Dockerfile \
	       .

deps: deps-listen deps-test

deps-listen: dapperdox dapperdox-theme-gov-uk

deps-test: dredd got-swag

dapperdox: .deps/dapperdox

.deps/dapperdox:
	mkdir -p ".deps"
	cd ".deps" \
		&& curl -L "https://github.com/DapperDox/dapperdox/releases/download/v$(dapperdox-version)/dapperdox-$(dapperdox-version).$(os)-$(arch).tgz" | tar -zx \
		&& ln -fs "dapperdox-$(dapperdox-version).$(os)-$(arch)" "dapperdox"

dapperdox-theme-gov-uk: .deps/dapperdox-theme-gov-uk

.deps/dapperdox-theme-gov-uk: .deps/dapperdox
	mkdir -p ".deps"
	cd ".deps" \
		&& git clone "https://github.com/companieshouse/dapperdox-theme-gov-uk.git"
	ln -fs "../../../dapperdox-theme-gov-uk/" ".deps/dapperdox/assets/themes/dapperdox-theme-gov-uk"

dredd: bin/dredd

bin/dredd: .deps/node_modules/.bin/dredd
	mkdir -p "bin"
	ln -fs "../.deps/node_modules/.bin/dredd" "bin/dredd"

.deps/node_modules/.bin/%:
	mkdir -p ".deps"
	cd ".deps" \
		&& npm install

got-swag: bin/got-swag

bin/got-swag: .deps/node_modules/.bin/got-swag
	mkdir -p "bin"
	ln -fs "../.deps/node_modules/.bin/got-swag" "bin/got-swag"
