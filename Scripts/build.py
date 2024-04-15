#!/usr/bin/env python3

# replaces modules.py with a simpler approach
# part of nextbuild8

import sys
import subprocess
import os
import glob
import shutil
import argparse
import re

# Setting up the base directory and scripts directory based on the current script location
BASE_DIR = os.path.abspath(os.path.join(os.path.dirname(os.path.realpath(__file__)), os.pardir))
SCRIPTS_DIR = os.path.abspath(os.path.join(BASE_DIR, 'Scripts'))

# Argument parser setup
parser = argparse.ArgumentParser(description='build.py NextBuild Module Builder')
parser.add_argument('-b', '--file', type=str, required=True, help='.bas file to process - required')
parser.add_argument('-q', '--quiet', action='store_true', help='Dont show splash')
parser.add_argument('-m', '--modules', action='store_true', help='Compile & Build module files')
parser.add_argument('-s', '--singlefile', action='store_true', help='Compile single Module')
parser.add_argument('-e', '--lastnex', action='store_true', help='Run Master NEX')

# After argument parsing setup
args = parser.parse_args()

# Assigning singlefile from the parsed arguments
singlefile = args.singlefile
lastnex = args.lastnex

# The input file and modules flag are now correctly assigned from the parsed arguments
inputfilea = args.file
modules = args.modules
directory_path = os.path.dirname(inputfilea)

def CheckForBasic():
    # was ther file a .bas?
    head_tail = os.path.split(inputfilea)

    testfname = head_tail[1].split('.')[1-2]

    if testfname == 'bas':
        print(".BAS file")
    else:
        print('Not a basic file! Exiting.')
        sys.exit(1)    

    if head_tail[1] == 'nextlib.bas':
        print("Looks like you're trying to compile the nextlib.bas! Exiting.")
        sys.exit(1) 
        

# Helper function to check if the filename matches the 'Module[number].bas' pattern with number between 0 and 255
def is_valid_module_filename(filename):
    match = re.match(r'Module(\d+)\.bas$', filename)
    if match:
        number = int(match.group(1))
        return 0 <= number <= 255
    return False

# Updated function to process modules
def ProcessModules():
    print("Compiling Modules")
    print("Base Dir: " + BASE_DIR)
    print("Main Source: " + inputfilea)

    head_tail = os.path.split(inputfilea)
    # This will initially get all 'Module*.bas' files
    tmp_path_pattern = os.path.join(head_tail[0], 'Module*.bas')
    all_module_files = glob.glob(tmp_path_pattern)

    # Now filter files that match the specific number range
    valid_module_files = [file for file in all_module_files if is_valid_module_filename(os.path.basename(file))]

#    print("Valid Modules Found: ", valid_module_files)

    for file in valid_module_files:
        print("Creating module: " + file)
        try:
            cmd = [sys.executable, os.path.join(SCRIPTS_DIR, 'nextbuild.py'), '-b', file, '-q', '-m']
            subprocess.call(cmd)
        except Exception as e:
            print(f"Failed to process module {file}: {e}")
            sys.exit(1)

    print("Copying modules to data folder...")
    # Assuming the .bin files follow a similar naming convention and need similar filtering
    bin_files_pattern = os.path.join(head_tail[0], 'Module*.bin')
    all_bin_files = glob.glob(bin_files_pattern)
    valid_bin_files = [file for file in all_bin_files if is_valid_module_filename(os.path.basename(file).replace('.bin', '.bas'))]

    for file in valid_bin_files:
        print('Copy: ' + file + " > " + os.path.join(head_tail[0], 'data'))
        shutil.copy(file, os.path.join(head_tail[0], 'data'))

    print("Done.")

def ProcessSingle():
    print("Compiling Single File ")
    print("Base Dir: " + BASE_DIR)
    print("Main Source: " + inputfilea)

    head_tail = os.path.split(inputfilea)
    tmp_path = os.path.join(head_tail[0], 'Module*.bas')
    print("Creating module: " + inputfilea)
    file = inputfilea
    try:
        cmd = [sys.executable, os.path.join(SCRIPTS_DIR, 'nextbuild.py'), '-b', file, '-q', '-s']
        subprocess.call(cmd)
        lastfile = file
    except Exception as e:
        print(f"Failed to process module {file}: {e}")
        sys.exit(1)


    print("Copying modules to data folder...")
    tmp_path = os.path.join(head_tail[0], 'Module*.bin')
    for file in glob.glob(tmp_path):
        print('Copy: ' + file + " > " + os.path.join(head_tail[0], 'data'))
        shutil.copy(file, os.path.join(head_tail[0], 'data'))

    print("Done.")

