import pandas as pd
import joblib

# Load CSV
data = pd.read_csv("medicine_data.csv", quotechar='"')
data.columns = data.columns.str.strip()

# Ensure correct datatypes
data["min_age"] = pd.to_numeric(data["min_age"], errors="coerce")
data["max_age"] = pd.to_numeric(data["max_age"], errors="coerce")
data = data.dropna(subset=["min_age", "max_age", "disease", "medicine"])

# Convert to int
data["min_age"] = data["min_age"].astype(int)
data["max_age"] = data["max_age"].astype(int)

# Save lookup data as pickle
joblib.dump(data, "medicine_lookup.pkl")

print("✅ Medicine lookup table saved as medicine_lookup.pkl")
