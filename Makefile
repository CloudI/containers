VERSION := 0.0.1
CLOUDI_VERSION := 1.7.2
CLOUDI_TAG := "balvez/cloudi:$(VERSION)"
CLOUDI_URL := https://sourceforge.net/projects/cloudi/files/$(CLOUDI_VERSION)/cloudi-$(CLOUDI_VERSION).tar.gz/download
SOURCE_TAG := "balvez/cloudi:latest"

.PHONY: build-docker
build-docker: tmp/cloudi/
	@docker build . -t $(CLOUDI_TAG)
	@docker build . -t $(SOURCE_TAG)
	@echo "Docker image created successfully!"

.PHONY: clean
clean:
	rm -rf tmp/

tmp/:
	mkdir $@

tmp/cloudi.tar.gz: | tmp/
	wget --content-disposition $(CLOUDI_URL) -O $@

tmp/cloudi/: tmp/cloudi.tar.gz
	mkdir $@
	tar zxvf $< -C $@
	cp cloudi_minimal.conf.in tmp/cloudi/cloudi*/src/


