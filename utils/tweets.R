# Installare i pacchetti necessari se non sono già installati
if (!require("tidyverse")) install.packages("tidyverse")
if (!require("tidytext")) install.packages("tidytext")
if (!require("ggplot2")) install.packages("ggplot2")

# Caricare i pacchetti
library(tidyverse)
library(tidytext)
library(ggplot2)

# Leggere il dataset CSV
tweets <- read_csv("ChatGPT_Tweets_Dataset_Full.csv")

# Assicurarsi che il dataset contenga una colonna chiamata "text" con il testo dei tweet
# Se necessario, rinominare le colonne
# colnames(tweets) <- c("screen_name", "text", "created_at")

# Pre-processamento dei tweet
tweets_clean <- tweets %>%
  mutate(text = gsub("http\\S+|www\\S+|t.co\\S+", "", text)) %>%  # Rimuovere i link
  mutate(text = gsub("[^\\x01-\\x7F]", "", text)) %>%  # Rimuovere i caratteri non ASCII
  mutate(text = gsub("[[:punct:]]", "", text)) %>%  # Rimuovere la punteggiatura
  mutate(text = gsub("[[:digit:]]", "", text))  # Rimuovere i numeri

# Tokenizzazione e rimozione delle stop words
data("stop_words")
tweets_tokens <- tweets_clean %>%
  unnest_tokens(word, text) %>%
  anti_join(stop_words)

# Analisi del sentiment utilizzando il dizionario Bing
sentiment_bing <- tweets_tokens %>%
  inner_join(get_sentiments("bing")) %>%
  count(sentiment) %>%
  spread(sentiment, n, fill = 0) %>%
  mutate(sentiment_score = positive - negative)

# Visualizzazione del sentiment
ggplot(sentiment_bing, aes(x = sentiment_score)) +
  geom_histogram(binwidth = 1, fill = "blue", color = "white") +
  labs(title = "Distribuzione del Sentiment dei Tweet Relativi al Turismo",
       x = "Sentiment Score",
       y = "Frequenza")

# Mostrare i primi tweet con sentiment positivo e negativo
tweets_with_sentiment <- tweets_clean %>%
  inner_join(tweets_tokens %>% inner_join(get_sentiments("bing")) %>% count(text, sentiment), by = "text") %>%
  group_by(text) %>%
  summarise(sentiment_score = sum(sentiment == "positive") - sum(sentiment == "negative"))

top_positive <- tweets_with_sentiment %>%
  arrange(desc(sentiment_score)) %>%
  head(10)

top_negative <- tweets_with_sentiment %>%
  arrange(sentiment_score) %>%
  head(10)

print("Top 10 tweet positivi:")
print(top_positive)

print("Top 10 tweet negativi:")
print(top_negative)