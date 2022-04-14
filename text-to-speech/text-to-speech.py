import gtts
import os
import pyttsx3
from playsound import playsound
from pydub import AudioSegment


def create_rel_path(dirName):
    # Create target directory & all intermediate directories if don't exists
    if not os.path.exists(dirName):
        os.makedirs(dirName)
        # commented out the rest to de-clutter output messages
        # print("Directory " , dirName ,  " Created ")
    # else:    
    #     print("Directory " , dirName ,  " already exists")    

def gtts_text_to_speech(txt, id, lang, tld):
    create_rel_path(txt)
    tts = gtts.gTTS(txt, lang=lang, tld=tld)
    raw_wav = txt + "/" + txt + "_gtts_" + str(id) +".wav"
    long_wav = txt + "/" + txt + "_gtts_" + str(id) +"_2s.wav"
    tts.save(raw_wav)
    a = AudioSegment.silent(duration=2000) #2 second
    b = AudioSegment.from_file(os.getcwd()+ "\\"+ raw_wav)
    c = a + b
    c.export(long_wav,format='wav')

def pyttsx3_text_to_speech(converter, txt, id, voice_id):
    create_rel_path(txt)
    file_name = txt + "/" + txt + "_pyttsx3_" + str(id) + ".wav"
    converter.setProperty('voice', voice_id)
    converter.save_to_file(txt, file_name)
    converter.runAndWait()

def text_to_speech(api, txt_array):
    if (api == "gtts"):
        lang = "en"
        tld_array = ['com.au', 'co.uk', 'com', 'ca', 'co.in', 'ie', 'co.za']
        for txt in txt_array:
            id = 1
            for tld in tld_array:
                gtts_text_to_speech(txt=txt, id=id, lang=lang, tld=tld)
                id +=1
    elif (api == "pyttsx3"):
        converter = pyttsx3.init()
        converter.setProperty('rate', 125)
        voices = converter.getProperty('voices')
        for txt in txt_array:
            id = 1
            for voice in voices:
                voice_id = voice.id
                pyttsx3_text_to_speech(converter=converter, txt=txt, id=id, voice_id=voice_id)
                id += 1
    else:
        print("Invalid api")



txt_array = ["yes"]
apis = ["gtts", "pyttsx3"]
for api in apis:
    text_to_speech(api=api, txt_array=txt_array)
print("done")

