library(dplyr)
library(data.table)
setwd('~/Downloads/')
hospital = fread('HospInfo.csv')
hospital$`Hospital overall rating footnote`=NULL
hospital$`Safety of care national comparison footnote`=NULL
hospital$`Mortality national comparison footnote`=NULL
hospital$`Effectiveness of care national comparison footnote`=NULL
hospital$`Timeliness of care national comparison footnote`=NULL
hospital$`Readmission national comparison footnote`=NULL
hospital$`Efficient use of medical imaging national comparison footnote`=NULL
hospital$`Patient experience national comparison footnote`=NULL
hospital$Location=NULL
hospital=filter(hospital,`Hospital overall rating`!='Not Available')
hospital$`Hospital overall rating`=as.numeric(hospital$`Hospital overall rating`)

g=ggplot(hospital,aes(x=State,y=`Hospital overall rating`))
g+stat_summary(fun.y="mean", geom="bar")

h=ggplot(hospital,aes(x=`Safety of care national comparison`,y=`Hospital overall rating`))
h+stat_summary(fun.y="mean", geom="bar")

h=ggplot(hospital,aes(x=`Mortality national comparison`,y=`Hospital overall rating`))
h+stat_summary(fun.y="mean", geom="bar")
#you can go thru many of these

#Then we want to group by rating

#a) Also for shiny app, group by state and show on map
#average rating
#b) percentages (by type) of above, below and same
#possibly show a on left and b on right



#Group by state
hospital_bystate= hospital %>% 
  group_by(., State) %>% 
  summarise('total'=n(), 'average_rating'=mean(`Hospital overall rating`))

chart=gvisGeoChart(data = hospital_bystate,locationvar = "State", "average_rating",
             options=list(region="US", displayMode="regions", 
                          resolution="provinces",
                          width="auto", height="auto", colors = c("blue")))


plot(chart)

hospital_bystate2=hospital %>% 
  group_by(State) %>% 
  summarise('mortalitycomparisonfreq'= sum(`Mortality national comparison`=="Above the National average")/n())

chart2=gvisGeoChart(data = hospital_bystate2,locationvar = "State", "mortalitycomparisonfreq",
                   options=list(region="US", displayMode="regions", 
                                resolution="provinces",
                                width="auto", height="auto", colors = c("red")))

plot(chart2)