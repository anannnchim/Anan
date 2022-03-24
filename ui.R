## Factsheet: app.R ## UI and server

library(shiny)
library(shinydashboard)
library(rsconnect)

rsconnect::setAccountInfo(name='nanthawat',
                          token='B32C12466594A5F5C08A5BB9AEF0C776',
                          secret='zSzbhn/P1L6eoPLLOrcNHK8dEfJxnKvNVvw881Sg')

rsconnect::deployApp('C:/Users/User/Desktop/S1-Factsheet/')


ui <- dashboardPage(skin = "black",
                    dashboardHeader(title = "ANAN CAPITAL"),
                    dashboardSidebar(sidebarMenu( 
                      
                      
                      menuItem("System S1",tabName = "beg", icon = icon("artstation"),badgeLabel = "Welcome!",badgeColor = "blue"),
                      menuItem("Portfolio",tabName = "portfolio", icon = icon("dashboard"),badgeLabel = "LIVE",badgeColor = "green"),
                      menuItem("Past Performance", icon = icon("chart-bar"), tabName = "pastperformance",badgeColor = "green",
                               menuSubItem("Equity ", tabName = "equityanalysis"),
                               menuSubItem("Edges ", tabName = "edgesanalysis")),
                      menuItem("Philosophy", icon = icon("book"), tabName = "philosophy",badgeLabel = "soon",badgeColor = "yellow"),
                      menuItem("Market Monitoring", icon = icon("archway"), tabName = "marketmonitoring",badgeLabel = "soon",badgeColor = "yellow")
                      
                      
                      
                    )),
                    
                    dashboardBody(
                      tabItems(
                        
                        # 1) Welcome ! tab  
                        tabItem(tabName = "beg",
                                p(h1(strong("ANAN CAPITAL"))),
                                h5(" * Past performance is not indicative future results * "),
                                fluidRow(valueBoxOutput("Q1",width = 3),
                                         valueBoxOutput("Q2",width = 3),
                                         valueBoxOutput("Q3",width = 3),
                                         valueBoxOutput("Q4",width = 3),
                                ),
                                
                                
                                
                                
                                fluidRow(column(9,box(dygraphOutput("Q5",height = 500),width = NULL,solidHeader = FALSE,status = "primary")
                                                
                                ),
                                
                                column(3,
                                       h2((strong("System S1 Program"))),
                                       h3(strong("Investment Objective")),
                                       h5("System S1 is a systematic long-term trend following program. The investment objective is to outperformed SET index with calculated risks of loss."),
                                       
                                       h3(strong("Investment Strategy")),
                                       h5("System aims to capture outperformed stocks in medium to long-term period by using trend following model with proper money framework"),
                                       
                                       h3(strong("Risk Management")),
                                       h5("The S1 Program is a compounded growth strategy : to compound money over time with respect to risk. Risk Management include:"),
                                       #h5(br()),
                                       h5("- Target Realized Risk : 10% ",br(),br(),"- Target Realized Volatility : 30%",br(),br(),"- Target Holding stocks : 7-15"),
                                       
                                       h3(strong("Fund Information")),
                                       h5("Fund Manager: ",strong("Nanthawat Anancharoenpakorn"),br(),br(),"Current AUM: ",strong("2.5 million")),
                                       
                                       #  h5("Fund Manager: ",br(),strong("Nanthawat Anancharoenpakorn"),br(),br(),"Current AUM: ",strong("2.5 million")),
                                       
                                       
                                       
                                )),
                                
                                fluidRow(column(9,box(DT::dataTableOutput("Q6",width = "100%",height = 200),width = NULL,title = "Historical Performance (%)",solidHeader = FALSE,status = "primary")),
                                         column(3,box(plotOutput("Q7",height = 200),width = NULL,solidHeader = FALSE,status = "primary",title = "Monthly Return Distribution" )
                                         )
                                         
                                         
                                         
                                         
                                         
                                         
                                         
                                         
                                         
                                ),
                                fluidRow(column(9,box(plotOutput("Q8",width = "100%",height = 500),width = NULL,title = "Monthly Return ",solidHeader = FALSE,status = "primary")),
                                         
                                         
                                         
                                         
                                         
                                         
                                         
                                         
                                         
                                         
                                ),
                                
                                
                                
                        ),                        
                        
                        
                        
                        # 2) Portfolio tab 
                        tabItem(tabName = "portfolio",
                                h2(" Internal")                        
                        ),                        
                        # 3) Past Performance 
                        tabItem(tabName = "pastperformance",
                                h2(" Internal")                        
                        ),
                        # - Sub 1 tab content 
                        tabItem(tabName = "equityanalysis",
                                h2("Internal")),
                        
                        # - Sub 2 tab content 
                        tabItem(tabName = "edgesanalysis",
                                h2("Internal")),
                        
                        # 4) Widget tab 
                        tabItem(tabName = "philosophy",
                                h2("Internal")
                        ),
                        # 5) Market tab 
                        tabItem(tabName = "marketmonitoring",
                                h2("Internal")
                        )
                        
                        
                        
                        
                        
                        
                      ) # Body( Tab-Item )
                    ) # Body
) # End


shinyApp(ui, server) 
