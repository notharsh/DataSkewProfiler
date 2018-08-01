import pandas as pd
from sklearn.ensemble import RandomForestRegressor
from sklearn.metrics import mean_absolute_error
from sklearn.model_selection import train_test_split
main_file_path = 'dataset.csv'
data = pd.read_csv(main_file_path)
y=data.SKEW
df=['IW','LJ','J','PDRS','FDR','HD','S']
X=data[df]
forestmod=RandomForestRegressor(oob_score = True, n_jobs = -1,random_state =50,max_features = "auto",verbose = True)
forestmod.fit(X,y)
print("\n\n")
print("\nPredicted skew factor is : ")
X=forestmod.predict([[0,0,1,0,2,2,0]])
print(X)
print("\n\n")
print("Feature Importance within the forest")
print(forestmod.feature_importances_)