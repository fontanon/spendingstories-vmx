Generador de entornos SpendingStories:
============================

¿Qué es esto?
-------------

El Generador de entornos SpendingStories comprende una serie de automatizaciones
para el despliegue de [SpendingStories](http://spendingstories.org) en entornos 
tanto de desarrollo como de producción.

Conceptos generales.
--------------------

En líneas generales, el generador de entornos SpendingStories realiza tres operaciones:

-   Construir una **vmx VirtualBox** basada en Ubuntu 13.04
-   **Instalar SpendingStories** y sus dependencias.
-   Opcionalmente, realizar un **despliegue en la nube**. Actualmente sólo 
    [DigitalOcean](http://digitalocean.com) es soportado (próximamente AWS).

El generador de entornos SpendingStories está basado en
[Vagrant](http://www.vagrantup.com) +
[CHEF-solo](http://www.getchef.com/chef) :

-   [Vagrant](http://www.vagrantup.com) es una herramienta para la
    creación y configuración de entornos de desarrollo virtualizados. Lo
    utilizaremos para generar máquinas virtuales para el entornos SpendingStories.
    
-   [CHEF-solo](http://www.getchef.com/chef) es parte de la suite
    CHEF, una herramienta de gestión de la configuración. CHEF-solo está
    indicado para provisionar entornos en los que solo hace falta
    desplegar software, y no realizar una gestión de la configuración
    completa. Lo utilizamos para programar la receta de despliegue de
    [SpendingStories](http://spendingstories.org) y sus dependencias
    
Requisitos previos
------------------


Para poder usar el generador de entornos SpendingStories es necesario:

-   **Tener instalado VirtualBox** (se recomienda [versión Oracle
    1.4.3](https://www.virtualbox.org/wiki/Downloads))
-   **Tener instalado Vagrant** (se recomienda [versión
    4.3](http://www.vagrantup.com/downloads.html)). 

SpendingStories en dos sabores: Maquina virtual y en la Nube 
---------------------------------------------------

### Opción 1: SpendingStories en una Máquina Virtual (con VirtualBox)

Con VirtualBox y Vagrant, procedemos a instalar el plugin de omnibus:

    user@host:~/spendingstories-vmx$ vagrant plugin install vagrant-omnibus

Y ya podemos lanzar la construcción del entorno SpendingStories:

    user@host:~/spendingstories-vmx$ vagrant up

Tras unos 15 minutos, si no hay errores ya podremos acceder por ssh a
nuestro recién-construido-entorno con

    user@host:/spendingstories-vmx$ vagrant ssh

Y desde nuestra máquina host podemos acceder a SpendingStories:

-   http://192.168.56.101

El usuario/contraseña de administrador por defecto es admin/admin. 
Te recomendamos que lo primero que hagas sea modificarla.

### Opción 2: SpendingStories en la nube con DigitalOcean

[DigitalOcean](http://digitalocean.com) es un proveedor de servicios *cloud-computing* 
que cuenta con una serie de características muy especiales para hacer despliegues
rápidos. DigitalOcean dispone de un **plugin para Vagrant**, haciendo muy sencillo contar
con nuestro SpendingStories desplegado en la red de forma muy sencilla.

**Advertencia: [DigitalOcean](http://digitalocean.com) es un proveedor de pago**. 
Este generador de entornos SpendingStories realiza una instalación básica en Digitalocean (1CPU, 
512MB RAM, 20GB SSD, 1TB Transfer), que tiene un coste máximo de $5/mes. Véase el 
[plan de precios](https://www.digitalocean.com/pricing) para más información.

Lo primero que necesitamos es una cuenta de usuario en [DigitalOcean](http://digitalocean.com).
Una vez tengamos nuestra cuenta de usuario, sería necesario configurar:

-    **Datos de cobro**: ¡lo siento! Es la parte fea de este asunto :)
-    **SSH Key**: seguir las instrucciones desde el menú SSH Key.
-    **API Key**: seguir las instrucciones desde el menu API Key.

Una vez generada la cuenta, deberemos sustituir en el fichero *Vagrantfile* la 
dirección a la private ssh key (ssh.private_key_path), client_id y api_key:

    # Setting for deploying on digitalocean
    config.vm.provider :digital_ocean do |provider, override|
      config.omnibus.chef_version = :latest
      override.ssh.private_key_path = '~/.ssh/id_rsa' <--- aqui
      override.vm.box = 'digital_ocean'
      override.vm.box_url = "https://github.com/smdahlen/vagrant-digitalocean/raw/master/box/digital_ocean.box"
      provider.client_id = 'pon-tu-client_id' <--- aqui
      provider.api_key = 'pon-tu-api_key' <--- y aqui
  end

Procedemos a **instalar los *plugins* de digitalocean y omnibus** para Vagrant. 
*Nota*: estas instrucciones son para sistemas GNU/Linux. Si está intentando 
generar un entorno SpendingStories desde Mac/Windows, por favor lea la nota 
en la [documentación de vagrant-digitalocean](https://github.com/smdahlen/vagrant-digitalocean).

    user@host:~/spendingstories-vmx$ vagrant plugin install vagrant-digitalocean
    user@host:~/spendingstories-vmx$ vagrant plugin install vagrant-omnibus

**Lanzamos construcción** del entorno SpendingStories en DigitalOcean. ¡Estate atento! En el proceso **se te
informará de la dirección IP** para tu entorno SpendingStories en DigitalOcean.

    user@host:~/spendingstories-vmx$ vagrant up --provider=digital_ocean

Tras unos 15 minutos, si no hay errores ya podremos acceder por ssh a
nuestro recién-construido-entorno

    user@host:~/spendingstories-vmx$ vagrant ssh

Y desde nuestra máquina host podemos acceder a los distintos servicios:

-   http://IP-en-digital-ocean
