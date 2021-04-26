state_party_Congress <- CCES_2018 %>% 
  select(state, pid3, region, appCongress, appTrump) %>% 
  filter(!is.na(state)) %>% 
  filter(!is.na(pid3)) %>% 
  mutate(
    region = case_when(
      region == 1 ~ "Northeast",
      region == 2 ~ "Midwest",
      region == 3 ~ "South",
      region == 4 ~ "West"
    )
  ) %>% 
  group_by(state, region, pid3) %>% 
  summarise(
    mean        = mean(appCongress, na.rm = TRUE),
    pctCongAppv = sum(appCongress == 1, na.rm = TRUE)/length(appCongress),
    pctCongDApv = sum(appCongress == 2, na.rm = TRUE)/length(appCongress),
    pctPresAppv = sum(appTrump == 1, na.rm = TRUE)/length(appTrump),
    pctPresDApv = sum(appTrump == 2, na.rm = TRUE)/length(appTrump),
    .groups     = 'keep'
  ) 