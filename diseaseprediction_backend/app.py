from flask import Flask, request, jsonify
import pandas as pd
import joblib

# 1. Initialize Flask app
app = Flask(__name__)

# 2. Load trained model
model = joblib.load("disease_model.pkl")

# 3. Load dataset columns (symptom columns)
data = pd.read_csv("dataset.csv")
symptom_columns = list(data.columns)
symptom_columns.remove("diseases")  # all other columns are symptoms

@app.route('/')
def home():
    return "✅ Disease Prediction API is running!"

@app.route('/predict', methods=['POST'])
def predict():
    input_json = request.get_json()

    # 1. Convert input JSON to DataFrame with proper columns
    input_df = pd.DataFrame.from_records([input_json], columns=symptom_columns)
    
    # 2. Fill missing symptom columns with 0
    input_df = input_df.fillna(0)

    # 3. Ensure correct column order
    input_df = input_df[symptom_columns]

    # 4. Predict disease
    prediction = model.predict(input_df)[0]

    return jsonify({"predicted_disease": prediction})

if __name__ == '__main__':
    app.run(host="0.0.0.0", port=5000, debug=True)
