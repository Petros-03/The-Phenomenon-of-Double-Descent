#Εργασία Μηχανικής Μάθησης


#βιβλιοθήκες
library(MASS)
library(ggplot2)


##προσομοιωμενα δεδομενα

#δημιουργια δεδομένων
set.seed(42) #για αναπαραγωγιμοτητα
training_sample<-200 #δεδομενα για εκπαιδευση του μοντελου
testing_sample<-500 #δεδομενα για έλεγχο του μοντελου
parameters<-500  #Μεγιστος αριθμος παραμετρων 

#δημιουργια y=x+θορυβος
x1<-rnorm(training_sample)
y1<-x1+0.5*rnorm(training_sample)

x2<-rnorm(testing_sample)
y2<-x2+0.5*rnorm(testing_sample)

#δημιουργια παραμετρων νευρωνων
W<-matrix(rnorm(parameters),nrow = 1) #τα weights των x
b<-runif(parameters,0,2*pi) #μετατοπιση για καθε x

#συναρτηση δημιουργιας νευρωνων
neuron_creator<-function(x, d){
  phi<-cos(outer(x,W[1, 1:d])+rep(b[1:d],each=length(x)))
  return(phi)
} #μεσα απο αυτον τον μετασχηματισμο αυτο τα δεδομενα μας x γινονται νευρωνες

#προσομοιωση για διαφορετικα d
d1<-seq(1,parameters,by=10)
results<-data.frame(d=numeric(),mse1=numeric(),mse2=numeric())

for (d in d1) {
  #περναμε τα δεδομενα μας απο τον νευρωνικο μετασχηματσμο
  X1<-neuron_creator(x1,d)
  X2<-neuron_creator(x2,d)
  
  #προσθετουμε στηλη για τον σταθερο ορο
  X1<-cbind(1,X1)
  X2<-cbind(1,X2)
  
  #λυνουμε το συστημα χρησιμοποιώντας ψευδοαντστροφο 
  beta<-ginv(t(X1)%*%X1)%*%t(X1)%*%y1
  
  #προβλέψεις
  prediction1<-X1%*%beta
  prediction2<-X2%*%beta
  
  #υπολογισμος MSE
  mse1<-mean((y1-prediction1)^2)
  mse2<-mean((y2-prediction2)^2)
  
  results<-rbind(results,data.frame(d=d,mse1=mse1,mse2=mse2))
}

#plot οπτικοποιησης του φαινομενου του double descent
ggplot(results,aes(x=d)) +
  geom_line(aes(y=mse1,color="Σφάλμα Εκπαίδευσης"), size = 1) +
  geom_line(aes(y=mse2,color="Σφάλμα Ελέγχου"), size = 1) +
  geom_vline(xintercept=training_sample,linetype="dashed",color="black") +
  annotate("text",x=training_sample+40,y=max(results$mse2),label="Όριο Παρεμβολής (d=200)") +
  scale_y_log10() +
  labs(title="",
       x="Αριθμός Νευρώνων (d)",
       y="Μέσο Τετραγωνικό Σφάλμα (log scale)",
       color="") +
  theme_minimal()



##πραγματικα δεδομένα

data<-read.csv("Heart_Disease_Prediction.csv")

#μετατροπη της κατηγορικης εξαρτημενης μεταβλητης σε αριθμητικη
data$Heart.Disease<-ifelse(data$Heart.Disease=="Presence", 1, 0)


#κανονκοποιούμε τις στηλες των ανεξαρτητων μεταβλητων
X<-scale(as.matrix(data[,1:13]))
Y<-data$Heart.Disease

#training και testing δεγματα
set.seed(42)
training_sample_size<-150  #δειγμα μεγεθους 150
training_sample<-sample(1:nrow(X),training_sample_size) #παιρνουμε το δειγμα

x3<-X[training_sample,] #απο τα x κα y κραταμε εκεινα που αντιστοιχουν στα δειγματα που διαλεξαμε
y3<-Y[training_sample]

x4<-X[-training_sample,] #εδω κραταμε αυτα που δεν αντιστοιχουν δηλαδη που περρισευουν
y4<-Y[-training_sample]

#ρυθμισεις μοντελου
n_features_input<-ncol(x3) #13 χαρακτηριστικα
d_max<-400 #μεγιστος αριθμος νευρωνων

#δημιουργια παραμετρων νευρωνων σε μορφή πνακων λογω πολυδιαστατων δεδομενων
W<-matrix(rnorm(n_features_input*d_max),nrow=n_features_input,ncol=d_max)
b<-runif(d_max,0,2*pi)

#συναρτηση δημιουργιας νευρωνων για πολυδιαστατα δεδομενα
neuron_creator<-function(x,d) {
  projection<-x %*% W[,1:d] 
  phi<-cos(projection+rep(b[1:d],each=nrow(x)))
  return(phi)
}

#προσομοιωση για διαφορετκά d
d2<-seq(2,d_max,by=10)
results<-data.frame(d=numeric(),mse3=numeric(),mse4=numeric())

for (d in d2) {
  #περναμε τα δεδομενα απο τον νευρωνικο μετασχηματσμο
  X3<-neuron_creator(x3,d)
  X4<-neuron_creator(x4,d)
  
  #προσθετουμε στηλη για τον σταθερο ορο
  X3<-cbind(1,X3)
  X4<-cbind(1,X4)
  
  #λυνουμε το συστημα χρησιμοποιωντας ψευδοαντστροφο
  beta<-ginv(t(X3)%*%X3)%*%t(X3)%*%y3
  
  #προβλεψεις
  prediction3<-X3%*%beta
  prediction4<-X4%*%beta
  
  # Προβλέψεις και υπολογισμός MSE
  mse3<-mean((y3-prediction3)^2)
  mse4<-mean((y4-prediction4)^2)
  
  results<-rbind(results,data.frame(d=d,mse3=mse3,mse4=mse4))
}

#plot οπτικοποιησης του φαινομενου του double descent
ggplot(results, aes(x=d)) +
  geom_line(aes(y=mse3,color="Σφάλμα Εκπαίδευσης"),size=1) +
  geom_line(aes(y=mse4,color="Σφάλμα Ελέγχου"),size=1) +
  geom_vline(xintercept=training_sample_size,linetype="dashed") +
  scale_y_log10() +
  labs(title="",
       x="Αριθμός Νευρώνων (d)",
       y="Μέσο Τετραγωνικό Σφάλμα (log scale)",
       color="") +
  annotate("text",x=training_sample_size+45,y=max(results$mse4), 
           label=paste("Όριο Παρεμβολής (d=",training_sample_size,")")) +
  theme_minimal()

