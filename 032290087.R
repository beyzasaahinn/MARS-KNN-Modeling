# Gerekli paketleri yükleyelim
library(tidyverse)
library(caret)
library(rsample)
library(earth)         # MARS modeli için gerekli
library(vip)           # Değişken önem dereceleri için
library(recipes)       # Ön işleme adımları için
library(yardstick)     # ROC ve diğer metrikler için
library(modeldata)



# VERİ HAZIRLAMA

# Veriyi yükleyelim
data(attrition)
df <- attrition

# Hedef değişkenin dağılımına bakalım
table(df$Attrition)

# Görsel olarak da bakalım
ggplot(df, aes(x = Attrition)) +
  geom_bar(fill = "#69b3a2") +
  ggtitle("Attrition Değişkeninin Dağılımı") +
  theme_minimal()

# Veriyi eğitim ve test olarak ayıralım (strata ile)
set.seed(123) 
split <- initial_split(df, prop = 0.7, strata = "Attrition")
churn_train <- training(split)
churn_test  <- testing(split)



# MARS MODELİ

# Önce trainControl ayarlarımızı yapalım
ctrl <- trainControl(method = "cv", number = 10, classProbs = TRUE, summaryFunction = twoClassSummary)

# Küçük bir hiperparametre grid'i oluşturalım
hyper_grid_mars <- expand.grid(
  degree = 1:2,
  nprune = c(2, 5, 10, 15)
)

# Şimdi MARS modelini eğitelim
set.seed(123)
mars_model <- train(
  Attrition ~ .,
  data = churn_train,
  method = "earth",
  metric = "ROC",
  tuneGrid = hyper_grid_mars,
  trControl = ctrl
)

# En iyi hiperparametreleri görelim
mars_model$bestTune

# Performansı görselleştirelim
ggplot(mars_model)

# Test setinde tahmin yapalım
mars_preds <- predict(mars_model, newdata = churn_test)

# Doğruluk matrisini hesaplayalım
confusionMatrix(mars_preds, churn_test$Attrition)

# En önemli değişkenleri görelim
vip(mars_model)





# KNN MODELİ 
# Şimdi bir recipe tanımlayalım (ön işleme planı)
recipe_knn <- recipe(Attrition ~ ., data = churn_train) %>%
  step_nzv(all_predictors()) %>%
  step_dummy(all_nominal_predictors()) %>%
  step_center(all_numeric_predictors()) %>%
  step_scale(all_numeric_predictors())

# k için grid oluşturalım
hyper_grid_knn <- expand.grid(k = c(3, 5, 7, 9, 11))

# Modeli eğitelim
set.seed(123)
knn_model <- train(
  recipe_knn,
  data = churn_train,
  method = "knn",
  metric = "ROC",
  tuneGrid = hyper_grid_knn,
  trControl = ctrl
)

# En iyi k'yı görelim
knn_model$bestTune

# Performansı çizelim
ggplot(knn_model)

# Test setinde tahmin yapalım
knn_preds <- predict(knn_model, newdata = churn_test)

# Doğruluk matrisini inceleyelim
confusionMatrix(knn_preds, churn_test$Attrition)



mars_cm <- confusionMatrix(mars_preds, churn_test$Attrition)
knn_cm  <- confusionMatrix(knn_preds, churn_test$Attrition)

mars_cm$overall["Accuracy"]
knn_cm$overall["Accuracy"]

mars_cm
knn_cm
