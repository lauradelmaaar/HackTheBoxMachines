# HackTheBox Machine Search Tool

## Descripción del repositorio

Este proyecto tiene como objetivo desarrollar una herramienta de línea de comandos para facilitar la búsqueda de máquinas en la plataforma **HackTheBox**. La herramienta proporciona diversas funcionalidades de filtrado y búsqueda basadas en diferentes criterios como el nombre de la máquina, la dirección IP, la dificultad, el sistema operativo y las habilidades necesarias para resolver la máquina. Todo esto se realiza desde la consola, de manera rápida y eficiente.

La herramienta se construye utilizando un archivo JSON (`bundle.js`) que contiene la información de las máquinas de **HackTheBox**, y permite realizar consultas para obtener los detalles relacionados con una máquina en específico.

## Funcionalidades

- **Búsqueda por nombre de máquina (`-m`)**: Permite buscar una máquina por su nombre y mostrar su información detallada.
- **Búsqueda por dirección IP (`-i`)**: Permite buscar la máquina asociada a una dirección IP específica.
- **Obtener enlace a resolución en YouTube (`-y`)**: Proporciona el enlace a la resolución en YouTube de una máquina específica, si está disponible.
- **Búsqueda por dificultad (`-d`)**: Permite filtrar las máquinas por nivel de dificultad: Fácil, Media, Difícil, Insane.
- **Búsqueda por sistema operativo (`-o`)**: Permite filtrar las máquinas por su sistema operativo: Linux o Windows.
- **Búsqueda por habilidades necesarias (`-s`)**: Permite buscar máquinas según las habilidades necesarias para resolverlas.
- **Actualizar archivos (`-u`)**: Descarga o actualiza el archivo `bundle.js` que contiene la información sobre las máquinas de HackTheBox.
- **Panel de ayuda (`-h`)**: Muestra un panel de ayuda que detalla las opciones disponibles en el programa.

## Flujo de trabajo

1. El archivo `bundle.js` contiene los datos de todas las máquinas de HackTheBox.
2. La herramienta utiliza comandos de consola para interactuar con este archivo y filtrar las máquinas según los parámetros proporcionados.
3. Los resultados se muestran de manera estructurada en la consola para una rápida consulta.
4. La herramienta permite tanto la búsqueda directa de máquinas como la obtención de enlaces relacionados con resoluciones de máquinas.

Este proyecto es una herramienta práctica y accesible para quienes deseen realizar búsquedas rápidas y detalladas sobre máquinas en **HackTheBox** directamente desde la terminal.

## Créditos

- Proyecto desarrollado por **s4vitar** como parte de la Academia **Hack4u**.

