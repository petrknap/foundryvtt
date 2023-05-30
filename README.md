# Dockerized [Foundry Virtual Tabletop]

This repository contains simple [makefile](./Makefile) to [dockerize](./Dockerfile) [Foundry Virtual Tabletop].


## How to dockerize it?

```bash
make docker-image
```

It is required to have [Foundry Virtual Tabletop] downloaded in this folder.
The download link will be displayed on the console if needed.


## How to use dockerized version?

```bash
make server        # to run server on foreground
make server-daemon # to run server as daemon
make server-murder # to kill server
```


---

You can [support this project via donation](https://petrknap.github.io/donate.html).


[Foundry Virtual Tabletop]:https://foundryvtt.com/
