## Taller de operación DNS LACNIC

# Documentación para el instructor

**Autor: carlos@lacnic.net**



## Pre-requisitos 

El ambiente se ha testeado y utilizado bajo Ubuntu 16.04. Es muy probable que funcione en Ubuntus mas recientes y en otros derivados de Debian.

- Docker
- Make



## Operación del ambiente

## Inicial

Compilar el contenedor docker:

```shell
$ make build
```

Crear el ambiente y la red

```shell
$ make network
$ make enableroot
```

Clonar los grupos de estudiantes

```shell
$ make clonegroups
```

## Para cada grupo:

TBW*
