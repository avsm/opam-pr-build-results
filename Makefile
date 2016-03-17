ALL=$(wildcard Dockerfile.*)
LOGS=$(ALL:Dockerfile.%=log.%)
MDS=$(ALL:Dockerfile.%=md.%)

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
		echo '| [$*](log.$*) | OK |' > $@; \
	else \
		echo '| [$*](log.$*) | FAIL |' > $@; \
	fi

README.md: $(MDS)
	echo "| distro | result |" > $@
	echo "| ------ | ------ |" >> $@
	cat $^ >> $@

clean:
	rm -f $(LOGS) ok.* err.* md.*

.PRECIOUS: $(LOGS) README.md

