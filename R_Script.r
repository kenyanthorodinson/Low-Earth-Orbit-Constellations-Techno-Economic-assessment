library(ggpubr)
library(ggplot2)
library(tidyverse)
install.packages("ggtext")
library(ggtext)

# Set your working directory
setwd("C://Users//bmwan//Desktop//5.2//Link Budget")

# Load the data
data <- read.csv(file.path("results", "uq_results.csv"), header = TRUE)


#########################
##Channel capacity with##
#########################

df = data %>%
  group_by(constellation,cnr_scenario) %>%
  summarize(mean = mean(channel_capacity_mbps),
            sd = sd(channel_capacity_mbps))

df$cnr_scenario = as.factor(df$cnr_scenario)
df$Constellation = factor(df$constellation)
df$CNR = factor(
  df$cnr_scenario,
  levels = c("Low (<7.5 dB)", "Baseline(7.6 - 10.5 dB)", "High(>13.5 dB)"),
  labels = c("Low", "Baseline", "High")
)

chn_capacity <- ggplot(df, aes(x = Constellation, y = mean / 1e3, fill = CNR)) +
  geom_bar(stat = "identity",
           position = position_dodge(),
           width = 0.98) +
  geom_errorbar(
    aes(ymin = mean / 1e3 - sd / 1e3,
        ymax = mean / 1e3 + sd / 1e3),
    width = .2,
    position = position_dodge(.98),
    color = "black",
    size = 0.2
  ) +
  scale_fill_brewer(palette = "Dark2") + theme_minimal() +
  labs(
    colour = NULL,
    title = " ",
    subtitle = "a",
    x = NULL,
    y = "Channel Capacity\n(Gbps)",
    fill = "QoS\nScenario"
  ) +
  scale_y_continuous(
    labels = function(y)
      format(y, scientific = FALSE),
    expand = c(0, 0)
  ) + theme_minimal() +
  theme(axis.title.y = element_text(size = 6),
        strip.text.x = element_blank(),
        panel.border = element_blank(),
        panel.grid.major = element_blank(),
        panel.grid.minor = element_blank(),
        axis.text.x = element_text(size = 6),
        axis.text.y = element_text(size = 6),
        axis.line.x  = element_line(size = 0.15),
        axis.line.y  = element_line(size = 0.15),
        legend.position = "bottom", 
        axis.title = element_text(size = 6),
        legend.title = element_text(size = 6),
        legend.text = element_text(size =6),
        plot.subtitle = element_text(size = 8, face = "bold"),
        plot.title = element_text(size = 10, face = "bold", hjust = -0.45, vjust=2.12))

print(chn_capacity)

#############################
##Single Satellite Capacity##
#############################

df = data %>%
  group_by(constellation, cnr_scenario) %>%
  summarise(
    mean = mean(single_satellite_capacity_in_Gbps),
    sd = sd(single_satellite_capacity_in_Gbps)
  ) %>%
  ungroup()

df$cnr_scenario = as.factor(df$cnr_scenario)
df$Constellation = factor(df$constellation)
df$CNR = factor(
  df$cnr_scenario,
  levels = c("Low (<7.5 dB)", "Baseline(7.6 - 10.5 dB)", "High(>13.5 dB)"),
  labels = c("Low", "Baseline", "High")
)

sat_capacity <-
  ggplot(df, aes(x = Constellation, y = mean / 1e3, fill = CNR)) +
  geom_bar(stat = "identity",
           position = position_dodge(),
           width = 0.98) +
  geom_errorbar(
    aes(ymin = mean / 1e3 - sd / 1e3,
        ymax = mean / 1e3 + sd / 1e3),
    width = .2,
    position = position_dodge(.98),
    color = "black",
    size = 0.2
  ) +
  scale_fill_brewer(palette = "Dark2") + theme_minimal() +
    labs(
    colour = NULL,
    title = " ",
    subtitle = "b",
    x = NULL,
    y = "Satellite Capacity\n(Gbps)",
    fill = "QoS\nScenario"
  ) +
  scale_y_continuous(
    labels = function(y)
      format(y, scientific = FALSE),
    expand = c(0, 0),
    limits = c(0, 30)
  ) +
  theme_minimal() +
  theme(axis.title.y = element_text(size = 6),
    strip.text.x = element_blank(),
    panel.border = element_blank(),
    panel.grid.major = element_blank(),
    panel.grid.minor = element_blank(),
    axis.line.x  = element_line(size = 0.15),
    axis.line.y  = element_line(size = 0.15),
    axis.text.x = element_text(size = 6),
    axis.text.y = element_text(size = 6),
    legend.position = "bottom", axis.title = element_text(size = 6),
    legend.title = element_text(size = 6),
    legend.text = element_text(size =6),
    plot.subtitle = element_text(size = 8, face = "bold"),
    plot.title = element_text(size = 10, face = "bold", hjust = -0.45, vjust=2.12))
