from flask import Flask, request, jsonify
import pandas as pd
import joblib

# Initialize Flask
app = Flask(__name__)

# Load trained model
model = joblib.load("medicine_model.pkl")

# Load dataset to get disease categories
data = pd.read_csv("medicine_data.csv")
data.columns = data.columns.str.strip()

# Prepare feature columns
disease_categories = sorted(data['disease'].unique())
feature_columns = ['age'] + [f'disease_{d}' for d in disease_categories]

@app.route('/')
def home():
    return "✅ Medicine Recommendation API is running!"

@app.route('/recommend', methods=['POST'])
def recommend():
    input_json = request.get_json()
    
    disease = input_json.get("disease")
    age = int(input_json.get("age", 0))
    
    if not disease or age <= 0:
        return jsonify({"recommended_medicine": "Please provide valid disease and age"}), 400

    # Prepare input dataframe
    input_df = pd.DataFrame(columns=feature_columns)
    input_df.loc[0] = 0
    input_df.at[0, 'age'] = age
    disease_col = f'disease_{disease}'
    if disease_col in input_df.columns:
        input_df.at[0, disease_col] = 1

    # Predict medicine
    prediction = model.predict(input_df)[0]

    return jsonify({"recommended_medicine": prediction})

if __name__ == '__main__':
    app.run(host="0.0.0.0", port=5001, debug=True)
