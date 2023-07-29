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

For security reasons, please switch the server to HTTPS,
set the SSL certificate and key paths in the application configuration.

You can issue a self-signed certificate using the command `make certificate`.
The certificate path will be `self-signed.crt` and key path will be `self-signed.key`.


## How to back up / restore it?

It is recommended to **shut down the server** before backing up or restoring.

```bash
make server-backup  # to back up server
make server-restore # to restore server
```

You can also back up the server manually by copying the `data` directory somewhere else.
You can restore a manual backup by copying it back to the `data` directory.


[Foundry Virtual Tabletop]:https://foundryvtt.com/

---

You can [support this project via donation](https://petrknap.github.io/donate.html).
The project is licensed under [the terms of the `LGPL-3.0-or-later`](./COPYING.LESSER).
