arch = amd64
os = linux
dapperdox-version = 1.1.1

test-url = http://localhost/

.PHONY: all clean listen test deps dapperbox dapperbox-theme-gov-uk dredd npm

all: deps test listen

clean:
	rm -rf ".deps/dapperdox"*
	rm -rf ".deps/node_modules/"
	rm -f "bin/dredd"

listen: dapperdox dapperdox-theme-gov-uk
	bin/dapperdox

test: dredd
	bin/dredd "./swagger.yaml" "$(test-url)" -h "X-Auth-Username: test" -h "X-Auth-Aud: test"

deps: dapperdox dapperdox-theme-gov-uk dredd

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
