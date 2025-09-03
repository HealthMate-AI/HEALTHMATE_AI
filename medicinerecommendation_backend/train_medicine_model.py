import pandas as pd
from sklearn.model_selection import train_test_split
from sklearn.naive_bayes import MultinomialNB
from sklearn.metrics import accuracy_score
import joblib

# Load dataset
data = pd.read_csv("medicine_data.csv")
data.columns = data.columns.str.strip()

# Create representative age column
data["age"] = ((data["age_min"] + data["age_max"]) // 2).astype(int)

# Features and target
X = data[["disease", "age"]]
y = data["medicine"]

# One-hot encode disease
X = pd.get_dummies(X, columns=["disease"])

# Train/test split
X_train, X_test, y_train, y_test = train_test_split(
    X, y, test_size=0.2, random_state=42
)

# Train Naive Bayes model
model = MultinomialNB()
model.fit(X_train, y_train)

# Evaluate
y_pred = model.predict(X_test)
print("Accuracy:", accuracy_score(y_test, y_pred))

# Save model
joblib.dump(model, "medicine_model.pkl")
print("✅ Medicine model trained and saved successfully!")
