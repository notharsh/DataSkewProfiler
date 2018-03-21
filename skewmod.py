import pandas as pd
from sklearn.ensemble import RandomForestRegressor
from sklearn.metrics import mean_absolute_error
from sklearn.model_selection import train_test_split
main_file_path = '../input/train.csv'
data = pd.read_csv(main_file_path)
y=data.skew
df=['NumofNodes','NumofQueries','NumJoinQueries','SizeOfDataset']
X=data[df]
trainX,valX,trainY,valY=train_test_split(X,y,random_state=0)
forestmod=RandomForestRegressor()
forestmod.fit(trainX,trainY)
test = pd.read_csv('../input/test.csv')
testX=test[df]
predprices=forestmod.predict(testX)
print(mean_absolute_error(predprices,skew))