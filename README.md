# docker ssh 

# Debian

```
# default build
make debian127
# set apt mirror and image tag
make debian127 apt=aliyun tag=debianssh:01
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