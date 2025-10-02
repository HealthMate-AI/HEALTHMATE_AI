import pandas as pd
import numpy as np
from sklearn.preprocessing import LabelEncoder
from sklearn.ensemble import RandomForestClassifier
from sklearn.model_selection import train_test_split, StratifiedKFold, cross_val_score
from sklearn.metrics import accuracy_score, classification_report
import joblib

CSV_PATH = "medicine_data.csv"
MODEL_PATH = "medicine_model.joblib"
LE_PATH = "label_encoders.joblib"

def load_and_prepare(path):
    try:
        df = pd.read_csv(path)
        df = df.dropna(subset=["disease", "min_age", "max_age", "medicine"])
        df["min_age"] = pd.to_numeric(df["min_age"], errors="coerce")
        df["max_age"] = pd.to_numeric(df["max_age"], errors="coerce")
        df = df.dropna(subset=["min_age", "max_age"])
        df["age_mid"] = (df["min_age"] + df["max_age"]) / 2.0
        return df
    except FileNotFoundError:
        print(f"Error: CSV file {path} not found.")
        return pd.DataFrame()
    except Exception as e:
        print(f"Error loading CSV: {e}")
        return pd.DataFrame()

def train_and_save(df):
    if df.empty:
        print("Error: Empty dataset. Cannot train model.")
        return

    le_disease = LabelEncoder()
    le_med = LabelEncoder()

    X_disease = le_disease.fit_transform(df["disease"])
    y_med = le_med.fit_transform(df["medicine"])

    X = pd.DataFrame({
        "disease_code": X_disease,
        "age_mid": df["age_mid"].values
    })

    # Check class distribution
    counts = pd.Series(y_med).value_counts()
    too_small = (counts < 2).sum()

    if too_small == 0 and len(df) >= 10:
        # Perform train/test split with stratification
        X_train, X_test, y_train, y_test = train_test_split(
            X, y_med, test_size=0.2, stratify=y_med, random_state=42
        )

        clf = RandomForestClassifier(n_estimators=200, random_state=42, n_jobs=-1)
        clf.fit(X_train, y_train)

        y_pred = clf.predict(X_test)
        print("Test accuracy:", accuracy_score(y_test, y_pred))
        print("Classification report:\n",
              classification_report(y_test, y_pred, target_names=le_med.classes_))

        cv = StratifiedKFold(n_splits=5, shuffle=True, random_state=42)
        cv_scores = cross_val_score(clf, X, y_med, cv=cv, scoring="accuracy", n_jobs=-1)
        print("5-fold CV accuracy: mean={:.3f} std={:.3f}".format(cv_scores.mean(), cv_scores.std()))
    else:
        # Train on all data if dataset is too small
        print("Warning: Small dataset or imbalanced classes. Training on all data.")
        clf = RandomForestClassifier(n_estimators=200, random_state=42, n_jobs=-1)
        clf.fit(X, y_med)

    # Save model and encoders
    try:
        joblib.dump(clf, MODEL_PATH)
        joblib.dump({"le_disease": le_disease, "le_med": le_med}, LE_PATH)
        print(f"Saved model to {MODEL_PATH} and encoders to {LE_PATH}")
    except Exception as e:
        print(f"Error saving model or encoders: {e}")

if __name__ == "__main__":
    df = load_and_prepare(CSV_PATH)
    if not df.empty:
        train_and_save(df)
    else:
        print("Exiting: No valid data to train model.")