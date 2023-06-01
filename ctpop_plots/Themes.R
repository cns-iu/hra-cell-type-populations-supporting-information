# scatter graph
scatter_theme <-  theme(axis.text.x = element_text(angle=90, size = 15),
                        axis.text.y = element_text(size = 15),
                        plot.title = element_text(size = 25),
                        axis.title = element_text(size = 20),
                        strip.text = element_text(size=20),
                        legend.title = element_text(colour = "black", face = "bold.italic", family = "Arial", size=20),
                        legend.text = element_text(face = "italic", colour = "black", family = "Arial", size=20),
                        legend.key.size = unit(2,"line"),
)

# bar graph
bar_graph_theme <-  scatter_theme + 
  
  theme(
                        legend.text = element_text(face = "italic", colour = "black", family = "Arial", size=10),
                        legend.key.size = unit(1,"line"),
                        axis.text.x = element_text(hjust=1,vjust=0.2)
)


# cyberpunk
clr_bg   <- "black"
clr_bg2  <- "gray10"
clr_grid <- "gray30"
clr_text <- "#d600ff"

theme_cyberpunk <- function() {
  theme(
    # Plot / Panel
    plot.background = element_rect(fill = clr_bg, colour = clr_bg),
    # plot.margin = margin(1.5, 2, 1.5, 1.5, "cm"),
    panel.background = element_rect(fill = clr_bg, color = clr_bg),
    # Grid
    panel.grid = element_line(colour = clr_grid, size = 1),
    panel.grid.major = element_line(colour = clr_grid, size = 1),
    panel.grid.minor = element_line(colour = clr_grid, size = 1),
    axis.ticks.x = element_line(colour = clr_grid, size = 1),
    axis.line.y = element_line(colour = clr_grid, size = 0.5),
    axis.line.x = element_line(colour = clr_grid, size = 0.5),
    # Text
    plot.title = element_text(colour = clr_text),
    plot.subtitle = element_text(colour = clr_text),
    axis.text = element_text(colour = clr_text),
    axis.title = element_text(colour = clr_text),
    # Legend
    legend.background = element_blank(),
    legend.key = element_blank(),
    legend.title = element_text(colour = clr_text),
    legend.text = element_text(colour = "gray80", size = 12, face = "bold"),
    # Strip
    strip.background = element_rect(fill = clr_bg2, color = clr_bg2)
  )
}
