## ---- eval=FALSE, include=TRUE--------------------------------------------------
## "Protocolo:
## 
## 1. Daniel Felipe Villa Rengifo
## 
## 2. Lenguaje: R
## 
## 3. Tema: Manejo de archivos xml ,json Y leer tablas incrustadas en archivos HTML.
## 
## 4. Fuentes:
##    https://rsanchezs.gitbooks.io/ciencia-de-datos-con-r/content/importar_datos/jerarquico/archivos_formato_jerarquico.html
## 
##   https://www.datanalytics.com/libro_r/json-y-xml.html"


## -------------------------------------------------------------------------------
install.packages("XML")
library(XML)


## -------------------------------------------------------------------------------
# UNO:
"agregamos la url"

link <- "https://en.wikipedia.org/wiki/World_population"


## -------------------------------------------------------------------------------

#obtenemos el HTML y lo guardamos en una variable de R ya que no recibe solamente el link:
# Para eso necesitamos otro paquete:
install.packages("RCurl")
library(RCurl)

htmldata <- getURL(link)

#La ponemos dentro dentro de la funcion y listo:
tabla <- readHTMLTable(htmldata)


## -------------------------------------------------------------------------------
# Leamos la tablas incrustadas en la pagina descargada:
# imprimimos el directorio:
dir()

#observamos que necesitamos el archivo N°7:
"Asi dejamos el nombre del archivo en una variable caracter"
POPurl <- "WorldPopulation-wiki.html"

#ahora lo convertimos en tabla:
"Entra como una lista de todas las tablas del html dado"
tabla <- readHTMLTable(POPurl)

print(tabla)

crecimientoanual <- tabla[[8]]
print(crecimientoanual)
# Otra forma de leer los archivos es dando valor a which:
crecimientoanual <- readHTMLTable(POPurl, which = 8)
print(crecimientoanual)

"De las dos formas dara el mismo resultado"


## -------------------------------------------------------------------------------
# Ahora veremos si los datos por año estan muy alejados del promedio total de años en la tabla:

# Pero antes transformaremos varios datos y les daremos nombres a sus columnas
# (dejando solamente la que necesitamos):

# Eliminando las columnas inecesarias para el ejercicio:
borrar <- c("V5", "V6", "V7")

crecimientoanual <- crecimientoanual[,!(names(crecimientoanual) %in% borrar)]

# Cambiamos los nombres de las columnas:

names(crecimientoanual) <- c("year","Poblacion", "PorcetajeCrecimiento", "NumeroCrecimiento")

#Ahora con la funcion gsub removeremos el porcentaje:

crecimientoanual$PorcetajeCrecimiento <-  gsub("%", "",
                                               crecimientoanual$PorcetajeCrecimiento)

" Removemos las comas"
crecimientoanual$Poblacion <- gsub(",", "", crecimientoanual$Poblacion)
crecimientoanual$NumeroCrecimiento <- gsub(",", "",
                                           crecimientoanual$NumeroCrecimiento)

# pasamos de factor a numeric las columnas necesarias:
crecimientoanual$Poblacion <- as.numeric(crecimientoanual$Poblacion)

crecimientoanual$PorcetajeCrecimiento <- as.numeric(crecimientoanual$PorcetajeCrecimiento)

crecimientoanual$NumeroCrecimiento <- as.numeric(crecimientoanual$NumeroCrecimiento)

# Ahora el boxplot del promdio de crecimiento por porcentaje anual desde 1951 a 2020:

png(filename = "BoxPLotXCreciemtoPoblacionalXPorcentaje.png")

boxplot(crecimientoanual$PorcetajeCrecimiento, horizontal = T, main = "Promedio anual de crecimento poblacional por porcentaje", xlab = "Porcentaje %", col = "green")

dev.off()


## -------------------------------------------------------------------------------
# Una vez instala la libreria, cargamos el nombre del archivo en caracter:
XML_url <- "cd_catalog.xml"

# Leemos el archivo como XML (descargado)
xmldoc <- xmlParse(XML_url)

# Ahora tomamos el grueso del XML
rootnode <- xmlRoot(xmldoc)

#visualicemos:
print(rootnode)

"Ahora para extraer solamente los datos utlizamos las funciones apply"
# Asi extraemos info como dataframe
cds_data <- xmlSApply(rootnode, function(x) xmlSApply(x, xmlValue) )
print(cds_data)

# Como podemos ver necesitamos trasponer y eliminar el names() de las filas sin trasponer:
cds.catalog <- data.frame(t(cds_data), row.names = NULL)
print(cds.catalog)

"Una vez organizado el archivo esta listo para trabajar"

"El data frame se basa en una venta de discos con:

Titulo del disco

Artista

Pais

Disquera

Precio del disco

Año de publicacion"


## -------------------------------------------------------------------------------
library(jsonlite)
# Damos la url como caracter
url = "http://www.floatrates.com/daily/usd.json"

# Leemos el archivo con la función fromJSON:
"Nos arrojara una lista de listas de las divisas actuales"
j = fromJSON(url)

#veamos las primeras 50 listas
print(j[1:50])

# Podemos convetir en un dataframe para leer la informacion de una manera más entendible una de las lista, cuales quiera:

"En este caso la 3 lista de la lista j"

###Todos estos datos etan respecto al dolar (Moneda Mundial)###

tabla3json <- data.table::as.data.table(j[[3]])

