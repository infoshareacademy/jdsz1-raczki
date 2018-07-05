import numpy as np
import pandas as pd
from sklearn.ensemble import RandomForestRegressor
from sklearn.model_selection import train_test_split

# NOTE: Make sure that the class is labeled 'target' in the data file
tpot_data = pd.read_csv('PATH/TO/DATA/FILE', sep='COLUMN_SEPARATOR', dtype=np.float64)
features = tpot_data.drop('target', axis=1).values
training_features, testing_features, training_target, testing_target = \
            train_test_split(features, tpot_data['target'].values, random_state=42)

# Score on the training set was:-244.75465623238028
exported_pipeline = RandomForestRegressor(bootstrap=False, criterion="mae", max_features=0.6000000000000001, min_samples_leaf=3, min_samples_split=8, n_estimators=10)

exported_pipeline.fit(training_features, training_target)
results = exported_pipeline.predict(testing_features)
