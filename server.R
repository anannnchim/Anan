##### System S1- Factsheet

# 15/ March / 2022

# > 0. Library
# - Create Function

# > 1. Import data : Accounting googgle sheet
# > 2. Prepare Data 
#    - Prepare Data
#    - Create Data
# > 3. Dashboard



##################################################################################################################################################################################

### 0. Library
library(quantmod)
library(dplyr)
library(ggplot2)
library(readxl)
attach(mtcars)
library(PerformanceAnalytics)
library(xts)
library(lubridate)
library(ggridges)
library(hrbrthemes)
library(scales)
library(dygraphs)
library(plotly)
library(reshape2)
library(gridExtra)
options(digits = 3)
library(ggthemes)

### 1. Soruce

# Accounting - NAV
DAILY.RETURN <- read.csv("https://docs.google.com/spreadsheets/d/1kP1Wi11o8OygNSx9zBTUDuVDDvpbCYoNjccIw1L3rVY/export?format=csv&gid=820566256")

# Accounting - SET
SET <-  read.csv("https://docs.google.com/spreadsheets/d/1kP1Wi11o8OygNSx9zBTUDuVDDvpbCYoNjccIw1L3rVY/export?format=csv&gid=1367243600")

# Accounting - MONTH
MONTHLY.RETURN <-  read.csv("https://docs.google.com/spreadsheets/d/1kP1Wi11o8OygNSx9zBTUDuVDDvpbCYoNjccIw1L3rVY/export?format=csv&gid=1434161237")

### 2. Prepare 


# NAV: Convert it to %
DAILY.RETURN$Ri <- DAILY.RETURN$Ri/100

# add Date
Date <- as.Date(DAILY.RETURN$Date)

## NAV: Data
DAILY.RETURN <- as.xts(DAILY.RETURN[-1],Date)

# NAV: Convert to data.frame
DAILY.RETURN <- as.data.frame(DAILY.RETURN)

# SET: Convert to data.frame
SET <- as.xts(SET[-1],as.Date(SET$Date))

# MONTH 
MONTHLY.RETURN <- MONTHLY.RETURN %>% select(Date,Return,date)

# Function: Equity Curve
nav <- function(x){
  a <- cumprod(x + 1) - 1
  return(a)
}


### 3. Create Data 


# Q1
Q1 <- paste0( " ", round( last(nav(DAILY.RETURN$Ri))*100, 0), "%" )

# Q2
Q2 <- paste0( " ", round( last(nav(dailyReturn(SET$Close)))*100, 0), "%" )

# Q3 
Q3 <- paste0( " ", round(VaR(MONTHLY.RETURN$Return,.99)*100*-1, 0), "%" )

# Q4 
Q4 <- paste0( " ", round( maxDrawdown(DAILY.RETURN)*100, 1), "%" )

# Q5
Q5 <-  round(cbind(nav(DAILY.RETURN),as.xts(nav(dailyReturn(SET$Close))[1:nrow(DAILY.RETURN)],Date)),3) ; colnames(Q5) <-  c("P.Ri","SET.Ri")

Q5 <-  dygraph((1+Q5[1:2])*10000, main = "Growth of 10,000 - VAMI", ylab = "Value in Baht") %>%
  
  dySeries("SET.Ri", label = "SET Value",strokeBorderWidth = 1,fillGraph = TRUE) %>%
  dySeries("P.Ri", label = "System S1 Value",strokeBorderWidth = 1,fillGraph = TRUE) %>%
  dyAxis("y", valueRange = c(9500,25000),gridLineColor = "lightblue")%>%
  dyAxis("x", drawGrid = FALSE) %>%
  dyOptions(stackedGraph = FALSE,
            colors = c("orange","lightblue"),
            fillGraph = TRUE, fillAlpha = .7,
            drawPoints = TRUE,pointSize = .5,
            drawGrid = TRUE,
            axisLineWidth = 1) %>%
  dyHighlight(highlightSeriesOpts = list(strokeWidth = 2.5),highlightCircleSize = 5) %>%
  dyLegend(showZeroValues = FALSE,show = "onmouseover", width = 400)

# Q6 Pending

Q6 <- as.xts(MONTHLY.RETURN$Return,as.Date(MONTHLY.RETURN$Date,"%Y-%m-%d")); colnames(Q6) <- "|YEAR|"
Q6 <- table.CalendarReturns(Q6,geometric = TRUE)



# Q7
Q7 <- MONTHLY.RETURN %>% mutate(n = c(1:nrow(MONTHLY.RETURN))) %>%
  mutate(n = reorder(n,Return,FUN = median)) %>% ggplot(aes(n,Return)) +
  geom_bar(stat = "identity",show.legend = FALSE,width = .3, col = "black", fill =  ifelse(MONTHLY.RETURN$Return > 0,"seagreen4","firebrick1")) +
  geom_hline(yintercept = mean(MONTHLY.RETURN$Return), linetype = "dashed",color = "lightblue", size = .5) +
  geom_hline(yintercept =0, linetype = "solid",color = "black", size = .5) +
  xlab("") + ylab("")+  theme_classic() +
  theme( axis.text.x=element_blank(),panel.grid.minor = element_blank(),panel.grid.major.x = element_blank()) +
  scale_y_continuous(labels = scales::percent_format(accuracy = 1)) 

# Q8
Q8 <- ggplot(MONTHLY.RETURN,aes(as.Date(MONTHLY.RETURN$date,"%Y-%m-%d"),Return*100)) +
  geom_bar(stat = "identity", color = "grey50", fill =  ifelse(MONTHLY.RETURN$Return > 0,"seagreen4","firebrick1"),width = 10) +
  scale_x_date(breaks = date_breaks("months"), labels = label_date_short())+
  theme_minimal() +
  xlab("") + ylab( "% ") + ylim(c(-20,20)) +
  geom_hline(yintercept = 0, linetype = "solid",color = "black", size = .2)  +
  theme(panel.grid.minor = element_blank(),axis.line = element_line(colour = "black")) 





# Server


server <- function(input, output) { 
  
  # 1.Welcome 
  ### 1) Snapshot
  output$Q1 <- renderInfoBox({ infoBox( "Since inception : System S1", Q1 , icon = icon("chart-line"), color = "light-blue") }) 
  output$Q2 <- renderInfoBox({ infoBox( "Since inception : SET index", Q2 , icon = icon("archway"), color = "yellow") }) 
  output$Q3 <- renderInfoBox({ infoBox( "Monthly VaR 99%", Q3 , icon = icon("arrow-down"), color = "navy") }) 
  output$Q4 <- renderInfoBox({ infoBox( "Maximum Drawdown", Q4 , icon = icon("sort-amount-down"), color = "red") }) 
  
  
  ### 2) NAV
  output$Q5 <-renderDygraph({ Q5 }) 
  output$Q6 <- DT::renderDataTable(DT::datatable({ Q6 }))
  output$Q7 <- renderPlot({ Q7 }) 
  output$Q8 <- renderPlot({ Q8 }) 
  
  
}




