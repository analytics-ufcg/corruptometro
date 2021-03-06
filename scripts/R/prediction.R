# Excutar script data.R
source("imports.R")
source("data.R")

# Importar conjunto de dados "tre_sagres_unificado.csv"
# tre_sagres = read.csv("../../data/tre_sagres_unificado.csv",header=T, encoding = "UTF-8")

# Apresentar os poss�veis n�veis de Classe
table(tre_sagres$Classe)

# Parti��o de treino com x% dos dados
#train_idx = caret::createDataPartition(y=tre_sagres$Classe, p=.9, list=FALSE)
test_idx = which(tre_sagres$Candidato2016)

# Conjunto de treino e teste
test = tre_sagres[test_idx,]
train = tre_sagres[-test_idx,]

# features do conjunto de treino
#features.names = c("nu_Dispensas", "nu_Aditivo_Prazo", "nu_Aditivo_Devolucao", "nu_Aditivo_Valor", "nu_Aditivos_Totais", "nu_Contrato")
train.features = select(train, nu_Dispensas, nu_Aditivo_Prazo, nu_Aditivo_Devolucao, nu_Aditivo_Valor, nu_Aditivos_Totais, nu_Contrato)
test.features = select(test, nu_Dispensas, nu_Aditivo_Prazo, nu_Aditivo_Devolucao, nu_Aditivo_Valor, nu_Aditivos_Totais, nu_Contrato)

# Propor��o dos conjuntos de treino e teste
prop.table(table(train$Classe))
prop.table(table(test$Classe))

#Treino do modelo
#grid = expand.grid(.ntree=c(10,20,30,40,50,100,200),.mtry=2,.model="tree")

fitControl = trainControl(method="repeatedcv", number=10, repeats=10, returnResamp="all")
labels = as.factor(train$Classe)
model = train(x=train.features, y=labels, trControl=fitControl, method="rf")

#
test_labels = as.factor(test$Classe)
predictions = predict(model,newdata=test.features)
prob = predict(model,newdata=test.features,type = "prob")
caret::confusionMatrix(predictions, test_labels)