include build.mk

# Debian
debian99:
ifeq ($(APT_MIRROR),)
	docker build -f Dockerfile.debian.v9_9 -t $(tag)  .
else
	docker build -f Dockerfile.debian.v9_9  --build-arg APT_MIRROR=$(APT_MIRROR) -t $(tag)  .
endif

debian127:
ifeq ($(APT_MIRROR),)
	docker build -f Dockerfile.debian.v12_7 -t $(tag)  .
else
	docker build -f Dockerfile.debian.v12_7  --build-arg APT_MIRROR=$(APT_MIRROR) -t $(tag)  .
endif

# LLVM
check_image:
ifeq ($(shell docker images -q ${BASE_IMAGE} 2> /dev/null),)
	ifeq ($(image),)
		$(error the default $(BASE_IMAGE) image not found)
	endif
	$(error $(BASE_IMAGE) image not found)
endif

llvm17: check_image
	$(info BUILD LLVM17)
	docker build -f Dockerfile.llvm.v17  --build-arg BASE_IMAGE=$(BASE_IMAGE) -t $(tag)  .

clean:
	docker system prune -a --volumes -f