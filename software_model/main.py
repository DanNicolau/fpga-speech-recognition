#!/usr/bin/python3
import audio2numpy as a2n
import numpy as np
from scipy.signal import butter, sosfilt
from scipy.fft import fft
import glob
import matplotlib.pyplot as plt
import matplotlib
matplotlib.use('TkAgg')


def rolling_mean(signal, w):
    return np.convolve(signal, np.ones(w), 'valid') / w

def word_clip(signal, sampling_rate):
    lower_threshold = 0.001 * (2**15)
    print(f'lower: {lower_threshold}')
    upper_threshold = 0.01 * (2**15)
    print(f'upper: {upper_threshold}')

    envelope_samples = 32
    print(f'envelope_samples: {envelope_samples}')
    envelope = rolling_mean(np.abs(signal), envelope_samples) # this seems like a good number, should be based off sampling rate thought TODO

    done = False
    word_windows = [] # list of pairs
    temp_envelope = envelope
    offset = 0
    while(not done):
        #ive reduced the logic to the following:
        # if a lower threshold box contains an upper threshold hit, the box is a word

        is_above_lower = temp_envelope > lower_threshold
        is_above_upper = temp_envelope > upper_threshold

        if (np.sum(is_above_upper) == 0):
            # there are no words break
            break

        first_lower_idx = np.argmax(is_above_lower)
        last_lower_idx = np.argmax(is_above_lower[first_lower_idx:] == 0) + first_lower_idx

        box_sum = np.sum(is_above_upper[first_lower_idx:last_lower_idx])
        if box_sum > 0:
            # we have a word
            word_windows.append( (first_lower_idx + offset, last_lower_idx + offset) )

        temp_envelope = temp_envelope[(last_lower_idx):]
        offset += last_lower_idx

    words = []
    for word_window in word_windows:
        words.append(signal[word_window[0]:word_window[1]])

    return words


#split the word into hamming window/boxcar/triangle
#   hamming is effective, except difficult to implement
# first implementation will be boxcar with no overlap, we will see how effective that iso

def generate_frames(word, sampling_rate):
#some constants that are used in more than 1 function
    millis_per_frame = 20

    samples_per_frame = int(np.round(millis_per_frame * sampling_rate / 1000))

    splits = np.arange(0, len(word), samples_per_frame, dtype=int)
    # remove last entry
    # splits = splits[0:len(splits)-1]

    frames = []

    #50% overlapping frames
    for i in range(len(splits) - 3):
        frames.append(word[splits[i]:splits[i+2]])

    #extend last frame to the remaining part of the word
    frames.append(word[splits[-3]:])
    
    return frames

#generate a traingle pulse for the frames
def triangle_pulse(start, rise_duration, fall_duration, signal_duration):
    signal = np.zeros(signal_duration)
    signal[start : rise_duration + start] = np.linspace(0, 1, rise_duration)
    signal[start + rise_duration : start + rise_duration + fall_duration ] = np.linspace(1, 0, fall_duration)
    return signal

#using a similar implementation that is easier to implement in hw but will have a larger memory consumption
# split ffts into triangles every 50Hz
def filter_banks(ffts, sampling_rate, max_frequency):

    bucket_size = 100 #Hz

    features = []

    for f in ffts:

        banks = []
        step = len(f) * bucket_size / max_frequency
        pulse_points = np.arange(0, f.shape[0], step, dtype=int)

        f_len = len(f)

        bank = triangle_pulse(0, 0, pulse_points[1] - pulse_points[0], f_len)
        banks.append(np.sum(bank*f))
        
        for i in range(1, len(pulse_points)-1):

            bank = triangle_pulse(pulse_points[i-1], pulse_points[i] - pulse_points[i-1], pulse_points[i+1] - pulse_points[i], f_len)
            # early summation to save some RAM
            banks.append( np.sum(np.multiply(bank, f)) )

        features.append(banks)

    features = np.array(features)

    return features



    

#generate the euclidean position for the word
def feature_extraction(word, sampling_rate):
    max_frequency = 4000

    #steps should be the following:

    #framing
    frames = generate_frames(word, sampling_rate)
    #fft
    # compute the fft of all frames
    ffts = []
    for frame in frames:
        # discard everything above max_frequency(4khz) if it exists
        # TODO make this work for sampling frequencies below 8KHZ

        # get the abs value of the fft
        f = np.abs(fft(frame))
        # cut off upper frequencies
        f = f[0:int(np.floor(len(f)*4000/sampling_rate))]
        ffts.append(f)

    #filter banks
    features = filter_banks(ffts, sampling_rate, max_frequency)
    return features
    


def init_dictionary(src):

    files = glob.glob(src)

    centroids = {}

    for file in files:

        word_str = file.split('/')[-1].split('.')[0]

        print(f'computing centroid for: {word_str}')

        # open the file
        signal, sampling_rate = a2n.open_audio(file)

        # plt.plot(signal)
        # plt.show()

        signal = signal*(2**15)
        signal = signal.astype(int)

        # plt.plot(signal)
        # plt.show()

        # clip into words
        words = word_clip(signal, sampling_rate)

        print(f'identified {len(words)} words')
        exit()

        vectors = [] # This can be preinitialized to the number of words * dimensions of wordspace

        # add zeros to longest word to simplify processing
        max_word_len = -1
        for word in words:
            if len(word) > max_word_len:
                max_word_len = len(word)

        old_words = words
        words = []

        for word in old_words:
            new_word = word
            if len(word) != max_word_len:
                new_word = np.concatenate( (new_word, np.zeros(max_word_len - len(word))) )

            words.append(new_word)

        features = None
        for word in words:
            if np.any(features) == None:
                features = feature_extraction(word, sampling_rate)
            else:
                features = np.add(features, feature_extraction(word, sampling_rate))

        centroid = features / len(features)

        centroids[word_str] = centroid

    return centroids

def guess_word(centroids, src):

    files = glob.glob(src)

    word, sampling_rate = a2n.open_audio(files[0])

    word

    word = word_clip(word, sampling_rate)[0]
    test_features = feature_extraction(word, sampling_rate)

    min_cost = np.inf
    min_key = None
    min_rows = test_features.shape[0]


    for c in centroids:
        if centroids[c].shape[0] < min_rows:
            min_rows = centroids[c].shape[0]

    for c in centroids:
        
        cost = centroids[c][0:min_rows] - test_features[0:min_rows]
        cost = np.square(cost)
        cost = np.sum(cost)

        if cost < min_cost:
            min_cost = cost
            min_key = c
            
        

    return min_key, min_cost

if __name__ == "__main__":
    
    # src = "./data/training/*.wav"

    src = "./data/data_set_2.wav"

    centroids = init_dictionary(src)

    # test_file = "./data/testing/alpha_test0.wav"

    # guess, cost = guess_word(centroids, test_file)

    # print(f'test file: {test_file}')
    # print(f'guess: {guess}, cost: {cost}')
