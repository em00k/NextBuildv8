
# -*- coding:cp437 -*-

# TRANSAIR 
# 0.04 (FT - 2020)
# Python 3

# Send a DSK file directly (by WIFI) to a TOSHIBA FlashAIR inside a Floppy EMU, an UNISDISK Air or another device (to test)
# REQUIREMENTS:
# - your FLASHAIR card must be correctly configured and recognized on your WIFI network!
# - if the "name of your card" is not 'flashair', you must modify APPNAME variable accordingly at the beginning of the script.
#   => "name" of your card" refers to the APPNAME defined in your FlashAir CONFIG file if you use Station Mode or SSID if you use Access Point Mode.
# - if you get a bunch of errors at the launch of the script (and everything is correctly configured), it is probably because your FlashAir is not yet initialized and recognized on your wifi network. It takes a little while after the Apple II is turned on. So wait and try again!
#
# - note1: script unmounts old file and mounts the new file after sending it to the FlashAir. This was required with UNISDISK Air (from Nishida Radio).
#          Not sure that this is necessary with a Floppy Emu (from BMOW) or another device...
# - note2: with a Floppy Emu, you must of course use a microSD to SD card adapter to use a FlashAir!
# - note3: script was not tested with another WIFI card, only TOSHIBA FlashAir.
# - note4: at the time (when I had one), script was written for UNISDISK Air. I think it still works with it. However tested recently with a Floppy Emu!


import sys, os, shutil
import logging
import requests
import os.path
import time

APPNAME = "nextsd"

def GenString(string):

    output = ""
    for i in string:
        output = output+"00"+"{:2X}".format(ord(i))
    return output

def main():

    if len(sys.argv) < 2:
        SourceName = "tes1t.wav"
    else:
        SourceName = sys.argv[1]
        DestName = sys.argv[2]
    

    print("Send {} to Flashair =>".format(SourceName))
    
    #### unmount ancien fichier DISK 1
   # print("  UnMount OLD File:", end='')
   # url = "http://"+APPNAME+"/command.cgi?op=131&ADDR=0&LEN=2&DATA=U0"
    # get url
   # r = requests.get(url)
   # if (r.status_code == 200):
   #     print("OK")
   # else:
   #     print(r.status_code)

    #### delete ancien fichier
    # print("  Delete OLD File:", end='')
    # url = "http://"+APPNAME+"/upload.cgi?DEL="+SourceName
    # #print url
    # r = requests.get(url)
    # if (r.status_code == 200):
    #     print("OK")
    # else:
    #     print(r.status_code)

    #### upload nouveau fichier
    
    ## set TIME
    print("  Set Time for NEW File:", end='')
    # get time of the new file
    t = time.localtime(os.path.getmtime(SourceName))
    year = (t[0] - 1980) << 9
    month = t[1] << 5
    date = t[2]
    hours = t[3] << 11
    minites = t[4] << 5
    seconds = t[5] // 2
    Time = "0x{:04X}{:04X}".format((year + month + date), (hours + minites + seconds))
    # "get" Time,
    url = "http://"+APPNAME+"/upload.cgi?FTIME="+Time
    r = requests.get(url)
    if (r.status_code == 200):
        print("OK")
    else:
        print(r.status_code)
    
    ## send file 
    print("  Upload NEW File:", end='')
    url = "http://"+APPNAME+"/upload.cgi"
    files = {'file':(SourceName, open(SourceName,'rb'))}
    # "post" url
    r = requests.post(url, files= files)
    if (r.status_code == 200):
        print("OK")
    else:
        print(r.status_code)
    
    #### mount nouveau fichier
        
    # print("  Mount NEW File:", end='')
    # # UTF-16 for string "/(SourceName)"+00
    # string = "/"+SourceName
    # uni = GenString(string)+"0000"
    
    # # test.dsk => uni = "002F0074006500730074002E00640073006B0000"
    # ln = len(uni)+2
    # sln = str(ln)
    # # send data ("mount")
    # url = "http://"+APPNAME+"/command.cgi?op=131&ADDR=0&LEN="+sln+"&DATA=D0"+uni;
    # # "get" url
    # r = requests.get(url)
    # if (r.status_code == 200):
    #     print("OK")
    # else:
    #     print(r.status_code)
        
    # return


if __name__ == '__main__':
    main()
