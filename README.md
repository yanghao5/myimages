# docker ssh 

# Debian

```
go run main.go debian127
go run main.go debian127 -apt aliyun
```

# LLVM

```
# default build
make llvm17

# set base image and image tag
make llvm17 image=debianssh:01 tag=llvmop:01
```

# build clean

```
# NB
# it will remove all prune resource
make clean
```