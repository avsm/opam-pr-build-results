ALL=$(wildcard Dockerfile.*)
LOGS=$(ALL:Dockerfile.%=log.%)
MDS=$(ALL:Dockerfile.%=md.%)

BASEURL=https://github.com/avsm/opam-pr-build-results

all: README.md $(LOGS)
	@ :

log.%: Dockerfile.%
	rm -f ok.$* err.$*
	if docker build --rm -f Dockerfile.$* . >log.$* 2>&1; then \
		touch ok.$*; \
	else \
		touch err.$*; \
	fi

md.%: log.%
	if [ -e ok.$* ]; then \
		echo '| [$*]($(BASEURL)/log.$*) | OK |' > $@; \
	else \
		echo '| [$*]($(BASEURL)/log.$* | FAIL |' > $@; \
	fi

README.md: $(MDS)
	echo "| distro | result |" > $@
	cat $^ >> $@

clean:
	rm -f $(LOGS) ok.* err.* md.*

.PRECIOUS: $(LOGS) README.md

