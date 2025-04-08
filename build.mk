# config.mk

# image build tag
tag ?= $(firstword $(MAKECMDGOALS)):01

# apt mirror
apt ?= 

ifeq ($(apt),)
  APT_MIRROR = 
else
  APT_MIRROR = apt-mirror/$(apt)
endif

# base image for LLVM
image ?= 

ifeq ($(image),)
  BASE_IMAGE = debian127:01
else
  BASE_IMAGE = $(image)
endif

