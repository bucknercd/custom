CHART_NAME=custom
CHART_VERSION=0.1.0
CHART_PACKAGE=$(CHART_NAME)-$(CHART_VERSION).tgz
CHART_REPO_URL=https://github.com/bucknercd/custom/raw/main

all: clean package index

package:
	@echo "📦 Packaging Helm chart..."
	@helm package .

index:
	@echo "📝 Rebuilding index.yaml..."
	@helm repo index . --url $(CHART_REPO_URL)

clean:
	@echo "🧹 Cleaning up old chart packages..."
	@rm -f $(CHART_NAME)-*.tgz
