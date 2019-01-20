
# library(tools)

# install.packages("UpSetR")
# install.packages("dplyr")
# install.packages("tidyr")
# install.packages("readr")

library(tidyr)
library(reshape2)
library(UpSetR)
library(ggplot2)

library(readr) # write_lines
library(jsonlite) # toJSON

size <- 5000
df.raw <- read.csv(sprintf('casts-%s.csv', size))
df.brokenlinks <- df.raw[df.raw$value == '?BrokenLink', ]
df.empty <- df.raw[df.raw$value == '', ]

df <- df.raw
df <- df[df$value != '', ]
df <- df[df$value != '?BrokenLink', ]
df$key <- ''

df.malformed <- df[grep("#",df$value,invert=TRUE),]

df.long <- df
df.long <- separate_rows(df.long, value, sep=',')
df.long <- separate_rows(df.long, value, sep=':')
df.long[grep("#", df.long$value),]$key <- 'pattern'
df.long[grep("@", df.long$value),]$key <- 'kind'
df.long[df.long$key == '',]$key <- 'args'

categories <- list(
  'Guarded' = c('#PatternMatching', '#TypeTag', "#Equals"),
  'Creation' = c('#Family', '#Factory', '#KnownLibraryMethod', '#Tag', '#Deserialization'),
  'Code Smell' = c('#Redundant', '#VariableLessSpecificType', '#RawTypes'),
  'Tuples' = c('#LookupById', '#ObjectAsArray', '#StaticResource')
  )

df.patterns <- df.long[df.long$key == 'pattern',]
df.patterns$value <- as.factor(df.patterns$value)
tb <- table(df.patterns$value)
df.patterns$value <- factor(df.patterns$value, levels=names(tb[order(tb, decreasing = FALSE)]))
df.patterns$category <- ''
for (category in names(categories)) {
  df.patterns[df.patterns$value %in% categories[[category]],]$category <- category
}
df.patterns$category <- factor(df.patterns$category, levels=names(categories))

pdf(sprintf('table-patterns-%s.pdf', size))
p <- ggplot(df.patterns, aes(x=value))+
  geom_bar()+
  geom_text(stat='count', aes(label=..count..,y=..count..+3))+
  facet_grid(category~., scales="free", space="free") +
  coord_flip()+
#  theme_minimal()+
  theme(strip.text.y = element_text(angle = 0))+
  labs(x="Cast Patterns", y = "# Instances")
print(p)
dev.off()

ps <- levels(as.factor(df.patterns$value))
npattern <- length(ps)
#casts.patterns.wide.any <- casts.patterns.wide[casts.patterns.wide$Any != 0, ]
#casts.patterns.wide.pat <- casts.patterns.wide[casts.patterns.wide$Any == 0, ]
#any.percentage <- nrow(casts.patterns.wide.any)*100/nrow(casts.patterns.wide)
#pat.percentage <- nrow(casts.patterns.wide.pat)*100/nrow(casts.patterns.wide)
#values <- c(
#  sprintf("\\newcommand{\\npattern}{%s}", format(npattern, big.mark=',')),
#  sprintf("\\newcommand{\\anypercentage}{%#.2f}", any.percentage),
#  sprintf("\\newcommand{\\patpercentage}{%#.2f}", pat.percentage)
#)
#writeDef('casts.def', values)










#csv.wide <- dcast(csv.long.args, castid ~ key, value.var="value")
#csv.wide <- dcast(csv.long, castid~patterns, length, value.var="patterns")

#pdf(sprintf('upset-patterns-%s.pdf', size))
#upset(csv.wide,nsets=ncol(csv.wide),nintersects=NA,mb.ratio = c(0.3, 0.7))
#dev.off()


#casts.patterns.total <- dcast(casts.patterns.long, patterns~"total", length, value.var="patterns")


casts.tags.long <- separate_rows(casts.raw, tags, sep='\\|')
casts.tags.wide <- dcast(casts.tags.long, id+obs~tags, length, value.var="tags")

pdf('analysis/upset-tags.pdf')
upset(casts.tags.wide,nsets=ncol(casts.tags.wide),mb.ratio = c(0.2, 0.8))
dev.off()

casts.tags.table <- dcast(casts.tags.long, tags~"count", length, value.var="obs")
casts.tags.table %>% toJSON() %>% write_lines('analysis/tags.json')

casts.long <- separate_rows(casts.raw, patterns, sep='\\|')
casts.long <- separate_rows(casts.long, tags, sep='\\|')

for (pattern in levels(as.factor(casts.patterns.long$patterns))) {
  upsetTagsXPattern <- sprintf('analysis/upset-tags-%s.pdf', pattern)
  print(upsetTagsXPattern)
  casts.tagsXPattern <- dcast(casts.long[casts.long$patterns==pattern,], id+obs~tags, length, value.var="tags")
  
  pdf(upsetTagsXPattern)
  upset(casts.tagsXPattern,nsets=ncol(casts.tagsXPattern),mb.ratio = c(0.2, 0.8))
  dev.off()
}


# casts.delim <- (function(casts.noicon) {
#   casts.noicon$tags <- paste('|', casts.noicon$tags, '|', sep='')
#   casts.noicon
# })(casts.noicon)
# 
# casts.expand <- (function(casts.delim) {
#   tags.expanded <- read.csv(file='tagsExpanded.csv', header=TRUE, strip.white = TRUE)
#   tags.expanded$tag <- paste('|', tags.expanded$tag, '|', sep='')
#   tags.expanded$supertags <- paste('|', tags.expanded$supertags, '|', sep='')
# 
#   expand <- function(tags) {
#     for (t in rownames(tags.expanded)) {
#       tags = gsub(tags.expanded[t, 'tag'], tags.expanded[t, 'supertags'], tags, fixed=TRUE)
#     }
#     tags
#   }
# 
#   casts.delim$tags <- expand(casts.delim$tags)
#   # Strip first&last delim '|' to avoid empty rows when in long format
#   casts.delim$tags <- substring(casts.delim$tags, 2)
#   casts.delim$tags <- substring(casts.delim$tags, 1, nchar(casts.delim$tags) - 1)
#   
#   casts.delim
# })(casts.delim)
