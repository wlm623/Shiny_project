library(dplyr)
library(data.table)
library(plotly)


hospital = fread('HospInfo.csv')
hospital=setnames(hospital, make.names(colnames(hospital)))
#footnotes=grep('footnote',colnames(hospital), perl = T) #to find unneeded footnote rows
#grep('Location',colnames(hospital), perl = T) #to find unneeded location row

hospital=hospital[,-c(14,16,18,20,22,24,26,28,29)] #deletes unwanted columns

myscore = function(string){ #This function will be used to reassign rows to have scores
  ifelse(string =='Same as the National average',0, 
         ifelse(string == 'Above the National average',1,
                ifelse(string == 'Below the National average', -1, 
                       ifelse(string == 'Not Available', NA, string)
                )
         )
  )
}


hospital2= hospital %>% 
  mutate(.,'mortality.score'=as.numeric(myscore(Mortality.national.comparison)))



hospital2=hospital
hospital2$Hospital.overall.rating = as.numeric(myscore(hospital2$Hospital.overall.rating))
hospital2$Mortality.national.comparison=as.numeric(myscore(hospital2$Mortality.national.comparison))
hospital2$Safety.of.care.national.comparison=as.numeric(myscore(hospital2$Safety.of.care.national.comparison))
hospital2$Readmission.national.comparison=as.numeric(myscore(hospital2$Readmission.national.comparison))
hospital2$Patient.experience.national.comparison=as.numeric(myscore(hospital2$Patient.experience.national.comparison))
hospital2$Effectiveness.of.care.national.comparison=as.numeric(myscore(hospital2$Effectiveness.of.care.national.comparison))
hospital2$Timeliness.of.care.national.comparison=as.numeric(myscore(hospital2$Timeliness.of.care.national.comparison))
hospital2$Efficient.use.of.medical.imaging.national.comparison=as.numeric(myscore(hospital2$Efficient.use.of.medical.imaging.national.comparison))
hospitalgroup= hospital2 %>% 
  group_by(.,State) %>% 
  summarise_each(.,funs(mean(.,na.rm=TRUE)), Hospital.overall.rating,Mortality.national.comparison,Safety.of.care.national.comparison,
                 Readmission.national.comparison,Patient.experience.national.comparison,Effectiveness.of.care.national.comparison,
                 Timeliness.of.care.national.comparison, Efficient.use.of.medical.imaging.national.comparison) %>% 
  filter(.,!is.na(Hospital.overall.rating)) %>% 
  filter(., !is.na(Safety.of.care.national.comparison))

hospitalgroup1= hospitalgroup
colnames(hospitalgroup1)=c('State','Rating','Mortality', 'Safety', 'Readmission','Experience', 'Effectiveness', 'Timeliness', 'Imaging')
hospitalgroup1=hospitalgroup1[,c(1,3,9,4,7,8,5,2,6)]

choice <- colnames(hospitalgroup)[-1]




