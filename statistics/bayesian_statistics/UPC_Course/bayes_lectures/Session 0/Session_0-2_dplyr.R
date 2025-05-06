
# 1. Data Transformation --------------------------------------------------

# 1.1 Tibble --------------------------------------------------------------

library(ggplot2)
library(dplyr)
df <- read.csv2("companies.csv")
df

# Un tibble es como un mejor dataframe (hereda todas sus propiedades) y se usa igual,
# aunque tiene más propiedades

df <- as_tibble(df)
df



# 1.2 dplyr verbs ---------------------------------------------------------

# 1.2.1 filter()

# La función filter permite recibir un tible y obtener un dataframe, y esta función
# extrae las filas que cumplan una condición para unas variables (las condiciones se
# separan por comas)

filter(df, City == "Barcelona")

filter(df, City == "Barcelona", Revenue > 3000)


# 1.2.2 arrange()

# La función arrange() ordena las filas en función de una o más variables,
# y se quiere un orden descendente se usa desc(variable)

arrange(df, Revenue)

arrange(df, desc(Revenue))

# 1.2.3 select()

# La función select() lo que hace es seleccionar variables, de modo que se ponen
# los nombres al lado

select(df, Company, City)

select(df, Company:Activity)

# Poniendo esto, se cogen todas las variables menos las que salen en -c(...)

select(df, -c(Company, City))

# Selecciona las variables que tienen una características (para strings)

select(df, starts_with("C"))

select(df, ends_with("y"))

select(df, contains("it"))


# 1.2.4 mutate()

# Se usa para definir nuevas variables, poniendo el nombre y la expresión (directamente
# con los nombres de las variables). Se pueden referenciar variables dentro de mutate
# que antes no estaban

mutate(df, 
  Rev_per_month = Revenue / 12, 
  Rev_per_week = Rev_per_month / 4)

# La función transmute() solo deja la variable creada en el df y elimina las otrass

transmute(df, Rev_per_month = Revenue / 12)


# 1.2.5 summarise()

# La función summarise() permite hacer un df que permite obtener diferentes
# resultados de funciones aplicadas a variables dentro de los datos

summarise(df, n = n(), 
  Rev_total = sum(Revenue), 
  Rev_mean = mean(Revenue), 
  Tot_act = n_distinct(Activity))

# 1.3 %>% operator --------------------------------------------------------

# Para poder pasar algo de la izquierda como primer argumento a la función de la derecha
# pero no dentro de funciones que estan coo argumentos de la función

df %>% 
	summarise(n = n(), 
	  Rev_total = sum(Revenue), 
	  Rev_mean = mean(Revenue), 
	  Tot_act = n_distinct(Activity))


# 1.3.1 group_by() --------------------------------------------------------

# Permite agrupar un dataframe según una variable, de modo que se pueden concatenar
# funciones para poder hacer una función para los diferentess dataframes para cada
# categoría

df %>% 
	group_by(City) %>% 
	summarise(n = n(), 
	  Rev_total = sum(Revenue), 
	  Rev_mean = mean(Revenue), 
	  Tot_act = n_distinct(Activity))


#' Exercise: 
#' How many companies are there in each city with a revenue> 3000 and how many 
#' with a revenue <3000?

df %>%
  group_by(Revenue>3000) %>%
  summarise(n=n())


# 2. Exercises ------------------------------------------------------------


# Exercise 2.1 ------------------------------------------------------------




# Exercise 2.2 ------------------------------------------------------------




# 3. tidyr package --------------------------------------------------------

# Este paquete permite ordenar un df para que las variables sean columnas y los
# individuos sean filas (que el df esté en formato tidu, ejemplo del mes)

kids <- tibble(
  room = c("P3", "P3", "P4", "P4", "P5", "P5"), 
  gender = c("boys", "girls", "boys", "girls", "boys", "girls"),
  amount = c(10, 15, 12, 13, 18, 7)
)
kids


# 3.1 spread() -----------------------------------------------------------

#. Spread permite transformar un df a formato ancho (columnas son observaciones de
# una variable como en el ejemplo del mes)

library(tidyr)

# La variable key es la variable que se transformará en columnas, mientras que la 
# variable value se vuelven las observaciones de estas nuevas variables creadas

kids_wide <- kids %>% 
  spread(key = gender, value = amount)

kids_wide

# Como. se puede ver,  deja la otras columnas igual

# 3.2 gather()

# Pasa de formato ancho a formato largo. Se necesita poner la variable key (el nombre
# de la nueva variable) y el value se vuelven las observaciones en esta variable.




kids_long <- kids_wide %>% 
  gather(key = caca, value = amount, -room)

kids_long



#' Exercise 1 (revisited)



