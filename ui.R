library("shiny")
library("leaflet")
library("dplyr")

phs <- readRDS("BasePHs_lotesOGR.Rds")

shinyUI(fluidPage(
    titlePanel(
        "Bogota horizontal property builings with communal equipment",
        windowTitle = "Bogota horizontal property builings with communal equipment"
    ),
    
    sidebarLayout(
        sidebarPanel(
            sliderInput(
                "vetustez",
                h3("Year of construction:"),
                min = min(phs$VETUSTEZ),
                max = max(phs$VETUSTEZ),
                value = 1990
            ),
            checkboxGroupInput(
                "tipo_unidad",
                label = h3("Type of housing"),
                choices = list(
                    "Apartament" = "APARTAMENTO",
                    "House" = "CASA",
                    "Mixed" = "MIXTO"
                ),
                selected = c("APARTAMENTO", "CASA", "MIXTO")
            ),
            radioButtons(
                "color_by",
                h3("Classification by:"),
                choices = list(
                    "None" = "NINGUNO",
                    "Social stratum" = "ESTRATO",
                    "Locality" = "LOCALIDAD",
                    "Cadastral score" = "PUNTAJE_MEDIANA",
                    "Collection phase" = "FASE",
                    "Project type" = "TIPO_DE_PROYECTO"
                ),
                selected = "NINGUNO"
            )
        ),
        
        mainPanel(leafletOutput("phsPlot", height = 800))
    )
))
