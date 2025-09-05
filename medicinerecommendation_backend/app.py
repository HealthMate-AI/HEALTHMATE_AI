from flask import Flask, request, jsonify
import joblib

app = Flask(__name__)

# Load lookup table
data = joblib.load("medicine_lookup.pkl")

@app.route("/recommend", methods=["POST"])
def recommend():
    try:
        content = request.get_json()
        disease = content.get("disease", "").strip().lower()
        age = int(content.get("age", 0))

        if not disease or age <= 0:
            return jsonify({"error": "Invalid input"}), 400

        # Filter dataset
        match = data[
            (data["disease"].str.lower() == disease)
            & (data["min_age"] <= age)
            & (data["max_age"] >= age)
        ]

        if match.empty:
            return jsonify({"recommended_medicine": "No match found"}), 200

        medicines = match["medicine"].unique().tolist()
        return jsonify({"recommended_medicine": medicines}), 200

    except Exception as e:
        return jsonify({"error": str(e)}), 500


if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5001, debug=True)