def StartEmulator(input_file):
    """
    Starts an emulator by calling an external executable, launching a specific .NEX file.

    Args:
        input_file (str): Path to the file containing the master line to extract the executable name.
    """
    # Initialize master_file variable
    master_file = None
    head_tail = os.path.split(inputfilea)       

    # Open and read the input file to find the master line
    try:
        with open(input_file, 'r') as file:
            for line in file:
                if line.startswith('\'!master='):
                    # Extract the filename (removing potential trailing comments) and change its extension to .NEX
                    master_file = line.strip().split('=')[1].split()[0].strip('\'\"')
                    print("Master found = " + master_file)
                    break
    except FileNotFoundError:
        print(f"Input file {input_file} not found.")
        return

    # Ensure master_file was found
    if not master_file:
        print("Master file directive not found in input file.")
    
        filename = head_tail[1]                         # Fetch input filename                    
        name, _ = os.path.splitext(filename)            # split so module. 
        new_filename = name + ".nex"                    # add .nex 
       # print(new_filename)
        print("Trying to launch ."+ new_filename)
        LaunchEmulator(input_file)                      # launch emu
        return

    # Construct the emulator path and command
    emulator_path = "./../Emu/Cspect/Cspect.exe"

    # Ensure the path is correct
    if not os.path.isfile(emulator_path):
        print(f"Emulator executable not found at {emulator_path}. Please check the path.")
        return

    master_file_path = os.path.join(directory_path , master_file)  # Ensure this path is correct

    emulator_path = os.path.abspath(os.path.join(BASE_DIR, "Emu", "Cspect", "Cspect.exe"))
    mmc_path = os.path.join(directory_path , "data")

    # Constructing command as a single string
    emulator_cmd = f'"{emulator_path}" -w3 -16bit -brk -tv -vsync -nextrom -zxnext -mmc="{mmc_path}" "{master_file_path}"'

    print(f"Executing: {emulator_cmd}")  # Debugging: Print the command to be executed


    # Attempt to start the emulator with the specified .NEX file
    try:
        subprocess.run(emulator_cmd, check=True)  
#        print(f"Emulator started successfully with {master_file}.")
#        print(f"Emulator started successfully with {emulator_cmd}.")
    except subprocess.CalledProcessError as e:
        print(f"Failed to start emulator: {e}")
    except FileNotFoundError:
        print("Emulator executable not found. Please check the path.")

# Example usage, replace 'your_input_file.bas' with the actual input file path
# StartEmulator('your_input_file.bas')

def LaunchEmulator(input_file):
    
    head_tail = os.path.split(inputfilea)  
    filename = head_tail[1]
    name, _ = os.path.splitext(filename)
    new_filename = name + ".nex"
    filename = os.path.join(directory_path , new_filename)
    map_file = name + ".map"
    map_file = os.path.join(directory_path , map_file)

    emulator_path = os.path.abspath(os.path.join(BASE_DIR, "Emu", "Cspect", "Cspect.exe"))
    mmc_path = os.path.join(directory_path , "data")

    # Constructing command as a single string
    emulator_cmd = f'"{emulator_path}" -w3 -16bit -brk -tv -vsync -nextrom -zxnext -map="{map_file}" -mmc="{mmc_path}" "{filename}"'

    print(f"Executing: {emulator_cmd}")  # Debugging: Print the command to be executed


    # Attempt to start the emulator with the specified .NEX file
    try:
        subprocess.run(emulator_cmd, check=True)  
#        print(f"Emulator started successfully with {master_file}.")
#        print(f"Emulator started successfully with {emulator_cmd}.")
    except subprocess.CalledProcessError as e:
        print(f"Failed to start emulator: {e}")
    except FileNotFoundError:
        print("Emulator executable not found. Please check the path.")


# Main function to execute the script logic
if __name__ == '__main__':
   # print(f"Modules Flag: {modules}, Single File Flag: {singlefile}")  # Debugging line

    CheckForBasic()

    if modules:
        print("Processing modules")
        ProcessModules()
    elif singlefile:  # Changed to 'elif' to avoid potential overlap if both flags were somehow set
        print("Processing single module")
        ProcessSingle()
    elif lastnex:  # Changed to 'elif' to avoid potential overlap if both flags were somehow set
#        print(f"File: {inputfilea} ")  # Debugging line
#        print("BASE DIR : "+BASE_DIR)  # Debugging line
#        print("Run Master NEX")
        StartEmulator(inputfilea)
    # Optionally, you could call StartEmulator here or based on another condition/argument
