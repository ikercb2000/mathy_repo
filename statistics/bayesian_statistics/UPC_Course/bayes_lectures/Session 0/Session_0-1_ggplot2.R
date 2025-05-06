###########################################################################
# 
#     BAYESIAN ANALYSIS
# 
#     Session 0: Tools for bayesian analysis I: ggplot2
#
#     Autor: Jesus Corral Lopez
#     mail: jesus.corral@upc.edu
# 
#     Date: February 10, 2022
###########################################################################

# --------------------------------------------------------------------------------
# 1.1 Introduction
# --------------------------------------------------------------------------------

library(ggplot2)

mpg

# Primero se declara el dataframe que se quiere utilizar para la representación

ggplot(data = mpg) + 
  geom_point(aes(x = displ, y = hwy))

# Después se declara geom_point() para poder transformar en puntos dentro de un 
# gráfico

# La función aes() es una función de estéticas, de modo que si ponemos puntos,
# podemos modificar características de estos puntos para poder trabajar con ellos

# size, shape, color

# alpha = ... es un parámetro de transparencia de los puntos

# --------------------------------------------------------------------------------
# 1.2 Visualizing variables (aes) 
# --------------------------------------------------------------------------------

ggplot(mpg) + 
  geom_point(aes(x = displ, y = hwy, size = cyl, color = class))

# aes() indica las características que tendrán estos puntos, pero para cambiar algo
# visual del punto, se tiene que poner la característica fuera de aes(), en 
# geom_point()

ggplot(mpg) + 
  geom_point(aes(x = displ, y = hwy, size = cyl, color = class), color "blue")

# --------------------------------------------------------------------------------
# 1.2.1 set vs map 
# --------------------------------------------------------------------------------

# También se pueden hacer condiciones lógicas con los argumentos dentro de 
# geom_point(), aunque también se puede utilizar un ifelse() en el argumento
# fuera de la base

ggplot(mpg) + 
  geom_point(aes(x = displ, y = hwy, size = cyl, color = displ<5))

# --------------------------------------------------------------------------------
# 1.3 facet
# --------------------------------------------------------------------------------

# También se puede añadir facet_wrap() para poder hacer gráficos dividiendo para las
# categorías de una variable (hacer un gráfico para cada una)

ggplot(mpg) + 
  geom_point(aes(x = displ, y = hwy)) + 
  facet_wrap(~ class)

# También se puede añadir otra variable categórica usando facet_grid() 
# para poder hacer gráficos a pares para las categorías de las dos variables

ggplot(mpg) + 
  geom_point(aes(x = displ, y = hwy)) + 
  facet_grid(drv ~ cyl)

# Cuando se pone un punto en esta función, se consideran solo las categorías de uno
# como en facet_wrap() (más o menos)

ggplot(mpg) + 
  geom_point(aes(x = displ, y = hwy)) + 
  facet_grid( ~ class)

# --------------------------------------------------------------------------------
# 1.4 Visualizing cases: geom
# --------------------------------------------------------------------------------

ggplot(mpg) + 
  geom_point(aes(x = displ, y = hwy))


#' Example:
#' 
#' Make 3 different figures from the previous figure using the 
#' variable drv with the aesthetics `color`, `linetype` and `group`.

# --------------------------------------------------------------------------------
# 1.4.1 Multiple layers 
# --------------------------------------------------------------------------------

# Se pueden añadir varias capas con los mismos datos (se aplican diversas geometrías)

ggplot(mpg) + 
  geom_smooth(aes(x = displ, y = hwy)) +
  geom_point(aes(x = displ, y = hwy))

# El orden importa, de modo que las capas van una encima de otras

ggplot(mpg) + 
  geom_point(aes(x = displ, y = hwy)) +
  geom_smooth(aes(x = displ, y = hwy))
  

# --------------------------------------------------------------------------------
# 1.4.2 global vs local
# --------------------------------------------------------------------------------

# Si se quieren pner varias capas de la misma geometría, lo mejor es poner aes()
# dentro de ggplot() para que se apliquen a todas las de abajo

ggplot(mpg, aes(x = displ, y = hwy)) +
   geom_point() +
   geom_smooth()


# Si se quiere cambiar el aes() para una capa en concreto, entonces esta se pone
# dentro de la geometría, se pone un aes() específico que sobreescribe el aes()
# global pero solo para esa capa

ggplot(mpg, aes(x = displ, y = hwy)) + 
  geom_point(aes(color = class)) + 
  geom_smooth()

# Si se quiere usar un nuevo data frame dentro de un missmo gráfico (un segundo),
# se tiene que indicar data = ... dentro de la geometría con la que se quieren
# usar estos datos, y solo se utilizará para esa geometría y ninguna más

mpg_subcompact <- mpg[mpg$class == "subcompact", ]

ggplot(mpg, aes(x = displ, y = hwy)) + 
  geom_point(aes(color = class)) + 
  geom_smooth(data = mpg_subcompact, se = FALSE) # se = TRUE pone variabilidad alrededor 

#' Example:
#' 
#' Recreate the code in R needed to generate the following figures, from:

# Hay que recordar que si se quiere poner algo en función de una variable, se tiene
# que añadir la variable en aes() y se hará automáticamente

p <- ggplot(mpg, aes(x = displ, y = hwy, color = drv))+
  geom_point()+
  geom_smooth(se=FALSE)

p

p2 <- ggplot(mpg, aes(x = displ, y = hwy, color = (drv=="f")))+
  geom_point()+
  geom_smooth(se=FALSE)

