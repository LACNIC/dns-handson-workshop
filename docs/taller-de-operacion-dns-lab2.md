# Taller de operación DNS LACNIC

## Lab 2: Configuración de servidores DNS autoritativos

## Pre-requisitos

- Repasar habilidades básicas de Unix / Linux
  - Manejo de archivos (copiar, mover, links)
  - Edición de archivos con vi (entrar, editar, grabar archivos)
- Traer
  - notebook con
    - Terminal y ssh
    - Utilizar el editor "vi"
    - algun editor de texto plano (TextWrangler para la Mac es una buena opción)
    - Slack instalado y configurado el canal "#dnsworkshop"
      - Ingresar: https://lacnic-eng.slack.com/messages/C8EA544V8

## Acceso

Usando ssh:

```shell
ssh -l tallerdns lisa.labs.lacnic.net 
```

Credenciales:

- usuario: tallerdns
- clave: lacnic2019

## Agenda

1. Repaso de conceptos de DNS
   1. Registros, zonas
   2. Consultas básicas con dig / drill
2. Lab 2.1:  _Inspeccionando zonas existentes_
   1. Set up del laboratorio
   2. Obtener información acerca de una zona ejemplo
3. Delegación de zonas directas
4. Lab 2.2:  _Delegación desde la raiz a un dominio de segundo nivel: Mi propio ccTLD_
   1. Set up del laboratorio
   2. Inspeccionar mi propia infraestructura
   3. Comunicar la delegación al operador de la raíz
   4. Verificar la correcta operación



## Operación del lab

Cada grupo de trabajo (1 o más asistentes) operará dos servidores bind, llamados "groupXa" y "groupXb", donde X es el número del grupo.

Los pasos para acceder a los mismos son:

1. Acceder al servidor del lab, ```ssh -l tallerdns lisa.labs.lacnic.net```
2. Entrar al directorio correspondiente a cada servidor, ```cd $HOME/dns-workshop.git/dfiles/bind9/groupXa```
3. Para arrancar el servidor: ```make start```
4. Para detener el servidor: ```make stop```
5. Para abrir un shell en el servidor: ```make shell```

## Archivo de zona ejemplo

Se puede utilizar el siguiente template como archivo de zona para luego modificar:

```
florida.                10 IN SOA a.florida. admin.gmail.com. (
                                2018010100 ; serial
                                30         ; refresh
                                900        ; retry (15 minutes)
                                604800     ; expire (1 week)
                                86400      ; minimum (1 day)
                                )

;
florida.                10      IN      NS      a.florida.
florida.                10      IN      NS      b.florida.
a.florida.              10      IN      A       172.77.1.1
b.florida.              10      IN      A       172.77.1.2
;
turismo                 10      IN      A       192.168.15.15
turismo                 10      IN      AAAA    2001:db8:dead:beef::1
```

