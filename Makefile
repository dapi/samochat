APP=$(shell git remote show origin -n | grep 'Push  URL' | awk -F/ '{print $$2}' | awk -F. '{print $$1}')
INFRA_REPO= # git@github.com:safeblock-com/infra.git
WORKFLOW=backend-deploy.yml
DOCKER_TAG=`git describe --abbrev=0 --tags | sed -e 's/v//'`
STAGE=default
SEMVER_BIN=./bin/semver
SEMVER=`${SEMVER_BIN}`
SLEEP=5
GH=gh
INFRA_GH=gh --repo ${INFRA_REPO}
LATEST_INFRA_RUN_ID=`${INFRA_GH} run list --workflow=${WORKFLOW}  -L 3 -e workflow_dispatch --json databaseId -q.[0].databaseId`
LATEST_RUN_ID=`${GH} run list --workflow=release.yml -L 3 -e workflow_dispatch --json databaseId -q.[0].databaseId`

# Default target
release: patch-release deploy-capistrano

patch-release-and-deploy: patch-release watch deploy sleep infra-watch

minor:
	@${SEMVER_BIN} inc minor

patch:
	@${SEMVER_BIN} inc patch

bump-patch: patch push-semver
bump-minor: minor push-semver

push-semver:
	@echo "Increment version to ${SEMVER}"
	@git add .semver
	@git commit -m ${SEMVER}
	@git push

patch-release: bump-patch push-release
minor-release: bump-minor push-release

push-release:
	@gh release create ${SEMVER} --generate-notes
	@git pull --tags

sleep:
	@echo "Wait ${SLEEP} seconds for workflow to run"
	@sleep ${SLEEP}

deploy-capistrano:
	bundle
	bundle exec cap production deploy

deploy-infra:
	@echo "Trigger deploy for ${DOCKER_TAG}"
	@${INFRA_GH} workflow run ${WORKFLOW} -F tag=${DOCKER_TAG} -F app=${APP} -F stage=${STAGE}

watch:
	@${GH} run watch ${LATEST_RUN_ID}

infra-watch:
	@${INFRA_GH} run watch ${LATEST_INFRA_RUN_ID}

infra-view:
	@${INFRA_GH} run view ${LATEST_INFRA_RUN_ID} --log-failed

list:
	@${INFRA_GH} run list --workflow=${WORKFLOW} -L 3 -e workflow_dispatch

rake:
	bundle exec rake

rubocop:
	bundle exec rubocop -A

build:
	docker build .

lsp:
	gem install --user-install ruby-lsp
	gem install --user-install solargraph

sql:
	psql ${PRODUCTION_DATABASE_URL}
