
# install.packages("tidyr")

library(tidyr)
library(ggplot2)
library(plyr)

groups <- list(
  'Guarded' = c('PatternMatching', 'TypeTag', "Equals", 'GetByClassLiteral', 'ClassForName'),
  'Creational' = c('Family', 'Factory', 'KnownLibraryMethod', 'Tag', 'Deserialization', 'CreateByClassLiteral', 'StackSymbol'),
  'Tuples' = c('LookupById', 'ObjectAsArray', 'StaticResource'),
  'Member Resolution' = c('SelectOverload', 'AccessPrivateField'),
  'Variance' = c('Clone', 'CovariantReturn', 'RemoveTypeParameter', 'CovariantArrays'),
  'Complex Types' = c('ImplicitIntersectionType', 'UnionType'),
  'Structural' = c('SoleSubclassImplementation', 'RecursiveGeneric'),
  'Reflection' = c('ReflectiveAccesibility', 'NewDynamicInstance', 'ReflectiveMethodInvoke', 'ReflectiveFieldGet'),
  'Unchecked' = c('UncheckedCast', 'FromWildcard', 'WildcardClassLiteral'),
  'Code Smell' = c('Redundant', 'VariableLessSpecificType', 'RawTypes', 'Literal')
)

size <- 5000

df.raw <- read.csv(sprintf('casts-%s.csv', size))
df.raw$s <- NULL
df.raw$t <- NULL
df.raw$tag <- NULL

df.brokenlinks <- df.raw[df.raw$value == '?BrokenLink', ]
df.empty <- df.raw[df.raw$value == '', ]

df <- df.raw
df <- df[df$value != '', ]
df <- df[df$value != '?BrokenLink', ]
df$key <- ''

df.malformed1 <- df[grep("#",df$value,invert=TRUE),]
df.malformed2 <- df[grep(",",df$value,invert=TRUE),]
df.malformed3 <- df[grep("@",df$value,invert=TRUE),]

df.long <- df
df.long <- separate_rows(df.long, value, sep=',')
df.long <- separate_rows(df.long, value, sep=':')
df.long[grep("#", df.long$value),]$key <- 'pattern'
df.long[grep("@", df.long$value),]$key <- 'scope'
df.long[df.long$key == '',]$key <- 'args'

df.patterns <- spread(df.long, key=key, value=value)
df.patterns$pattern <- substring(df.patterns$pattern, 2)
df.patterns$pattern <- as.factor(df.patterns$pattern)
df.patterns$scope <- substring(df.patterns$scope, 2)
df.patterns$scope <- factor(df.patterns$scope, levels=c('src', 'test', 'gen'))
df.patterns$scope <- revalue(df.patterns$scope, c('src'='Sources', 'test'='Test', 'gen'='Generated'))
tb <- table(df.patterns$pattern)
df.patterns$pattern <- factor(df.patterns$pattern, levels=names(tb[order(tb, decreasing = FALSE)]))
df.patterns.prim <- df.patterns[df.patterns$pattern == 'Prim', ]
df.patterns <- df.patterns[df.patterns$pattern != 'Prim', ]
df.patterns$group <- ''
for (group in names(groups)) {
  df.patterns[df.patterns$pattern %in% groups[[group]],]$group <- group
}
df.patterns$group <- factor(df.patterns$group, levels=names(groups))

pdf(sprintf('table-patterns-%s.pdf', size))
p <- ggplot(df.patterns, aes(x=pattern))+
  geom_bar(aes(fill=scope), position=position_stack(reverse = TRUE))+
  geom_text(stat='count', aes(label=..count..,y=..count..+3))+
  facet_grid(group~., scales="free", space="free")+
  coord_flip()+
  theme(strip.text.y=element_text(angle = 0), legend.position="top")+
  labs(x="Cast Usage Patterns", y = "# Instances")+
  scale_fill_discrete(name="Scope")
print(p)
dev.off()

lpatterns <- levels(as.factor(df.patterns$value))
lgroups <- levels(as.factor(df.patterns$group))
values <- c(
  sprintf("\\newcommand{\\npattern}{%s}", format(length(lpatterns), big.mark=',')),
  sprintf("\\newcommand{\\ngroup}{%s}", format(length(lgroups), big.mark=',')),
  sprintf("\\newcommand{\\nprim}{%s}", format(nrow(df.patterns.prim), big.mark=',')),
  sprintf("\\newcommand{\\nbrokenlinks}{%s}", format(nrow(df.brokenlinks), big.mark=','))
)
write(values, 'casts.def')


# pname <- 'TypeTag'
for (pname in levels(df.patterns$pattern)) {
  pdf(sprintf('patterns/table-pattern-%s-%s.pdf', size, pname))
  x <- df.patterns[df.patterns$pattern==pname,]
  pp <- ggplot(x, aes(x=args))+
    geom_bar(aes(fill=scope), position=position_stack(reverse = TRUE))+
    geom_text(stat='count', aes(label=..count..,y=..count..+3))+
    coord_flip()+
    theme(legend.position="top")+
    labs(x=sprintf('%s Pattern Arguments', pname), y = "# Instances")+
    scale_fill_discrete(name="Scope")
  print(pp)
  dev.off()
}
