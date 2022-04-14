from ibm_watson import TextToSpeechV1
from ibm_cloud_sdk_core.authenticators import IAMAuthenticator

authenticator = IAMAuthenticator('your authenticator')
text_to_speech = TextToSpeechV1(
    authenticator=authenticator
)

text_to_speech.set_service_url('your service url')

with open('testing_api.wav', 'wb') as audio_file:
    audio_file.write(
        text_to_speech.synthesize(
            'Good morning',
            voice='en-US_AllisonV3Voice',
            accept='audio/wav'        
        ).get_result().content)
