MODEL_ID="gemini-pro"
PROJECT_ID=dashboard-410409

curl \
  -X POST \
  -H "Authorization: Bearer $(gcloud auth print-access-token)" \
  -H "Content-Type: application/json" \
  https://us-central1-aiplatform.googleapis.com/v1/projects/${PROJECT_ID}/locations/us-central1/publishers/google/models/${MODEL_ID}:predict -d \
  $'{
  "instances": [
    { "prompt": "Propose e-mail to some example person - use any English name. My name is Dom. Content about new species of animal discovered in some remote location. Skip subject. Just provide plain text content."}
  ],
  "parameters": {
    "temperature": 0.2,
    "maxOutputTokens": 1024,
    "topK": 40,
    "topP": 0.8
  }
}'