p2

# --------------------------------------------------------------------------------
# 1.5 Position
# --------------------------------------------------------------------------------

# El parámetro de colour=... en geom_bar() permite cambiar el contorno según una variable,
# mientras que fill=... permite cambiar el color dentro de cada barra según una variable


ggplot(diamonds) +
  geom_bar(mapping = aes(x = cut, colour = cut))

ggplot(diamonds) + 
  geom_bar(mapping = aes(x = cut, fill = cut))

ggplot(diamonds) + 
  geom_bar(mapping = aes(x = cut, fill = clarity))


#' Ejercicio:
#' 
#' Modifica el gráfico anterior utilizando diferentes valores 
#' en el parámetro position (“stack”, “dodge”, “identity”, “fill”).


# --------------------------------------------------------------------------------
# 1.6 Formal aspects of ggplot2
# --------------------------------------------------------------------------------

# --------------------------------------------------------------------------------
# 1.6.1 Labels: titles, axis, legend
# --------------------------------------------------------------------------------

# Se pueden cambiar todas las cosa sde texto de la imagen para mejor presentación
# y para cambiar leyendas se pone el argumento de aquello para lo que se necesita

p <- ggplot(mpg, aes(x = displ, y = hwy)) +
  geom_point(aes(color = class)) +
  geom_smooth()

p + 
  labs(title = "Fuel efficiency vs. Engine size",
       x = "Engine displacement (L)", 
       y = "Highway fuel efficiency (mpg)",
       color = "Type of Car",
       caption = "Data from fueleconomy.gov")

# --------------------------------------------------------------------------------
# 1.6.2 Scales
# --------------------------------------------------------------------------------

# Las escalas permiten cambiar las escalas de loss ejes y de los colores de una
# variable categórica

(p <- ggplot(mpg, aes(displ, hwy)) + 
  geom_point(aes(color = class)))

p +
  scale_x_continuous() +
  scale_y_continuous() +
  scale_color_discrete()

p +
  scale_color_discrete(labels = c("A" , "B", "C", "D", "E", "F", "G"))

p +
  scale_x_continuous(labels = NULL) +
  scale_y_continuous(breaks = seq(15, 40, by = 5))

p +
  scale_y_log10(breaks = seq(15, 40, by = 5))

#. Hay varias escalas dependiendo de lo que se quiera hacer

# --------------------------------------------------------------------------------
# 1.6.3 Zoom
# --------------------------------------------------------------------------------

# Se puede hacer un zoom en los datos a través de utilizar las coordenadas cartesianas
# y especificar los intervalos de x e y

ggplot(mpg, aes(x = displ, y = hwy)) +
  geom_point(aes(color = class)) +
  geom_smooth() + 
  coord_cartesian(xlim = c(5, 7), ylim = c(10, 30)) 

# --------------------------------------------------------------------------------
# 1.6.4 Themes
# --------------------------------------------------------------------------------

# Permite cambiar el tema (paleta de colores y formato de la imagen)

p +  theme_bw()
p +  theme_grey()
p +  theme_light()
p +  theme_dark()

# Para utilizar uno de manera global, se puede utilizar la siguiente función

set_theme(theme_light())

# --------------------------------------------------------------------------------
# 1.6.5 Additional themes
# --------------------------------------------------------------------------------

# La libreria permite obtener más temas que los originales del paquete

library(ggthemes)

p <- ggplot(mpg, aes(x = displ, y = hwy, colour = factor(cyl))) +
  geom_point() +
  labs(title = "mpg")

# Economist theme
p + theme_economist()
# Economist theme + paleta de colores
p + theme_economist() + scale_colour_economist() 

# --------------------------------------------------------------------------------
# 1.6.6 Define your own themes
# --------------------------------------------------------------------------------

theme_jesus <- function () { 
  theme_bw(base_size=12, base_family="Courier") %+replace% 
    theme(
      panel.background  = element_blank(),
      plot.background = element_rect(fill="gray96", colour=NA), 
      legend.background = element_rect(fill="transparent", colour=NA),
      legend.key = element_rect(fill="transparent", colour=NA)
    )
}

p + theme_bw()
p + theme_jesus()


# Exercise:
  
# Experiment with labels, themes and scales in order to create a figure like this, 
# based on the `diamonds` data (x: carat, y: price, color: cut)

# --------------------------------------------------------------------------------
# 1.7 Save plots
# --------------------------------------------------------------------------------

# Para poder guardar el último frádico. creado, se pueden usar las siguientes funciones 

ggsave("my-plot.pdf", width = 6, height = 6)
ggsave("my-plot.png", width = 6, height = 6)

png("my-plot_4.png", width = 800, height = 600)
  print(p)
dev.off()

# Si se quieren guardar varios gráficos...

# --------------------------------------------------------------------------------
# 1.8 Plotly
# --------------------------------------------------------------------------------

# Transforma cualquier figura del ggplot a algo interactivo en R

library(plotly)

(p <- ggplotly(p))

# --------------------------------------------------------------------------------
# 1.9 Display several plots at once
# --------------------------------------------------------------------------------

# Para poder representar figuras una al lado de otra, entonces se necesita usar
# los siguientes paquetes

library(gridExtra)

p1 <- ggplot(diamonds, aes(x = carat, y = price)) +
  geom_point()

p2 <- ggplot(diamonds, aes(x = carat, y = price)) +
  geom_smooth(aes(color = cut), se = FALSE)

grid.arrange(p1, p2, nrow = 1)


