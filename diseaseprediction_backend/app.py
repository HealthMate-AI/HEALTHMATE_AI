from flask import Flask, request, jsonify
import pandas as pd
import joblib

# --------------------------
# 1️⃣ Initialize Flask app
# --------------------------
app = Flask(__name__)

# --------------------------
# 2️⃣ Load trained model + columns + classes
# --------------------------
model = joblib.load("disease_prediction_model.pkl")
symptom_columns = joblib.load("symptom_columns.pkl")
disease_classes = joblib.load("disease_classes.pkl")

# --------------------------
# 3️⃣ Home endpoint
# --------------------------
@app.route('/')
def home():
    return "✅ Disease Prediction API is running!"

# --------------------------
# 4️⃣ Prediction endpoint (Top-1 disease only)
# --------------------------
@app.route('/predict', methods=['POST'])
def predict():
    input_json = request.get_json()
    if not input_json:
        return jsonify({"error": "No input provided"}), 400

    # Convert input JSON to DataFrame
    input_df = pd.DataFrame([input_json])

    # Keep only known symptoms & add missing ones as 0
    input_df = input_df[[col for col in input_df.columns if col in symptom_columns]]
    input_df = input_df.reindex(columns=symptom_columns, fill_value=0)

    # Ensure numeric type
    input_df = input_df.astype(int)

    # Predict
    predicted_index = model.predict(input_df)[0]  # Only the predicted class
    predicted_disease = str(predicted_index)

    return jsonify({"disease": predicted_disease})

# --------------------------
# 5️⃣ Run the app
# --------------------------
if __name__ == '__main__':
    app.run(host="0.0.0.0", port=5000, debug=True)
