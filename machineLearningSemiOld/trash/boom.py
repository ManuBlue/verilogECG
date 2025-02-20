# %% [markdown]
# 

# %%
import matplotlib.pyplot as plt
import pandas as pd 
import os
import pywt
import numpy as np

import csv
from scipy import stats
plt.rcParams["figure.figsize"] = (30,6)
plt.rcParams['lines.linewidth'] = 1
plt.rcParams['lines.color'] = 'b'
plt.rcParams['axes.grid'] = True 


# %%
def denoise(data): 
    w = pywt.Wavelet('sym4')
    maxlev = pywt.dwt_max_level(len(data), w.dec_len)
    threshold = 0.04 # Threshold for filtering

    coeffs = pywt.wavedec(data, 'sym4', level=maxlev)
    for i in range(1, len(coeffs)):
        coeffs[i] = pywt.threshold(coeffs[i], threshold*max(coeffs[i]))
        
    datarec = pywt.waverec(coeffs, 'sym4')
    
    return datarec
path = os.path.join(os.getcwd(),'mitbih_database')
window_size = 3000
maximum_counting = 10000

classes = ['N', 'L', 'R', 'A', 'V']
n_classes = len(classes)
count_classes = [0]*n_classes

X = list()
y = list()
filenames = next(os.walk(path))[2]

# Split and save .csv , .txt 
records = list()
annotations = list()
filenames.sort()
for f in filenames:
    filename, file_extension = os.path.splitext(f)
    
    # *.csv
    if(file_extension == '.csv'):
        records.append(os.path.join(path, filename + file_extension))

    # *.txt
    else:
        annotations.append(os.path.join(path, filename + file_extension))
print(records)

# %%
# Records
for r in range(0, len(records)):
    signals = []

    with open(records[r], 'rt') as csvfile:
        spamreader = csv.reader(csvfile, delimiter=',', quotechar='|') # read CSV file
        row_index = -1
        for row in spamreader:
            if(row_index >= 0):
                signals.insert(row_index, int(row[1]))
            row_index += 1

    signals = denoise(signals)    
    signals = stats.zscore(signals)
    

    example_beat_printed = False
    
    stride = 50
    
    with open(annotations[r], 'r') as fileID:
        data = fileID.readlines()
        beat = list()

        for d in range(1, len(data), stride):  # Step by stride
            splitted = data[d].split(' ')
            splitted = filter(None, splitted)
            next(splitted)  # Time... Clipping
            pos = int(next(splitted))  # Sample ID
            arrhythmia_type = next(splitted)  # Type
            
            if arrhythmia_type in classes:
                arrhythmia_index = classes.index(arrhythmia_type)
                count_classes[arrhythmia_index] += 1
                
                if window_size <= pos < (len(signals) - window_size):
                    beat = signals[pos - window_size : pos + window_size]

                    # Add to the dataset
                    X.append(beat)
                    y.append(arrhythmia_index)

# data shape
print(np.shape(X), np.shape(y))


# %%
plt.plot(X[0])
plt.show()
X_train_df = pd.DataFrame(X)

# %%
import numpy as np
from numpy import log
from scipy.signal import find_peaks
import time  # Import time module to measure execution time

class Naakarma:
    def __init__(self, x, m=2, r=0.05, n=0.125, w=0.8):
        self.x = np.asarray(x)
        self.m = m
        self.r = r
        self.n = n
        self.w = w

    def _normal_distance(self, i, j, m, eps=1e-10):
        diff = np.abs(self.x[i:i+m] - self.x[j:j+m])
        max_d, min_d = np.max(diff), np.min(diff)
        return (max_d - min_d) / (max_d + min_d + eps)

    def _dx(self, i, j, m):
        nd = self._normal_distance(i, j, m)
        result = np.exp(-pow(nd, self.n) / self.r)
        return result

    def _compute_similarity(self, m):
        N = len(self.x)
        size = N - m
        total = 0.0
        print(f"Computing similarity for m={m}, size={size}")

        for i in range(size):
            if i % 100 == 0:  # Print progress every 100 iterations
                print(f"Processing row {i}/{size}")
            for j in range(size):
                total += self._dx(i, j, m)

        similarity = total / (size * size)
        print(f"Similarity computed: {similarity}")
        return similarity

    def bx(self):
        return self._compute_similarity(self.m)

    def axm(self):
        return self._compute_similarity(self.m + 1)

    def eaf(self):
        start_time = time.time()  # Start timer
        
        a = self.axm()
        b = self.bx()
        
        result = -log(a) + log(b) + log(2 * self.r)
        
        end_time = time.time()  # End timer
        print(f"eaf() execution time: {end_time - start_time:.4f} seconds")
        
        return result


# %%
for i, r in X_train_df.iterrows():
    r = list(r)
    n = Naakarma(r)
    t = n.eaf()
    print(t)
    break

# %%