import pandas as pd
from sklearn.model_selection import train_test_split
from sklearn.naive_bayes import GaussianNB
from sklearn.metrics import accuracy_score
import joblib
import matplotlib.pyplot as plt

# --------------------------
# 1️⃣ Load dataset
# --------------------------
data = pd.read_csv("dataset.csv")

# Keep only diseases with ≥2 occurrences
counts = data["diseases"].value_counts()
data = data[data["diseases"].isin(counts[counts >= 2].index)]

print(f"Filtered dataset: {data.shape[0]} rows, {len(data.columns)-1} symptoms")
print(f"Unique diseases after filtering: {data['diseases'].nunique()}")

# Separate features and labels
X = data.drop(columns=["diseases"])
y = data["diseases"]

# --------------------------
# 2️⃣ Train-test split
# --------------------------
X_train, X_test, y_train, y_test = train_test_split(
    X, y, test_size=0.2, random_state=42, stratify=y
)

# --------------------------
# 3️⃣ Train GaussianNB model
# --------------------------
model = GaussianNB()
model.fit(X_train, y_train)

# Evaluate on test set
y_pred = model.predict(X_test)
print("✅ Full model accuracy:", accuracy_score(y_test, y_pred))

# --------------------------
# 4️⃣ Save model, columns, classes
# --------------------------
joblib.dump(model, "disease_prediction_model.pkl")
joblib.dump(X.columns.tolist(), "symptom_columns.pkl")
joblib.dump(model.classes_, "disease_classes.pkl")
print("✅ Model, symptom columns, and disease classes saved")