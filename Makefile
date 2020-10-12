arch = amd64
os = linux
dapperdox-version = 1.1.1

test-url = http://localhost/
token = DUMMY
username = $(USER)
client = dredd
roles = "birth,death,marriage,partnership,full-details"

.PHONY: all clean dapperbox dapperbox-theme-gov-uk deps deps-docs deps-test dredd docker docker-docs docker-test docs npm test

all: deps test docs

clean:
	rm -rf ".deps/dapperdox"*
	rm -rf ".deps/node_modules/"
	rm -f "bin/dredd"

docs: deps-docs
	bin/dapperdox

test: deps-test
	bin/dredd "./swagger.yaml" "$(test-url)" \
	          -h "Authorization: Bearer $(token)" \
	          -h "X-Auth-Username: $(username)" \
	          -h "X-Auth-Aud: $(client)" \
	          -h "X-Auth-Roles: $(roles)"

docker: docker-docs docker-test

docker-docs: deps-docs
	docker build \
	       -t lev-api-docs \
	       -f ./docs.Dockerfile \
	       .

docker-test: deps-test
	docker build \
	       -t lev-api-test \
	       -f ./test.Dockerfile \
	       .

deps: deps-docs deps-test

deps-docs: dapperdox dapperdox-theme-gov-uk

deps-test: dredd

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

.deps/node_modules/.bin/dredd:
	mkdir -p ".deps"
	cd ".deps" \
		&& npm install
