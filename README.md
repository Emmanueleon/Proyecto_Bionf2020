# Proyecto_Bionf2020

Actualmente me encuentro trabajando con mi proyecto de Doctorado que tiene por título **"Composición de la microbiota del recién nacido y su asociación con la microbiota presente en la leche materna en mujeres con sobrepeso y obesidad"**. El objetivo del proyecto es conocer la composición de la microbiota presente en muestras de heces de binomios madre-recién nacidos y de la leche materna. A continuación se describe parte del proceso realizado hasta el momento:

## Muestras 
Se han secuenciado muestras de heces de los binomios madre-recién nacido y leche materna. Como controles, se han utilizado:
  * 3 controles negativos: 
    * Control negativo para la extracción de la leche.
    * Control negativo para la extracción de las heces.
    * Control negativo para la preparación de librerías.
  
  * 1 control positivo (*Mock community*). 

## Secuenciación 
Se realizó una secuenciación por síntesis utilizando la plataforma Illumina Miseq 2x250. Para la preparación de las libreías el centro donde se secuenciaron las muestras utiliza el protocolo propuesto por el Earth Microbiome Project (EMP) con algunas variaciones. A continuación se describe de manera breve:

Primero se realiza una primera PCR donde se realiza el *multiplex*. Para esta PCR se utiliza un cebador *Forward* (TGTGCC) y 24 cebadores *Reverse* diferentes, siendo estos últimos los barcodes de las muestras. Debido a que se utilizan 24 reverse diferentes, las 96 muestras se agrupan en 4 *pools*, llamados Pool A, B, C y D. En la siguiente figura se ejemplifica. 

![Figura 1](reports/images/Librerias.png)

Posterior, se realiza el *index* de las secuencias de Illumina para la secuenciación, el cebador *Forward* es similar entre los 4 pools, pero diferente al de la primera PCR, y cada pool tiene un cebador *Reverse* diferente. Finalmente todos los pools son mezclados en uno solo y el pool final "Master pool" se secuencía.Como resultados el Centro de secuenciación sube a *BaseSpace* de Illumina 8 archivos ( 2 archivos: 1 archivo Pool#_ R1.fastq.gz y un archivo Pool#_R2.fastq.gz, para cada uno de los 4 pools).

**Nota**: El centro de secuenciación realiza previamente un análisis de calidad y el podado de las secuencias index de Illlumina, adjuntadas en la segunda PCR. 

## Proyecto Bioinformática 
Para poder realizar el proyecto final de la clase de bioinformática se han utilizado un set de datos y metadatos obtenidos hasta el momento, la organización de las carpetas que se encuentran en este repo se detallan a continuación: 

### `/bin/`
Este directorio contiene los scripts necesarios para:

### `/data/`
Este directorio contiene el sub directorio `raw` que contiene  2 carpetas que a su vez contienen parte de los resultados obtenidos por secuenciación (Pool A y Pool B). En cada carpeta se encuentran los archivos crudos tal como se bajan de *BaseSpace* PONER LINK. Cada carpeta contiene 2 archivos, los datos de secuenciación tanto para las lecturas *Forward* (`*_R1_*.fastaq.gz`) como para las lecturas *Reverse* (`*_R2_.fasta.gz`). 

### `/meta/`
Este directorio contiene el archivo `sample-metadata`que es un archivo de texto en donde se especifíca el ID de la muestra, cada una de las secuencias del cebador *Reverse* utilizado, la secuencia del cebador *Forward*, el pool y la posición en el posillo de cada muestra, además del tipo de muestra que es. 

Además contiene el archivo `Antropometria_madre.tsv` en donde se especifícan parámetros demográficos de las madres participantes como: edad, peso, estatura, semanas de gestación (SDG). Como parte del estudio se realiza una visita domiciliaria 1 mes después del nacimiento del recién nacido, se realizan mediciones antopométricas tanto de la madre como del recién nacido, en el mismo documento se muestran los datos obtenidos de la madre, además de algunos otros datos como tipo de parto, clínica del IMSS a la cual son derechoabientes, entre otros. 
 
### `/output/`
Este directorio contiene diferentes subdirectorios: 

 *`ampkt_results`: se guardan las salidas de los datos generados por el script "NOMBRE DEL SCRIPT". 
 *`R`
 * 






