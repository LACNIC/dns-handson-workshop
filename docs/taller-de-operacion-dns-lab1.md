# Taller de operación DNS


## Lab 1: Exploración del árbol de DNS

Hay muchas herramientas para utilizar para este propósito:

- nslookup (disponible en Windows)
- dig (unix, mac)
- drill (unix, mac)
- DnsViz (Web)
- HE Network Tools (Android / iOS)

La más popular y más usada es **dig**, y es la que usaremos en los ejemplos de hoy. Esta herramienta esta disponible en Mac y todos los Unix (existen versiones compiladas para Windows también, pero es raro encontrar una máquina que la tenga instalada).

```
# consulta genérica
dig www.lacnic.net
```

```
# consulta a un servidor específico por un registro específico
dig @8.8.8.8 www.lacnic.net AAAA
```

```
# consulta con y sin recursion
dig @8.8.8.8 [+norec | +rec] www.lacnic.net
```

```
# consulta con el SOA corto
dig +short soa www.lacnic.net
```

```
# consulta prendiendo y apagando algunas secciones
dig +noall +answer www.lacnic.net
```

```
# consulta forzando tcp o transporte ipv6
dig +tcp +6 A www.lacnic.net
```

## Exploracion:

### 1. Identificar los servidores de nombre de un dominio

Identificar los servidores DNS que responden para los dominios:
1. lacnic.net
2. antel.com.uy
3. lactld.org
4. labs.lacnic.net

Preguntas a responder:

1. ¿Cuáles son los TTLs de los registros NS?
2. ¿Cuáles son los TTLs de los registros A y AAA asociados?
3. 