print(sat_capacity)

#######################################
##Total Usable Constellation capacity##
#######################################

df = data %>%
  group_by(constellation, cnr_scenario) %>%
  summarise(mean = mean(constelation_capacity * 0.65),
            sd = sd(constelation_capacity * 0.65)) %>%
  ungroup()

df$cnr_scenario = as.factor(df$cnr_scenario)
df$Constellation = factor(df$constellation)
df$CNR = factor(
  df$cnr_scenario,
  levels = c("Low (<7.5 dB)", "Baseline(7.6 - 10.5 dB)", "High(>13.5 dB)"),
  labels = c("Low", "Baseline", "High")
)

const_capacity <-
  ggplot(df, aes(x = Constellation, y = (mean) * 0.65 / 1e6,
                 fill = CNR)) +
  geom_bar(stat = "identity",
           position = position_dodge(),
           width = 0.98) +
  geom_errorbar(
    aes(ymin = mean * 0.65 / 1e6 - sd * 0.65 / 1e6,
        ymax = mean * 0.65 / 1e6 + sd * 0.65 / 1e6),
    width = .2,
    position = position_dodge(.98),
    color = "black",
    size = 0.2
  ) +
  scale_fill_brewer(palette = "Dark2") +
    labs(
    colour = NULL,
    title = " ",
    subtitle = "c",
    x = NULL,
    y = "Total Usable Constellation\nCapacity (Tbps)",
    fill = "QoS\nScenario"
  ) +
  scale_y_continuous(
    labels = function(y)
      format(y, scientific = FALSE),
    expand = c(0, 0),
    limits = c(0, 20)
  ) +
  theme_minimal() + 
  theme(axis.title.y = element_text(size = 6),
    strip.text.x = element_blank(),
    panel.border = element_blank(),
    panel.grid.major = element_blank(),
    panel.grid.minor = element_blank(),
    axis.text.x = element_text(size = 6),
    axis.text.y = element_text(size = 6),
    axis.title = element_text(size = 6),
    axis.line.x  = element_line(size = 0.15),
    axis.line.y  = element_line(size = 0.15),
    legend.position = "bottom" ,
    legend.title = element_text(size = 6),
    legend.text = element_text(size =6),
    plot.subtitle = element_text(size = 8, face = "bold"),
    plot.title = element_text(size = 10, face = "bold", hjust = -0.45, vjust=2.12))
print(const_capacity)


################################
##Mean capacity per user##
################################

setwd("C://Users//bmwan//Desktop//5.2//Link Budget")
data2 <- read.csv(file.path("starlink_hug.csv"))

df <- data2 %>%
  group_by(NAME_1) %>%
  summarize(mean = mean(capacity_user_Mbps),
            sd = sd(capacity_user_Mbps))

df$NAME_1 <- factor(df$NAME_1)

capacity_user_Mbps <- ggplot(df, aes(x = NAME_1, y = mean)) +
  geom_bar(stat = "identity", width = 0.98, position = position_dodge()) +
  geom_errorbar(
    aes(ymin = mean - sd, ymax = mean + sd),
    width = 0.2,
    position = position_dodge(0.98),
    color = "black",
    size = 0.2
  ) +
  scale_fill_brewer(palette = "Dark2") +
  labs(
    colour = NULL,
    title = " ",
    subtitle = "d",
    x = NULL,
    y = "Mean Capacity\n(Mbps/User)",
    fill = "Adoption\nScenario"
  ) + 
  scale_y_continuous(
    labels = function(y) format(y, scientific = FALSE),
    expand = c(0, 0)
  ) + theme_minimal() +
  theme(
    axis.title.y = element_text(size = 6),
    strip.text.x = element_blank(),
    panel.border = element_blank(),
    panel.grid.major = element_blank(),
    panel.grid.minor = element_blank(),
    axis.text.x = element_text(size = 6),
    axis.text.y = element_text(size = 6),
    axis.line.x = element_line(size = 0.15),
    axis.line.y = element_line(size = 0.15),
    legend.position = "bottom",
    axis.title = element_text(size = 6),
    legend.title = element_text(size = 6),
    legend.text = element_text(size = 6),
    plot.subtitle = element_text(size = 8, face = "bold"),
    plot.title = element_text(size = 10, face = "bold", hjust = -0.45, vjust = 2.12))
print(capacity_user_Mbps)


#######################
##capacity_subscriber##
#######################
setwd("C://Users//bmwan//Desktop//5.2//Link Budget//results")
data3 <- read.csv(file.path("uq_parameters.csv"))

df <- data2 %>%

  group_by(constellation, subscriber_scenario) %>%
  summarize(mean = mean(monthly_traffic_GBPs),
            sd = sd(monthly_traffic_GBPs))

