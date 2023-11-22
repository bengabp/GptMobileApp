from flask import Flask, jsonify, request
import os
import whisper
import uuid
from gpt3 import GPT3
import numpy as np
import time
import pytesseract


api = Flask(__name__)
model = whisper.load_model("base")
gpt3 = GPT3()

AUDIO_FILES_UPLOAD_DIR = 'audio_files'
IMAGE_FILES_UPLOAD_DIR = 'image_files'

if not os.path.exists(AUDIO_FILES_UPLOAD_DIR):
    os.mkdir(AUDIO_FILES_UPLOAD_DIR)

if not os.path.exists(IMAGE_FILES_UPLOAD_DIR):
    os.mkdir(IMAGE_FILES_UPLOAD_DIR)



@api.route("/testapi", methods=['GET', 'POST'])
def testApi():
    ipAddress = request.remote_addr
    userAgent = request.user_agent.string
    return jsonify({"message": "Api is working fine !", "ipAddress": ipAddress, "userAgent": userAgent})


@api.route("/testTranscribe", methods=["POST"])
def testTranscribe():
    audioFile = request.form.get("audioFile")
    audioFile = audioFile.encode('utf-8')

    return jsonify({"message": "Got audio !"})


@api.route("/transcribe", methods=["POST"])
def transcribeAudio():
    speech_text = "This value is hardcoded !"
    audioFile = request.files.get("audioFile")

    random_filename = uuid.uuid4()

    print("Saving file...")
    audioFile.save(f"{AUDIO_FILES_UPLOAD_DIR}/{random_filename}.wav")
    time.sleep(2)
    print("Saved !")

    print("Transcribing...")
    result = model.transcribe(
        f"{AUDIO_FILES_UPLOAD_DIR}/{random_filename}.wav")
    print("Done")
    speech_text = result["text"]
    os.remove(f"{AUDIO_FILES_UPLOAD_DIR}/{random_filename}.wav")

    return jsonify({"speech_text": speech_text, "message": "Transcribed successfully !"})


@api.route("/chat/text")
def textChat():
    user_message = request.args.get("text")
    bot_reply = gpt3.generate_text(user_message)
    return jsonify({"botReply": bot_reply, "userMessage": user_message})



@api.route("/ocr", methods=["POST"])
def extractTextFromImage():
    image_text = "This value is hardcoded !"
    imageFile = request.files.get("imageFile")

    random_filename = uuid.uuid4()

    print("Saving image file...")
    imageFile.save(f"{IMAGE_FILES_UPLOAD_DIR}/{random_filename}.jpg")
    time.sleep(2)
    print("Image Saved !")

    print("Extracting Text ...")
    image_text = pytesseract.image_to_string(f"{IMAGE_FILES_UPLOAD_DIR}/{random_filename}.jpg")
    os.remove(f"{IMAGE_FILES_UPLOAD_DIR}/{random_filename}.jpg")


    return jsonify({"image_text":image_text, "message": "Text Extracted successfully !"})


api.run(host="0.0.0.0", port=5000)
