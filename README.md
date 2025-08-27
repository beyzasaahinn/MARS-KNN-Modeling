Bu proje, R dilini kullanarak çalışan ayrılma verisi (`attrition`) üzerinde iki farklı makine öğrenmesi modeli (MARS ve KNN) uygulayarak çalışanların şirketten ayrılıp ayrılmayacağını tahmin etmeyi amaçlamaktadır.

# Bu projeyi çalıştırabilmek için R'da aşağıdaki paketlerin kurulu olması gerekmektedir. 
Eğer kurulu değillerse, R konsolunuzda aşağıdaki komutları çalıştırarak yükleyebilirsiniz:
install.packages(c("tidyverse", "caret", "rsample", "earth", "vip", "recipes", "yardstick", "modeldata"))

## Kütüphaneleri çağırmak için
library(tidyverse)
library(caret)
library(rsample)
library(earth)
library(vip)
library(recipes)
library(yardstick)
library(modeldata)

Bu proje, sınıflandırma görevleri için farklı algoritmaların nasıl uygulanacağını ve performanslarının nasıl karşılaştırılacağını göstermektedir.
