## Exercise 5.2
# 2. What happens if you flip fct_infreq() and fct_lump() in the code zthat reduces the summary talbes?

## If we dont know what are they, then we code them and execute them

injuries %>%
  mutate(diag = fct_lump(fct_infreq(diag), n = 6)) %>%
  group_by(diag) %>%
  summarise(n = as.integer(sum(weight)))


injuries %>%
  mutate(diag = fct_infreq(fct_lump(diag)),n = 6) %>%
  group_by(diag) %>%
  summarise(n = as.integer(sum(weight)))



injuries %>%
  mutate(diag = fct_infreq(diag)) %>%
  group_by(diag) %>%
  summarise(n = as.integer(sum(weight)))



injuries %>%
  mutate(diag = fct_lump(diag, n = 5)) %>%
  group_by(diag) %>%
  summarise(n = as.integer(sum(weight)))


injuries %>%
  mutate(diag = fct_infreq(fct_lump(diag, n = 5))) %>%
  group_by(diag) %>%
  summarise(n = as.integer(sum(weight)))

injuries %>%
  mutate(diag = fct_lump(fct_infreq(diag), n = 5)) %>%
  group_by(diag) %>%
  summarise(n = as.integer(sum(weight)))