df$subscriber_scenario = as.factor(df$subscriber_scenario)
df$Constellation = factor(df$constellation)
df$subscriber_scenario = factor(
  df$subscriber_scenario,
  levels = c("subscribers_low", "subscribers_baseline", "subscribers_high"),
  labels = c("Low", "Baseline", "High")
)

capacity_user_Mbps <-
  ggplot(df, aes(x = Constellation, y = mean,
                 fill = subscriber_scenario)) +
  geom_bar(stat = "identity",
           width = 0.98,
           position = position_dodge()) +
  geom_errorbar(
    aes(ymin = mean - sd,
        ymax = mean + sd),
    width = .2,
    position = position_dodge(.98),
    color = "black",
    size = 0.2
  ) +
  scale_fill_brewer(palette = "Dark2") +
    labs(
    colour = NULL,
    title = " ",
    subtitle = "e",
    x = NULL,
    y = "Mean Monthly Traffic\n(GB/User)",
    fill = "Adoption\nScenario"
  ) +
  scale_y_continuous(
    labels = function(y)
      format(y, scientific = FALSE),
    expand = c(0, 0),
  ) + theme_minimal() +
  theme(axis.title.y = element_text(size = 6),
    strip.text.x = element_blank(),
    panel.border = element_blank(),
    panel.grid.major = element_blank(),
    panel.grid.minor = element_blank(),
    axis.text.x = element_text(size = 6),
    axis.text.y = element_text(size = 6),
    axis.line.x  = element_line(size = 0.15),
    axis.line.y  = element_line(size = 0.15),
    legend.position = "bottom", axis.title = element_text(size = 6),
    legend.title = element_text(size = 6),
    legend.text = element_text(size =6),
    plot.subtitle = element_text(size = 8, face = "bold"))


##########################
##Average users per area##
##########################

df = data3 %>%
  group_by(constellation, subscriber_scenario) %>%
  summarize(mean = mean(user_per_area),
            sd = sd(user_per_area))

df$subscriber_scenario = as.factor(df$subscriber_scenario)
df$Constellation = factor(df$constellation)
df$subscriber_scenario = factor(
  df$subscriber_scenario,
  levels = c("subscribers_low", "subscribers_baseline", "subscribers_high"),
  labels = c("Low", "Baseline", "High")
)
m
per_user_area <-
  ggplot(df, aes(x = Constellation, y = mean,
                 fill = subscriber_scenario)) +
  geom_bar(stat = "identity",
           width = 0.98,
           position = position_dodge()) +
  scale_fill_brewer(palette = "Dark2") +
  labs(
    colour = NULL,
    title = " ",
    subtitle = "f",
    x = NULL,
    fill = "Adoption\nScenario"
  ) + ylab("Mean Subscribers<br>(Users/km<sup>2</sup>)") +
  scale_y_continuous(
    labels = function(y)
      format(y, scientific = FALSE),
    expand = c(0, 0),
  ) + theme_minimal() +
  theme(axis.title.y = element_markdown(size = 6),
    strip.text.x = element_blank(),
    panel.border = element_blank(),
    panel.grid.major = element_blank(),
    panel.grid.minor = element_blank(),
    axis.text.x = element_text(size = 6),
    axis.text.y = element_text(size = 6),
    axis.line.x  = element_line(size = 0.15),
    axis.line.y  = element_line(size = 0.15),
    legend.position = "bottom", axis.title = element_text(size = 6),
    legend.title = element_text(size = 6),
    legend.text = element_text(size = 6),
    plot.subtitle = element_text(size = 8, face = "bold"),
    plot.title = element_text(size = 10, face = "bold", hjust = -0.45, vjust=2.12))
print(per_user_area)

####################################
## Combine all the capacity plots ##
####################################

#Row 1, subplots a-c
pub_qos <- ggarrange(
  chn_capacity,
  sat_capacity,
  const_capacity,
  ncol = 3,
  common.legend = T,
  legend = "bottom",
  font.label = list(size = 9)
)

#Row 2, subplots d-f
pub_subs <- ggarrange(
  capacity_per_user,
  capacity_subscriber,
  per_user_area,
  ncol = 3,
  common.legend = T,
  legend = "bottom",
  font.label = list(size = 9)
)

#Assemble rows 1 and 2
pub_cap <- ggarrange(
  pub_qos,
  pub_subs,
  nrow = 2,
  common.legend = F,
  legend = "bottom",
  font.label = list(size = 9)
)

dir.create(file.path(folder, "figures"), showWarnings = FALSE)

path = file.path(folder, "figures", "g_capacity_metrics.png")
png(
  path,
  units = "in",
  width = 5.5,
  height = 4,
  res = 480
)
print(pub_cap)
dev.off()