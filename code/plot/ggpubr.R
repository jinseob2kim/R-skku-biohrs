# ggpubr package

## histogram
data3 <- data2 %>% mutate(HTN = as.factor(ifelse(Q_PHX_DX_HTN==1, "Yes", "No")))
p <- gghistogram(data=data3, x="WGHT",
                 color="HTN", fill = "HTN", add="mean")
plot1 <- ggpar(p,
               main="Weight distrubution by HTN history",
               xlab="Weight(kg)",
               legend.title="HTN Dx history")
print(plot1)

## box plot
p <- ggboxplot(data=data3, x="HTN", y="WGHT", color="HTN") +
  stat_compare_means(method = "t.test", label.x.npc = "middle")
plot2 <- ggpar(p,
               main="Weight distrubution by HTN history",
               ylab="Weight(kg)",
               xlab="HTN Dx history",
               legend="none")
print(plot2)

my_comparisons <- list(c("1", "2"), c("2", "3"), c("1", "3"))
p <- ggboxplot(data=data3, x="Q_SMK_YN", y="WGHT", color="Q_SMK_YN") +
  stat_compare_means(comparisons = my_comparisons) +
  stat_compare_means(label.y = 150) +
  scale_x_discrete(labels=c("Never", "Ex-smoker", "Current"))
plot3 <- ggpar(p,
               main="Weight distrubution by smoking",
               ylab="Weight(kg)",
               xlab="Smoking",
               legend="none")
print(plot3)

## scatter plot
p <- ggscatter(data=data3, x="HGHT", y="WGHT", 
               add = "reg.line", conf.int = TRUE,
               add.params = list(color = "navy", fill = "lightgray")) +
  stat_cor(method = "pearson")
plot4 <- ggpar(p,
               ylab="Weight(kg)",
               xlab="Height(cm)")
print(plot4)

p <- ggscatter(data=data3, x="HGHT", y="WGHT", color="HTN", alpha=0.5,
               add = "reg.line", conf.int = TRUE) +
  stat_cor(aes(color = HTN))
plot5 <- ggpar(p,
               ylab="Weight(kg)",
               xlab="Height(cm)")
print(plot5)

## ggarange
ggarrange(plot2, plot3,
          labels = c("A", "B"),
          ncol = 2, nrow = 1)

# Save plots
library(rvg); library(officer)

plot_file <- read_pptx() %>%
  add_slide() %>% ph_with(dml(ggobj = plot1), location=ph_location_type(type="body")) %>%
  add_slide() %>% ph_with(dml(ggobj = plot4), location=ph_location_type(type="body")) %>%
  add_slide() %>% ph_with(dml(ggobj = plot5), location=ph_location_type(type="body"))

print(plot_file, target = "plot_file.pptx")