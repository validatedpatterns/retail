.PHONY: default
default: help

.PHONY: help
# No need to add a comment here as help is described in common/
help:
	@printf "$$(grep -hE '^\S+:.*##' $(MAKEFILE_LIST) common/Makefile | sort | sed -e 's/:.*##\s*/:/' -e 's/^\(.\+\):\(.*\)/\\x1b[36m\1\\x1b[m:\2/' | column -c2 -t -s :)\n"

%:
	make -f common/Makefile $*

install upgrade: operator-deploy post-install ## installs the pattern, inits the vault and loads the secrets
	echo "Installed"

install-no-pipelines: operator-deploy
	echo "Installed without pipeline setup"

post-install:
	make load-secrets
	make start-pipelines

start-pipelines:
	./scripts/start_pipelines.sh

.PHONY: test
test:
	@make -f common/Makefile PATTERN_OPTS="-f values-global.yaml -f values-hub.yaml" test

.PHONY: kubeconform
kubeconform:
	make -f common/Makefile KUBECONFORM_SKIP='-skip PostgresCluster,Kafka,KafkaMirrorMaker' CHARTS="$(wildcard charts/all/*)" kubeconform
	make -f common/Makefile KUBECONFORM_SKIP='-skip Task,TaskRun,Pipeline,PipelineResource,PipelineRun' CHARTS="$(wildcard charts/hub/*)" kubeconform
	make -f common/Makefile CHARTS="$(wildcard charts/store/*)" kubeconform
