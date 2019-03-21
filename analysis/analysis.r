
library(tidyr)
library(ggplot2)
library(plyr)

groups <- list(
  'Guarded' = c('PatternMatching', 'TypeTag', 'Equals', 'GetByClassLiteral', 'StackSymbol'),
  'Creational' = c('Family', 'Factory', 'Tag', 'Deserialization', 'CreateByClassLiteral', 'Composite', 'NewDynamicInstance', 'LookupById', 'StaticResource'),
  'Code Smell' = c('Redundant', 'VariableLessSpecificType', 'UseRawType', 'Literal', 'KnownReturnType', 'ObjectAsArray', 'AccessPrivateField', 'Clone'),
  'Resolution' = c('SelectOverload', 'ReflectiveAccessibility', 'CovariantReturn', 'CovariantGeneric'),
  'Hierarchical' = c('SoleSubclassImplementation', 'RecursiveGeneric', 'ImplicitIntersectionType'),
  'Unchecked' = c('RemoveWildcard', 'GenericArray', 'UnoccupiedTypeParameter')
)

size <- 5000

df.raw <- read.csv(sprintf('casts-%s.csv', size))
stopifnot(ncol(df.raw) == 7)
df.raw$s <- NULL
df.raw$t <- NULL
df.raw$tag <- NULL

df.brokenlinks <- df.raw[df.raw$value == '?BrokenLink', ]
df.likelybugs <- df.raw[df.raw$value == '?LikelyBug', ]

df.empty <- df.raw[df.raw$value == '', ]
stopifnot(nrow(df.empty)==0)

df.numeral <- df.raw[df.raw$value == '#', ]

df <- df.raw
df <- df[df$value != '#', ]
df <- df[df$value != '?BrokenLink', ]
df <- df[df$value != '?LikelyBug', ]
df$key <- ''

df.malformed1 <- df[grep("#",df$value,invert=TRUE),]
stopifnot(nrow(df.malformed1)==0)
df.malformed2 <- df[grep(",",df$value,invert=TRUE),]
stopifnot(nrow(df.malformed2)==0)
df.malformed3 <- df[grep("@",df$value,invert=TRUE),]
stopifnot(nrow(df.malformed3)==0)
df.malformed4 <- df[grep(",.*,",df$value),]
stopifnot(nrow(df.malformed4)==0)

df.malformed <- df[grep("#\\w+(:\\w(\\w|-)*)?,@(src|test|gen)",df$value,invert=TRUE),]
stopifnot(nrow(df.malformed)==0)

df.long <- df
df.long <- separate_rows(df.long, value, sep=',')
df.long <- separate_rows(df.long, value, sep=':')
df.long[grep("#", df.long$value),]$key <- 'pattern'
df.long[grep("@", df.long$value),]$key <- 'scope'
df.long[df.long$key == '',]$key <- 'args'

df.patterns <- spread(df.long, key=key, value=value)
df.patterns$pattern <- substring(df.patterns$pattern, 2)
df.patterns.prim <- df.patterns[df.patterns$pattern == 'Prim', ]
df.patterns <- df.patterns[df.patterns$pattern != 'Prim', ]
df.patterns$pattern <- as.factor(df.patterns$pattern)

df.patterns$scope <- substring(df.patterns$scope, 2)
df.patterns$scope <- factor(df.patterns$scope, levels=c('src', 'test', 'gen'))
stopifnot( nrow(df.patterns[is.na(df.patterns$scope),]) == 0 )
df.patterns$scope <- revalue(df.patterns$scope, c('src'='Sources', 'test'='Test', 'gen'='Generated'))

tb <- table(df.patterns$pattern)
df.patterns$pattern <- factor(df.patterns$pattern, levels=names(tb[order(tb, decreasing = FALSE)]))
df.patterns$group <- ''
for (group in names(groups)) {
  df.patterns[df.patterns$pattern %in% groups[[group]],]$group <- group
}
df.patterns$group <- factor(df.patterns$group, levels=names(groups))

x <- setdiff( unlist(groups, use.names=FALSE) , levels(df.patterns$pattern) )
stopifnot( length(x) == 0 )

x <- setdiff( levels(df.patterns$pattern), unlist(groups, use.names=FALSE) )
stopifnot( length(x) == 0 )

stopifnot(
  nrow(df.raw) == nrow(df.patterns)+nrow(df.patterns.prim)+nrow(df.numeral)+nrow(df.brokenlinks)+nrow(df.likelybugs)
)

cat("[Remaining cast instances to manually analyze: ", nrow(df.numeral), "]", sep='', fill=TRUE)

cat("[Writing table-patterns-", size, ".pdf]", sep='', fill=TRUE)

pdf(
  sprintf('table-patterns-%s.pdf', size),
  height=0.29*length(unlist(groups, use.names=FALSE)) )
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

cat("[Patterns by Group ... ]", sep='', fill=TRUE)
gname <- 'Creational'
for (gname in levels(df.patterns$group)) {
  path = sprintf('table-patterns-%s-by-group-%s.pdf', size, gsub('\n', ' ', gname))
  cat("[Writing '", path, "']", sep='', fill=TRUE)
  pdf(path, height = 1+0.5*length(groups[[gname]]) )
  p <- ggplot(df.patterns[df.patterns$group==gname,], aes(x=pattern))+
    geom_bar(aes(fill=scope), position=position_stack(reverse = TRUE))+
    geom_text(stat='count', aes(label=..count..,y=..count..+3))+
    facet_grid(group~., scales="free", space="free")+
    coord_flip()+
    theme(strip.text.y=element_text(angle = 0), legend.position="top")+
    labs(x="Cast Usage Patterns", y = "# Instances")+
    scale_fill_discrete(name="Scope")
  print(p)
  dev.off()
}

lpatterns <- levels(as.factor(df.patterns$pattern))
lgroups <- levels(as.factor(df.patterns$group))
values <- c(
  sprintf("\\newcommand{\\npattern}{%s}", format(length(lpatterns), big.mark=',')),
  sprintf("\\newcommand{\\ngroup}{%s}", format(length(lgroups), big.mark=',')),
  sprintf("\\newcommand{\\nprim}{%s}", format(nrow(df.patterns.prim), big.mark=',')),
  sprintf("\\newcommand{\\nbrokenlinks}{%s}", format(nrow(df.brokenlinks), big.mark=',')),
  sprintf("\\newcommand{\\nlikelybugs}{%s}", format(nrow(df.likelybugs), big.mark=','))
)
write(values, 'casts.def')


cat("[Pattern Arguments ... ]", sep='', fill=TRUE)
pname <- 'PatternMatching'
for (pname in levels(df.patterns$pattern)) {
  path = sprintf('patterns/table-pattern-%s-%s.pdf', size, pname)
  cat("[Writing '", path, "']", sep='', fill=TRUE)
  pdf(path)
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
