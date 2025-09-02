import pandas as pd
from sklearn.model_selection import train_test_split
from sklearn.naive_bayes import MultinomialNB
from sklearn.metrics import accuracy_score
import joblib

# 1. Load dataset
data = pd.read_csv("dataset.csv")

print("Before cleaning:", data.shape)

# 2. Clean dataset
data = data.dropna().drop_duplicates()
print("After cleaning:", data.shape)

# 3. Features = all symptom columns, Target = 'diseases'
X = data.drop("diseases", axis=1)
y = data["diseases"]

# 4. Train/test split
X_train, X_test, y_train, y_test = train_test_split(
    X, y, test_size=0.2, random_state=42
)

# 5. Train Naive Bayes model
model = MultinomialNB()
model.fit(X_train, y_train)

# 6. Evaluate accuracy
y_pred = model.predict(X_test)
print("Accuracy:", accuracy_score(y_test, y_pred))

# 7. Save model
joblib.dump(model, "disease_model.pkl")
print("✅ Model trained and saved!")
