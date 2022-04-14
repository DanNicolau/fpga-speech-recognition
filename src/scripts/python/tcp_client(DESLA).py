### IMPORTS ###

import socket

###############




##### DEFINES ########
PACKET_SIZE = 1460
HOST = "1.1.4.2"  # The remote server's hostname or IP address
PORT = 7  # The port used by the remote server

#####################




########### GETTING THE IP ADDRESS OF THE COMPUTE FPGA FROM THE LOAD MANAGE FPGA ########


in_data = b""       # this variable stores the reply after sending compute request

print("\nSending a compute request to IP: " + HOST)
with socket.socket(socket.AF_INET, socket.SOCK_STREAM) as s:

    s.connect((HOST, PORT))

    byte_data = b"\x31";                       # using this code to indicate a compute request
    print("Sending: ", repr(byte_data))
    s.sendall(byte_data)
    in_data = s.recv(1024)
    print("Received", repr(in_data))
    
    s.shutdown(1)
    s.close()

in_data_str = int.from_bytes(in_data, 'little')

HOST = "1.1." + str(in_data_str) + ".2"
print("Compute request reply received, will send data to: " + HOST)

######################################################################################





################ Opening WAV file for PREPROCESSING ##################################

print("\nPre-processing WAV file")

#wav_f = open("W:\ECE532\Project\Audio Files\WAV\single_word_1.wav", "rb")
#wav_f = open("W:\ECE532\Project\Audio Files\WAV\single_word_1_demo.wav", "rb")
wav_f = open("W:\ECE532\Project\Audio Files\WAV\yes_python.wav", "rb")

byte_data = wav_f.read(2)   # start reading the header
head_count = 1

while (byte_data != b"da"):           # keep reading the header until we get to the data section
    head_count = head_count + 1
    byte_data = wav_f.read(2)

byte_data = wav_f.read(2)
head_count = head_count + 1

if (byte_data != b"ta"):         # assert that read data is "ta"
    exit()

byte_data = wav_f.read(4)               # next 4 bytes following the data section is the size of the file in bytes
byte_data = int.from_bytes(byte_data, 'little')

print("Total number of bytes skipped (header): ", (head_count+1)*2)
print("Size of the file (in bytes) is: ", byte_data)

iterations = byte_data // PACKET_SIZE
remainder = byte_data % PACKET_SIZE
#print("iterations: ", iterations, " remainder: ", remainder)

######################################################################################




######### Opening a new CONNECTION ###################

# Open .wav file for reading in binary mode
s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
s.settimeout(30)
s.connect((HOST, PORT))

######################################################




######### Sending a NEW_DATA REQUEST #################

print("\nNow sending a new_data request to " + HOST)
s.sendall(b"\x32")

server_reply = s.recv(1024)
server_reply = int.from_bytes(server_reply, 'little')

if (server_reply):
    print("Server is ready to receive data")
else:
    print("Server is not ready to receive data")

#####################################################




##################### Send DATA and close WAV file ##########

print("\nStarting data transfer!!")

packet_count = 1
for x in range(iterations):
    byte_data = wav_f.read(PACKET_SIZE)
    print("Sending packet: ", packet_count)
    #print("Sending: ", repr(byte_data))
    s.sendall(byte_data)
    in_data = s.recv(PACKET_SIZE)
    #print("Received", repr(in_data))
    packet_count = packet_count + 1
    x = x+1


byte_data = wav_f.read(remainder)
print("Sending packet: ", packet_count)
s.sendall(byte_data)
in_data = s.recv(1024)

wav_f.close();
print("Ending data transfer!!")

######################################################





######### Sending an END_DATA REQUEST #################

print("\nNow sending a end_data request to " + HOST)
s.sendall(b"\x33")

server_reply = s.recv(1024)
server_reply = int.from_bytes(server_reply, 'little')

if (server_reply):
    print("Server acknowledges end_data request")
else:
    print("Server DOES NOT acknowledge end_data request")


#####################################################


######### Sending an START_COMPUTE REQUEST #################

s.settimeout(120)           # arbitrary value, need to play around with this


print("\nNow sending a start_compute request to " + HOST)
s.sendall(b"\x34")

server_reply = s.recv(1024)
server_reply = int.from_bytes(server_reply, 'little')

if (server_reply):
    print("Server acknowledges start_compute request")
else:
    print("Server DOES NOT acknowledge start_compute request")


#####################################################




################## CLOSING CONNECTION ################
    
s.shutdown(1)
s.close()

#####################################################




############################################################# END OF CODE ########################################
















############ CODE BELOW THIS IS OLD ###################

#for x in range(2):
#    byte_data = wav_f.read(1460)
#    print("Sending: ", repr(byte_data))
#    s.sendall(byte_data)
#    in_data = s.recv(1024)
#    print("Received", repr(in_data))
#    x = x+1


#byte_data = wav_f.read(PACKET_SIZE)
#while (byte_data):
#    s.sendall(byte_data)
#    in_data = s.recv(1024)
#    print("Received", repr(in_data))
#    byte_data = wav_f.read(PACKET_SIZE)



#in_data = b""       # this variable stores the reply after sending compute request
#print("Now sending data to IP: " + HOST)
#with socket.socket(socket.AF_INET, socket.SOCK_STREAM) as s:

    #s.connect((HOST, PORT))

    #byte_data = b"HI THERE FELLOW ENGINEER";                       # using this code to indicate a compute request
    #print("Sending: ", repr(byte_data))
    #s.sendall(byte_data)
    #in_data = s.recv(1024)
    #print("Received", repr(in_data))
   # 
    #s.shutdown(1)
    #s.close()

