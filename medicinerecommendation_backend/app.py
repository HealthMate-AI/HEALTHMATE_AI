from flask import Flask, request, jsonify
import joblib
import difflib

# Paths
MODEL_PATH = "medicine_model.joblib"
LE_PATH = "label_encoders.joblib"

# Load model and encoders
try:
    clf = joblib.load(MODEL_PATH)
    encoders = joblib.load(LE_PATH)
    le_disease = encoders["le_disease"]
    le_med = encoders["le_med"]
except FileNotFoundError:
    print("Error: Model or encoder files not found.")
    exit(1)

app = Flask(__name__)

@app.route("/recommend", methods=["POST"])
def recommend():
    try:
        data = request.get_json()
        disease_input = data.get("disease", "").strip().lower()  # Case-insensitive input
        age = data.get("age", 0)

        if not disease_input or not isinstance(age, (int, float)) or age <= 0:
            return jsonify({"error": "Invalid input: Disease name and valid age required."}), 400

        # Case-insensitive disease matching
        all_diseases = [d.lower() for d in le_disease.classes_]
        best_match = difflib.get_close_matches(disease_input, all_diseases, n=1, cutoff=0.6)

        if not best_match:
            return jsonify({"note": "No disease found matching your input."}), 200

        # Get the original case of the matched disease
        corrected_disease_lower = best_match[0]
        corrected_disease = le_disease.classes_[[d.lower() for d in le_disease.classes_].index(corrected_disease_lower)]

        # Encode disease
        disease_code = le_disease.transform([corrected_disease])[0]

        # Build feature vector
        X_input = [[disease_code, age]]

        # Predict medicine
        pred_code = clf.predict(X_input)[0]
        medicine = le_med.inverse_transform([pred_code])[0]

        return jsonify({
            "recommended_medicine": medicine,
            "corrected_disease": corrected_disease
        }), 200

    except Exception as e:
        return jsonify({"error": f"Server error: {str(e)}"}), 500

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5001, debug=True)