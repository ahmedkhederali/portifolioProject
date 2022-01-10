import numpy as np 
import pandas as pd
import matplotlib.pyplot as plt
from sklearn.impute import SimpleImputer
from sklearn import preprocessing
import seaborn as sns

#---------------------Data Understanding-------------------------

data=pd.read_excel("powerBI.xlsx",header=0,na_values=["-","?","","."])
print(data)
print(data)
print(data.isnull().sum())
print(data.head())
print(data.info())
print(data.shape)
print(data.values)
print(data["Product Category"].value_counts())

#---------------------Data cleaning By Drop some column-------------------------


#data_after_drop_some_column

#how number of unique values
print(data.nunique())

#divide data into two type: 1) object data 2) numerical data

object_data=data.select_dtypes(include=["object"])
numeral_data=data.select_dtypes(exclude=["object"])
print(object_data)
print(numeral_data)

#----------conver object data into numerical data----------------------------
le=preprocessing.LabelEncoder()
for i in range(object_data.shape[1]):
    object_data.iloc[:,i]=le.fit_transform(object_data.iloc[:,i])
    #print(le.classes_)

data_after_convertion_to_numerical=pd.concat([object_data,numeral_data],axis=1)

print(data_after_convertion_to_numerical.info())

#------------------------ datas is my Data now--------------


#------------------Data Visualization-------------------


plt.style.use("seaborn")
# --------------correlation--------------
correlation=data_after_convertion_to_numerical.corr()
sns.heatmap(correlation,annot=True)
sns.pairplot(data_after_convertion_to_numerical)
plt.figure(figsize=(20,20))
x=data_after_convertion_to_numerical.plot(kind="box",vert=True,figsize=(20,20))
x.set_xlabel("datas")
plt.show()
plt.scatter(data_after_convertion_to_numerical["Brand"],data_after_convertion_to_numerical["Sales"],marker="+",c="red",s=60)
plt.show()
#plt.bar(datas["CentralAir"],datas["SalePrice"])
#plt.pie(datas["Neighborhood"],labels=datas["SalePrice"])
#datas.loc[:,"CentralAir"].plot(kind="density")
#plt.show()


#------------------------------------Linear Regression-------------------------------

plt.figure(figsize=(25,10))
x=data_after_convertion_to_numerical["Q"].values
y=data_after_convertion_to_numerical["Sales"].values
mean_x=data_after_convertion_to_numerical["Q"].mean()
mean_y=data_after_convertion_to_numerical["Sales"].mean()
m=len(x)
numer=0
denom=0
for i in range(m):
    numer+=(x[i]-mean_x)*(y[i]-mean_y)
    denom+=(x[i]-mean_x)**2

b1=numer/denom
b0=mean_y-(b1*mean_x)


max_x=np.max(x)
min_x=np.min(x)
X=np.linspace(min_x,max_x,368)
Y=b0+b1*x
plt.title("Linear Regression")
plt.plot(X,Y,color="red",label="Regression line")
plt.scatter(x,y,color="green",label="scatter plot")
plt.legend()
plt.show()
