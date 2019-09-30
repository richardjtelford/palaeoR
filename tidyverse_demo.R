library("tidyverse")
iris <- iris %>% as_tibble()
iris

## filter - pick rows

iris %>% filter(Sepal.Length < 5, Petal.Width > 1)
iris[iris$Sepal.Length < 5 & iris$Petal.Width > 1, ]

## select - pick columns
iris %>% select(Species, Sepal.Width)
iris[, c("Species", "Sepal.Width")]

iris %>% select(-Species)
iris %>% select(-Species)
iris %>% select(Sepal.Length:Petal.Width)

#mutate - change a column
iris %>% mutate(petal_area = Petal.Length * Petal.Width)
iris %>% mutate(Species = toupper(Species))

# count how many
iris %>% count(Species)

# group_by
iris %>% group_by(Species)

#summarise
iris %>% group_by(Species) %>% 
  summarise(min_Sepal_length = min(Sepal.Length), mean_sepal_length = mean(Sepal.Length))

iris %>% group_by(Species) %>% 
  mutate(mean_sepal_length = mean(Sepal.Length))

# arrange
iris %>% arrange(Sepal.Length)
iris %>% arrange(desc(Sepal.Length))

# slice 
iris %>% slice(1:3)

iris %>% group_by(Species) %>% 
  slice(1:3)

iris %>% group_by(Species) %>% 
  slice(which.max(Sepal.Length))

# joins
colours <- tribble(~species, ~colour, 
                   "setosa", "red",
                   "versicolor", "blue",
                   "virginica", "yellow", 
                   "newspecies", "pink")

left_join(iris, colours, by = c("Species" = "species"))
left_join(iris, colours, by = "Species")

#bind_rows
bind_rows(iris, iris)

#tidyr

thin_iris <- iris %>% mutate(id = row_number()) %>% 
  pivot_longer(-(Species:id), names_to = "attribute", values_to = "measurements")

thin_iris %>% 
  pivot_wider(names_from = "attribute", values_from = "measurements")

## nesting
iris %>% group_by(Species) %>% 
  nest() %>% 
  mutate(mod = map(data, ~lm(Sepal.Length ~Sepal.Width, data = .)), 
        coef = map(mod, broom::tidy)) %>% 
  unnest(coef)
coef
