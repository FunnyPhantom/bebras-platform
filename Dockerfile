FROM ubuntu:22.10
LABEL authors="moha"

ENTRYPOINT ["top", "-b"]