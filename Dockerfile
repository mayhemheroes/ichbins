FROM --platform=linux/amd64 ubuntu:20.04 as builder

RUN apt-get update
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y build-essential

ADD . /ichbins
WORKDIR /ichbins
RUN make

RUN mkdir -p /deps
RUN ldd /ichbins/ichbins | tr -s '[:blank:]' '\n' | grep '^/' | xargs -I % sh -c 'cp % /deps;'

FROM ubuntu:20.04 as package

COPY --from=builder /deps /deps
COPY --from=builder /ichbins/ichbins /ichbins/ichbins
ENV LD_LIBRARY_PATH=/deps
