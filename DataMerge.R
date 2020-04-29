library(tidyverse)
#gets pollution ranking
get_pollution = read_csv("2019-Annual.csv") %>%
    mutate(
        `Measure Name` = as.factor(`Measure Name`),
        name = `State Name`,
        `Air Pollution` = Score
    ) %>%
    filter(`Measure Name` == "Air Pollution") %>%
    select(c(name,`Air Pollution`))
#Gets current results of Virus
current = read_csv("current.csv")
#Gets name of states
info = read_csv("info.csv") %>% select(state,name)
#Gets states rankings of different fields
state_health = read_csv("2019-Annual.csv") %>%
    filter(`Source Year` == 2019) %>%
    mutate(
        MeasureName = as.factor(`Measure Name`)
    ) %>%
    select(c(`State Name`,Score,MeasureName))
#pivots the rankings 
wide = pivot_wider(state_health,names_from = MeasureName,
                   values_from = Score) %>%
    slice(1:50)
# merges gives abbrevs names
all.info = inner_join(current,info,by = "state") %>%
    select(c(state,name,positive,negative,
             name)) %>%
    mutate(
        positiveRate = positive/(positive+negative)
    )
colnames(wide)[1] = "name"
#joins data
all.info = left_join(all.info,wide)
#joins pollution (it was measured strangly so needed to be seperate)
all.info = left_join(wide,get_pollution)
# save CSV in CWD
write_csv(all.info,"masterFile.csv")
