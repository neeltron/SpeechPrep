## Inspiration
Have you ever had the need to rehearse before delivering a speech or a presentation? With SpeechPrep, you will be able to practice your deliverables and also get feedback about them!
## What it does
SpeechPrep is a platform-independent AI-based application that allows the user to record their speech and evaluates it on the basis of sentiment, grammatical errors, and the usage of slang words and sensitive content. A report is generated, which lists down the score, transcription, grammatical errors, how it sounds to listeners (sentiment), and warnings for certain cases like sensitive content including hate speech, so that the user can tune the speech perfectly.
## How we built it
Front-end - Flutter/Dart<br>
Back-end - Python-Flask<br>
APIs - AssemblyAI (To get the transcription, perform sentiment analysis, and identify sensitive content), RapidAPI LanguageTool (For Grammar Check)
## Challenges we ran into
Flutter and Flask Connection was difficult and time-consuming.<br>Formatting the response from REST API was confusing because of the complexity of the JSON output.
## Accomplishments that we're proud of
I'm proud of making an MVP-stage application in a short span of time.
## What we learned
I learned about the Audio Intelligence features, developed by AssemblyAI, designing UI in Flutter, and REST API connection with Flutter.
## What's next for SpeechPrep
I will be working on an auto-correction method that will present the user with a text block containing the corrected speech (grammar). Additionally, I will include the features like "Expand Speech" and "Generate Speaker Notes".
