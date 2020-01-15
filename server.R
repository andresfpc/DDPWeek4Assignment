library("shiny")
library("leaflet")
library("dplyr")

phs <- readRDS("BasePHs_lotesOGR.Rds")
paleta_colores <-
    c(
        "cian" = "#009fe3",
        "azul_oscuro" = "#003e65",
        "amarillo" = "#ffd400",
        "azul" = "#00529c",
        "blanco" = "#ffffff",
        "negro" = "#000000",
        "gris" = "#878787",
        "rojo" = "#ed1c24"
    )
color_estrato <-
    c("#e60000",
      "#ffff73",
      "#73dfff",
      "#b4d79e",
      "#e69800",
      "#38a800")
phs$ESTRATO <- as.factor(phs$ESTRATO)
colorEstrato <-
    colorFactor(palette = color_estrato, domain = phs$ESTRATO)
levels(phs$TIPO_DE_PROYECTO) <-
    c("Normal",
      "Other",
      "Priority interest housing",
      "Social interest housing")
colorProyecto <-
    colorFactor(
        palette = c(
            as.character(paleta_colores["rojo"]),
            as.character(paleta_colores["amarillo"]),
            as.character(paleta_colores["azul_oscuro"]),
            as.character(paleta_colores["cian"])
        ),
        domain = phs$TIPO_DE_PROYECTO
    )
colorLocalidad <-
    colorFactor(palette = rainbow(19), domain = phs$LOCALIDAD)
colorPuntaje <-
    colorNumeric(palette = colorRampPalette(c('red', 'green'))(length(phs$PUNTAJE_MEDIANA)),
                 domain = phs$PUNTAJE_MEDIANA)

shinyServer(function(input, output) {
    output$phsPlot <- renderLeaflet({
        phs_subset <-
            subset(
                x = phs,
                subset = as.numeric(VETUSTEZ) <= input$vetustez &
                    TIPO_DE_UNIDAD %in% input$tipo_unidad
            )
        lotes_phs <- leaflet(phs_subset) %>%
            addTiles() %>%
            addProviderTiles(providers$CartoDB.Positron)
        
        if (input$color_by == "NINGUNO") {
            lotes_phs <- lotes_phs %>%
                addPolygons(
                    fillOpacity = 0.7,
                    fill = as.character(paleta_colores["cian"]),
                    opacity = 1,
                    weight = 1,
                    color = as.character(paleta_colores["cian"])
                )
        }
        if (input$color_by == "ESTRATO") {
            lotes_phs <- lotes_phs %>%
                addPolygons(
                    fillOpacity = 0.7,
                    fillColor = ~ colorEstrato(ESTRATO),
                    opacity = 1,
                    weight = 1,
                    color = ~ colorEstrato(ESTRATO)
                ) %>%
                addLegend(
                    "bottomright",
                    pal = colorEstrato,
                    values = ~ ESTRATO,
                    title = "Social stratum",
                    opacity = 1
                )
        }
        if (input$color_by == "PUNTAJE_MEDIANA") {
            lotes_phs <- lotes_phs %>%
                addPolygons(
                    fillOpacity = 0.7,
                    fillColor = ~ colorPuntaje(PUNTAJE_MEDIANA),
                    opacity = 1,
                    weight = 1,
                    color = ~ colorPuntaje(PUNTAJE_MEDIANA)
                ) %>%
                addLegend(
                    "bottomright",
                    pal = colorPuntaje,
                    values = ~ PUNTAJE_MEDIANA,
                    title = "Cadastral score",
                    opacity = 1
                )
        }
        if (input$color_by == "FASE") {
            colorFase <-
                colorFactor(
                    palette = c(
                        as.character(paleta_colores["rojo"]),
                        as.character(paleta_colores["azul"]),
                        as.character(paleta_colores["azul_oscuro"]),
                        as.character(paleta_colores["cian"])
                    ),
                    domain = phs$FASE
                )
            lotes_phs <- lotes_phs %>%
                addPolygons(
                    fillOpacity = 0.7,
                    fillColor = ~ colorFase(FASE),
                    opacity = 1,
                    weight = 1,
                    color = ~ colorFase(FASE)
                ) %>%
                addLegend(
                    "bottomright",
                    pal = colorFase,
                    values = ~ FASE,
                    title = "Collection phase",
                    opacity = 1
                )
        }
        if (input$color_by == "TIPO_DE_PROYECTO") {
            lotes_phs <- lotes_phs %>%
                addPolygons(
                    fillOpacity = 0.7,
                    fillColor = ~ colorProyecto(TIPO_DE_PROYECTO),
                    opacity = 1,
                    weight = 1,
                    color = ~ colorProyecto(TIPO_DE_PROYECTO)
                ) %>%
                addLegend(
                    "bottomright",
                    pal = colorProyecto,
                    values = ~ TIPO_DE_PROYECTO,
                    title = "Project type",
                    opacity = 1
                )
        }
        if (input$color_by == "LOCALIDAD") {
            lotes_phs <- lotes_phs %>%
                addPolygons(
                    fillOpacity = 0.7,
                    fillColor = ~ colorLocalidad(LOCALIDAD),
                    opacity = 1,
                    weight = 1,
                    color = ~ colorLocalidad(LOCALIDAD)
                ) %>%
                addLegend(
                    "bottomright",
                    pal = colorLocalidad,
                    values = ~ LOCALIDAD,
                    title = "Locality",
                    opacity = 1
                )
        }
        
        lotes_phs
        
    })
    
})
