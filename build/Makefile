ALL=$(wildcard Dockerfile.*)
LOGS=$(ALL:Dockerfile.%=log.%)
MDS=$(ALL:Dockerfile.%=md.%)

all: README.md $(LOGS)
	@ :

log.%: Dockerfile.%
	rm -f ok.$* err.$*
	if docker build --no-cache --rm -f Dockerfile.$* . >log.$* 2>&1; then \
		touch ok.$*; \
	else \
		touch err.$*; \
	fi

md.%: log.%
	if [ -e ok.$* ]; then \
		echo '| [$*](build/log.$*) | OK |' > $@; \
	else \
		echo '| [$*](build/log.$*) | FAIL |' > $@; \
	fi

README.md: $(MDS)
	cat header.md > $@
	echo "| Distro | Result |" >> $@
	echo "| ------ | ------ |" >> $@
	cat $^ >> $@

clean:
	rm -f $(LOGS) ok.* err.* md.*

.PRECIOUS: $(LOGS) README.md

