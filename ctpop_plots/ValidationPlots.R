# load required libraries
library(tidyverse)
library(umap)

# load other scripts
source("themes.R")

####################
####### V1.P1 ######
####################
# load data
v1.p1 = read_csv("../data/reports/validation-v1p1.csv")
v1.p1

avg_cosine_sim <- v1.p1 %>% group_by(as_in_collisions) %>% summarise(avg = mean(similarity))
avg_cosine_sim            
plot.simple = ggplot(avg_cosine_sim)+
  geom_bar(aes(x=as_in_collisions, y=avg), stat = "identity")+
  labs(y = "Average cosine similarity", x = "Is the anatomical structure found in the actual RUI locaiton of the dataset?")
plot.simple

plot.jitter = ggplot(v1.p1, aes(x = as_in_collisions, y = similarity))+
  geom_jitter()+
  labs(y = "Cosine similarity", x = "Is the anatomical structure found in the actual RUI locaiton of the dataset?")
plot.jitter

v1.p1.means = v1.p1 %>% group_by(as, as_in_collisions) %>% summarise(mean_overlap=mean(similarity))
v1.p1.means
plot.means = ggplot(v1.p1.means)+
  geom_bar(aes(x=as, y=mean_overlap, fill=as_in_collisions), stat = "identity", position = "dodge")+
  labs(y = "Average cosine similarity", x = "Is the anatomical structure found in the actual RUI location of the dataset?")+
  theme(
    axis.text.x = element_text(angle = 90, vjust = 0.5)
  )
plot.means

####################
####### V1.P2 ######
####################
# load data
v1.p2 = read_csv("../data/reports/validation-v1p2.csv")
v1.p2

v1.p2.overlap = v1.p2 %>% group_by(as, as_in_collisions) %>% summarise(mean_overlap=mean(pct_hra_ct_overlap))
v1.p2.overlap
plot.bar = ggplot(v1.p2.overlap)+
  geom_bar(aes(x=as, y=mean_overlap, fill=as_in_collisions), stat = "identity", position = "dodge")+
  labs(y = "Average cell type overlap", x = "Is the anatomical structure found in the actual RUI location of the dataset?")+
  theme(
    axis.text.x = element_text(angle = 90, vjust = 0.5)
  )
plot.bar

# V1.P2.Extra1
v1.p2.extra1 = read_csv("../data/reports/validation-v1p2-extra1.csv")
v1.p2.extra1 %>% summary()

# V1.P2.Extra2
v1.p2.extra2 = read_csv("../data/reports/validation-v1p2-extra2.csv")
v1.p2.extra2 %>% summary()

# V1.P2.Extra3
v1.p2.extra3 = read_csv("../data/reports/validation-v1p2-extra3.csv")
v1.p2.extra3 %>% summary()

####################
####### V1.P3 ######
####################
# load data
v1.p3 = read_csv("../data/reports/validation-v1p3.csv")
v1.p3

v1.p3.sim = v1.p3 %>% group_by(corridor) %>% summarise(mean_distance=mean(distance), mean_similarity = mean(similarity))
v1.p3.sim
plot.sim = ggplot(v1.p3.sim, aes(x=corridor, y = mean_distance, fill=mean_similarity))+
  geom_bar(stat = "identity")+
  theme(
    axis.text.x = element_text(angle = 90, vjust = 0.5, hjust=-.1)
  )
plot.sim

p.sim.scatter = ggplot(v1.p3.sim, aes(x=mean_similarity, y = mean_distance))+
  # geom_bar(stat = "identity")+
  geom_point()+
  theme(
    axis.text.x = element_text(angle = 90, vjust = 0.5, hjust=-.1)
  )+
  geom_smooth(method='lm', formula= y~x)
p.sim.scatter

####################
####### V2 #########
####################
# load data
v2 = read_csv("../data/reports/validation-v2.csv")
v2

v2 = v2 %>% group_by(sample, similarity) %>%  summarise(mean_sim = mean(v2$similarity)) %>% mutate(diff=mean_sim-similarity)

plot.scatter = ggplot(v2, aes(x = sample, y = similarity, color=diff))+
  geom_point(stat = "identity")+
  scale_color_continuous(type = "viridis")
plot.scatter

####################
####### V3 #########
####################
# See Gephi



####################
####### V4 #########
####################
v4 = read_csv("../data/reports/validation-v4.csv")
v4

####################
####### V5 #########
####################
# See Gephi

