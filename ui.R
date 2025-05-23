# UI
ui <- shinyUI(
  fluidPage(
    tags$head(
      tags$style(HTML("
        body, .container-fluid {
            background-color: white !important; /* Set background for full page */
            color: black;
        }
        .markdown-content {
            background-color: white;
            color: black;
            padding: 15px;
            border-radius: 5px;
        }
        /* Optional: Add padding to the bottom to ensure no cut-off appearance */
        .container-fluid {
            padding-bottom: 50px;
        }
    "))
    ),
    includeCSS("www/style.css"),
    dashboardPage(
      dashboardHeader(
        title = "KI data analysis tool",
        titleWidth = 300,
        tags$li(
          class = "dropdown", 
          tags$img(src = "REACH.png", height = "50px", width = "225px")
        )
      ),
      dashboardSidebar(
        sidebarMenu(
          menuItem("Home", tabName = "home", icon = icon("home")),
          menuItem("Importing data", tabName = "import", icon = icon("gear")),
          menuItem("Aggregation & Analysis", tabName = "analysis", icon = icon("table")),
          menuItem("Analysis Data exploration", tabName = "data_exploration", icon = icon("dashboard")),
          menuItem("Generate Report", tabName = "report", icon = icon("file")),
          menuItem("Severity Index", tabName = "index", icon = icon("chart-bar")),
          menuItem("Documentation", tabName = "documentation", icon = icon("book"))
          # menuItem("Data plotting", tabName = "plot", icon = icon("chart-bar"))
        )
      ),
      
      dashboardBody(
        tabItems(
          tabItem(tabName = "analysis",
                  # First Row: Import Files (side by side)
                  # fluidRow(
                  #   column(width = 4, 
                  #          box(
                  #            title = NULL,
                  #            status = "primary",
                  #            solidHeader = TRUE,
                  #            width = NULL,
                  #            height = 180,
                  #            tags$div(
                  #              tags$h4("Import dataset", style = "color: var(--primary-color);"),
                  #              tags$h5(style = "color: gray;", "Clean data should be saved in the first sheet.")
                  #            ),
                  #            fileInput("data_file", 
                  #                      label = tags$span(style = "color: var(--primary-color);", "Upload Data File (xlsx)"), accept = ".xlsx")
                  #          )
                  #   ),
                  #   column(width = 4, 
                  #          box(
                  #            title = NULL,
                  #            status = "primary",
                  #            solidHeader = TRUE,
                  #            width = NULL,
                  #            height = 180,
                  #            tags$div(
                  #              tags$h4("Import Kobo file", style = "color: var(--primary-color);"),
                  #              tags$h5(style = "color: gray;", "Important: \nKobo tool has to match data.")
                  #            ),
                  #            fileInput("kobo_file", 
                  #                      label = tags$span(style = "color: var(--primary-color);", "Upload Kobo Tool File (xlsx)"), accept = ".xlsx")
                  #          )
                  #   ),
                  #   column(width=4,
                  #          box(title=NULL,
                  #              status="primary",
                  #              solidHeader=TRUE,
                  #              width=NULL,
                  #              height = 180,
                  #              tags$div(
                  #                tags$h4("Choose label column", style = "color: var(--primary-color);"),
                  #                tags$h5(style = "color: gray;", "Choose label variable e.g.`label::English (en)`.")
                  #              ),
                  #              selectInput("label_selector", 
                  #                          label = tags$span(style = "color: var(--primary-color);", "Select label variable"), 
                  #                          choices = NULL  # Choices will be updated dynamically
                  #              )
                  #          )
                  # )
                  # ), # fluidrow end
                  # Second Row: Data Aggregation (spans the entire row)
                  fluidRow(
                    column(width = 12, 
                           box(
                             title = NULL,
                             status = "primary",
                             solidHeader = TRUE,
                             width = NULL,
                             tags$div(
                               tags$h4("Data aggregation", style = "color: var(--primary-color);"),
                               tags$h5(style = "color: gray;", "Select the variable (indicator) to use as the unit of analysis (e.g. “settlement_name”) and all other relevant location indicators linked to that unit of analysis (e.g. “admin1”; “admin2”; “admin3”). The Aggregated Data can be used for any information products displaying community-level results (e.g. mapping of values for individual settlements).")
                             ),
                             selectInput("aggregation_option", 
                                         label = tags$span(style = "color: var(--primary-color);", "Do you want to aggregate the data?"), 
                                         choices = c("Aggregate data" = "aggregate", "Leave data at KI level" = "no_aggregate")),
                             uiOutput("aggregation_vars_ui"),
                             actionButton("run_aggregation", "Run Aggregation"),
                             # actionButton("reset_aggregation", "Reset Aggregation"),  # Reset button added
                             verbatimTextOutput("aggregation_status"),
                             downloadButton("download_aggregated_data", "Download Aggregated Data")
                           )
                    )
                  ),
                  
                  # Third Row: Data Analysis (spans the entire row)
                  fluidRow(
                    column(width = 12, 
                           box(
                             title = NULL,
                             status = "primary",
                             solidHeader = TRUE,
                             width = NULL,
                             tags$div(
                               tags$h4("Data Analysis", style = "color: var(--primary-color);"),
                               tags$h5(style = "color: gray;", "After clicking on Run Aggregation in the previous step, select the (first) variable (indicator) to use as the level of analysis (typically this will be the admin2). Optionally, if further disaggregation is desired, select a second variable to disaggregate by (in most cases, this optional step is not necessary). The Analysis Data can be used for any information products displaying area-level results (e.g. mapping of summarised values at admin 2 level).")
                             ),
                             selectInput("disaggregate_by_1", 
                                         label = tags$span(style = "color: var(--primary-color);", "Choose variable(s) for main analysis (required)"),  
                                         choices = NULL, multiple = TRUE),
                             selectInput("disaggregate_by_2", 
                                         label = tags$span(style = "color: var(--primary-color);", "Choose variable(s) for second (optional) analysis"), 
                                         choices = NULL, multiple = TRUE),
                             actionButton("run_analysis", "Run Analysis"),
                             # actionButton("reset_analysis", "Reset Analysis"),  # Reset button added
                             verbatimTextOutput("analysis_status"),
                             uiOutput("progress_bar"),
                             downloadButton("download_analysis_data", "Download Analysis Data")
                           )
                    )
                  )
          ),
          tabItem(tabName = "home",
                  fluidRow(column(width = 12,
                                  div(class = "markdown-content", includeMarkdown("README.md"))
                  ))
          ),
          tabItem(tabName = "plot",
                  fluidRow(
                    box(title = "Plot Settings", 
                        selectInput("plot_type", 
                                    label = tags$span(style = "color: var(--primary-color);",  "Plot Type"),
                                    choices = c("Bar Chart" = "bar", "Scatterplot" = "scatter", "Violin Plot" = "violin")),
                        selectInput("x_axis", 
                                    label = tags$span(style = "color: var(--primary-color);",  "X-Axis"), choices = NULL),
                        selectInput("y_axis", 
                                    label = tags$span(style = "color: var(--primary-color);",  "Y-Axis"), choices = NULL),
                        selectInput("measure", 
                                    label = tags$span(style = "color: var(--primary-color);",  "Measure"),choices = c("mean", "count", "median"))
                    ),
                    box(title = "Plot Output",
                        plotOutput("plot_output", height = "500px")
                    )
                  )
          ),
          tabItem(tabName = "report",
                  fluidRow(
                    column(width = 12, 
                           box(
                             title = NULL,
                             status = "primary",
                             solidHeader = TRUE,
                             width = NULL,
                             tags$div(
                               tags$h4("Generate Report", style = "color: var(--primary-color);"),
                               tags$h5(style = "color: gray;", "Select options to generate a customized report.")
                             ),
                             selectInput("report_disag_var", 
                                         label = tags$span(style = "color: var(--primary-color);", "Select Disaggregation Level"), 
                                         choices = NULL),
                             selectInput("report_disag_val", 
                                         label = tags$span(style = "color: var(--primary-color);", "Select Area Values"), 
                                         choices = NULL, multiple = TRUE),
                             selectInput("report_questions", 
                                         label = tags$span(style = "color: var(--primary-color);", "Select Questions"), 
                                         choices = NULL, multiple = TRUE),
                             actionButton("generate_html", "Generate HTML Report"),
                             downloadButton("download_report_html", "Download HTML Report"),
                             verbatimTextOutput("msg_data_report_generated")
                             
                           )
                    )
                  )
          ),
          tabItem(tabName = "data_exploration",
                  fluidRow(
                    column(width = 12, 
                           box(
                             title = NULL,
                             status = "primary",
                             solidHeader = TRUE,
                             width = NULL,
                             tags$div(
                               tags$h4("Data Exploration", style = "color: var(--primary-color);"),
                               tags$h5(style = "color: gray;", "Data is based on analysis run in the previous page. Select a question and filters to explore the data.
Select a question and filters to explore the data. To see data aggregated for the entire area, generate a report in the next page.")
                             ),
                             selectInput("filter_disag_var_1", 
                                         label = tags$span(style = "color: var(--primary-color);", "Select Disaggregation Level"), 
                                         choices = NULL),
                             selectizeInput("filter_disag_val_1",
                                            label = tags$span(style = "color: var(--primary-color);", "Select Area Value"),
                                            choices = NULL,
                                            multiple = TRUE,
                                            options = list(plugins = "remove_button")),
                             # actionButton("select_all", "Select All", class = "btn-primary"),
                             # selectInput("filter_disag_val_1", 
                             #             label = tags$span(style = "color: var(--primary-color);", "Select Area Value"), 
                             #             choices = NULL, multiple = TRUE),
                             selectInput("selected_question", 
                                         label = tags$span(style = "color: var(--primary-color);", "Select Question"), 
                                         choices = NULL),
                             plotOutput("basic_plot_exploration"),
                             downloadButton("download_plot", "Download Plot")
                           )
                    )
                  )
          ),
          tabItem(tabName = "index",
                  # First Row: Import Files (side by side)
                  fluidRow(column(width = 4, 
                                  box(
                                    title = NULL,
                                    status = "info",
                                    solidHeader = TRUE,
                                    width = NULL,
                                    height = 180,
                                    tags$div(
                                      tags$h4("Download DAP Template", style = "color: var(--primary-color);"),
                                      tags$h5(style = "color: gray;", "Download the Data Analysis Plan (DAP) template based on the uploaded Kobo tool.\nThe document also contains the global standard Severity Index DAP for UNDAC and AoK as reference and guidance.")
                                    ),
                                    downloadButton("download_dap", "Download Template")
                                  )
                  ),
                    column(width = 4, 
                           box(
                             title = NULL,
                             status = "primary",
                             solidHeader = TRUE,
                             width = NULL,
                             height = 180,
                             tags$div(
                               tags$h4("Import Data Analysis plan", style = "color: var(--primary-color);"),
                               tags$h5(style = "color: gray;", "Upload the Index DAP based on the template. Save DAP in the first sheet.")
                             ),
                             fileInput("dap_file", 
                                       label = tags$span(style = "color: var(--primary-color);", "Upload Data DAP (xlsx)"), accept = ".xlsx")
                           )
                    ),
                    column(width = 4, 
                           box(
                             title = NULL,
                             status = "info",
                             solidHeader = TRUE,
                             width = NULL,
                             height = 180,
                             tags$div(
                               tags$h4("For Severity Index area calculation", style = "color: var(--primary-color);"),
                               tags$h5(style = "color: gray;", "Select the admin level at which to calculate area severity.")
                             ),
                             selectInput("admin_level_index", "Select Admin Level:",
                                         choices = c("admin1", "admin2", "admin3", "admin4"),
                                         selected = "admin2")                           )
                    )
                  ), # fluidrow end
                  # Second Row: Data Aggregation (spans the entire row)
                  fluidRow(
                    column(width = 12, 
                           box(
                             title = NULL,
                             status = "primary",
                             solidHeader = TRUE,
                             width = NULL,
                             tags$div(
                               tags$h4("Select Index calculation", style = "color: var(--primary-color);"),
                               tags$h5(style = "color: gray;", "Select the method for calculating the index.")
                             ),
                             selectInput("selected_index_method", 
                                         label = tags$span(style = "color: var(--primary-color);", "Select index method."),  
                                         choices = c(
                                           "Flag Severity 3 (Indicator, Cluster, Settlement, Area)" = "flag3",
                                           "Flag Severity 4 (Indicator, Cluster, Settlement, Area)" = "flag4",
                                           "Flag Severity 4+ (Indicator, Cluster, Settlement, Area)" = "flag4+",
                                           "Proportion Severity 3 (Cluster, Settlement, Area)" = "proportion3",
                                           "Proportion Severity 4 (Cluster, Settlement, Area)" = "proportion4",
                                           "Proportion Severity 4+ (Cluster, Settlement, Area)" = "proportion4+",
                                           "Score Index (Indicator, Cluster, Settlement, Area)" = "score"
                                         ),
                                         multiple = TRUE),
                             actionButton("run_index", "Run Index Calculation"),
                             downloadButton("download_index_data", "Download Index Data"),
                             verbatimTextOutput("run_message"),
                             br(), 
                             actionButton("generate_index_html", "Generate HTML Report"),
                             downloadButton("download_index_html", "Download HTML Report"),
                             verbatimTextOutput("msg_report_generated"),
                             br(),  # Adds extra spacing
                             actionButton("generate_sensitivity_analysis", "Generate Flag Index Sensitivity Analysis"),
                             downloadButton("download_sensitvity_analysis", "Download Flag Index Sensitivity Analysis"),
                             verbatimTextOutput("msg_sensitivity_analysis_generated")
                           )
                           )
                  ) # fluidrow end
          ), # tab item index end
          tabItem(tabName = "import",
                  # First Row: Import Files (side by side)
                  fluidRow(
                    column(width = 6, 
                                  box(
                                    title = NULL,
                                    status = "primary",
                                    solidHeader = TRUE,
                                    width = NULL,
                                    height = 180,
                                    tags$div(
                                      tags$h4("Import dataset", style = "color: var(--primary-color);"),
                                      tags$h5(style = "color: gray;", paste0("\nImportant: \nData should be in xml format and cleaned before importing. The clean data should then be saved in the first sheet.\n"))
                                    ),
                                    fileInput("data_file", 
                                              label = tags$span(style = "color: var(--primary-color);", "Upload Data File (xlsx)"), accept = ".xlsx")
                                  )
                  ),
                  column(width = 6, 
                         box(
                           title = NULL,
                           status = "primary",
                           solidHeader = TRUE,
                           width = NULL,
                           height = 180,
                           tags$div(
                             tags$h4("Import Kobo file", style = "color: var(--primary-color);"),
                             tags$h5(style = "color: gray;", "Important: the uploaded Kobo tool must be the exact same tool used to collect the data.")
                           ),
                           fileInput("kobo_file", 
                                     label = tags$span(style = "color: var(--primary-color);", "Upload Kobo Tool File (xlsx)"), accept = ".xlsx")
                         )
                  )
                  ),
                  fluidRow(
                    column(width = 6, 
                           box(
                             title = NULL,
                             status = "primary",
                             solidHeader = TRUE,
                             width = NULL,
                             height = 180,
                             tags$div(
                               tags$h4("Select administrative boundaries", style = "color: var(--primary-color);"),
                               tags$h5(style = "color: gray;", "Important: \nSelect the admin1, admin2, admin3, admin4 (e.g. settlement/village) boundaries in that order")
                             ),
                             selectInput("select_admin_bounds", 
                                         label = tags$span(style = "color: var(--primary-color);", "Select all available admin boundaries"),  
                                         choices = NULL, multiple = TRUE)
                           )
                    ),
                    column(width=6,
                           box(title=NULL,
                               status="primary",
                               solidHeader=TRUE,
                               width=NULL,
                               height = 180,
                               tags$div(
                                 tags$h4("Choose label column", style = "color: var(--primary-color);"),
                                 tags$h5(style = "color: gray;", "Important: \nIn both the “survey” and “choice” sheets of the Kobo xlsx, the “label” column header should be written the same way.")
                               ),
                               selectInput("label_selector", 
                                           label = tags$span(style = "color: var(--primary-color);", "Select label variable"), 
                                           choices = NULL  # Choices will be updated dynamically
                               )
                           )
                    )
                  ), # fluidrow end
                  # Second Row: Data Aggregation (spans the entire row)
                  fluidRow(
                    
                  ) # fluidrow end
          ), # last tabitem
          tabItem(tabName = "documentation",
                  fluidRow(column(width = 12,
                                  div(class = "markdown-content", includeMarkdown("www/method.md"))
                  )
                  )
          )
        ) # tabItems end
      )# dashboard body
    )
  ) # fluid page end
) # shinyui end
