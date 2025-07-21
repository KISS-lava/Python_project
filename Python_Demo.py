import matplotlib.pyplot as plt
import seaborn as sns
import pandas as pd
from sklearn import datasets

iris = datasets.load_iris()

df_iris = pd.DataFrame(iris.data, columns=iris.feature_names)
df_iris['target'] = pd.Series(iris.target)

df_iris['target'] = df_iris['target'].map({0: iris.target_names[0], 1: iris.target_names[1], 2: iris.target_names[2]})

sns.pairplot(df_iris, hue="target", palette="husl", vars=iris.feature_names, diag_kind="kde")

# plt.show()
SAS.pyplot(plt)