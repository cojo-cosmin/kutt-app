RELEASE ?= kutt-app
NS      ?= kutt-app
CHART   ?= .
ING_SVC ?= $(RELEASE)-ingress-nginx-controller
PORT    ?= 8080
TARGET  ?= 80

.PHONY: run install pf test uninstall

# one-shot: install then (blocking) port-forward
run: install pf

install:
	helm upgrade --install $(RELEASE) $(CHART) \
		-n $(NS) --create-namespace --dependency-update

pf:
	kubectl -n $(NS) port-forward svc/$(ING_SVC) $(PORT):$(TARGET) --address=127.0.0.1

test:
	curl -fsS http://127.0.0.1:$(PORT)/api/v2/health || true

uninstall:
	helm uninstall $(RELEASE) -n $(NS) || true
