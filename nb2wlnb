#!/usr/bin/env python

import sys
import os
import shutil
import json
import re
from enum import Enum

if sys.version_info < (3, 10):
    sys.exit("Python %s.%s or later is required.\n" % (3, 10))

if len(sys.argv) == 2:
    input_file = sys.argv[1]
else:
    raise ValueError('Expected one argument: filename')

file_extension = input_file.split('.')
delete_file_after_success = False

match(file_extension[-1]):
    case 'm':
        pass

    case 'nb':
        if shutil.which(f'nb2m') is None:
            raise RuntimeError('Cannot find nb2m converter. Is it on PATH?')

        if os.system(f'nb2m {input_file}')!=0:
            raise RuntimeError('Error while converting to ".m". Are you sure wolframscript is available?\n\
You can also try converting manually by saving a mathematica notebook as a .m file')

        input_file = '.'.join(file_extension[:-1]+['m'])
        delete_file_after_success = True
        pass

    case _:
        raise NotImplementedError('Only .m or .nb files are supported')

output_file = '.'.join(file_extension[:-1]+['wlnb'])

# implemented cell types
cell_type = Enum('cell_type', ['Input', 'Title', 'Text', 'Subsection', 'Chapter', 'Subsubsection', 'Section', 'Initialization'])

keywords = {
    '(* ::Package:: *)': -1, # skip this cell, it shouldn't do anything
    '(* ::Input:: *)': cell_type.Input,
    '(* ::Title:: *)': cell_type.Title,
    '(* ::Text:: *)': cell_type.Text,
    '(* ::Subsection:: *)': cell_type.Subsection,
    '(* ::Chapter:: *)': cell_type.Chapter,
    '(* ::Subsubsection:: *)': cell_type.Subsubsection,
    '(* ::Section:: *)': cell_type.Section,
    '(* ::Input::Initialization:: *)': cell_type.Initialization
}

# check for any unimplemented cell types
encountered_cell_types = set()
with open(input_file, 'r') as fi:
    for l in fi:
        encountered_cell_types.update(re.findall(r'\(\* ::.*:: \*\)\n', l))

encountered_cell_types = set(map(lambda x: x.strip(), encountered_cell_types)) # map lambda x: xstrip() to the set
unkown_cells = encountered_cell_types.difference(keywords) # check if the difference is empty
if len(unkown_cells)>0:
    raise NotImplementedError(f'Cell type {unkown_cells.pop()} is not yet implemented.')

# default layout of a cell data
default_cell_data = {
    "kind": 2,
    "value": "",
    "languageId": "wolfram",
    "outputs": [],
    "metadata": {},
    "executionSummary": {}
    }

def end_current_cell():
    """Commit the current cell to the notebook data and start a new one"""
    global current_cell_data

    current_cell_data['value'] = current_cell_data['value'][:-1] # remove the trailing \n

    if current_cell_data['value'].strip()!="" or current_cell_data['languageId'] != 'wolfram':
        nb_data['cells'].append(current_cell_data) # commit to the notebook

    current_cell_data = default_cell_data.copy() # reset for the next cell

def read(line):
    """Treat one line"""
    global current_cell_type
    global current_cell_data

    if line.strip() in keywords:
        if current_cell_type != -1: # do not do initialy or for useless cell types
            end_current_cell()
            
        current_cell_type = keywords[line.strip()]
        match(current_cell_type):
            case -1:
                pass

            case cell_type.Input|cell_type.Initialization:
                pass
            
            case cell_type.Title|cell_type.Chapter|cell_type.Section|cell_type.Subsection|cell_type.Subsubsection|cell_type.Text:
                current_cell_data['kind'] = 1
                current_cell_data['languageId'] = 'markdown'
                current_cell_data['metadata'] = {'attachments': {}}
            
            case _:
                raise NotImplementedError(f'{current_cell_type} initialization has not yet been implemented')

    elif line.strip()!='':
        match(current_cell_type):
            case cell_type.Input:
                current_cell_data['value'] += line[2:-3]+'\n'
            
            case cell_type.Title:
                current_cell_data['value'] += '# '+line[2:-3]+'\n'
            
            case cell_type.Chapter:
                current_cell_data['value'] += '## '+line[2:-3]+'\n'
            
            case cell_type.Section:
                current_cell_data['value'] += '### '+line[2:-3]+'\n'
            
            case cell_type.Subsection:
                current_cell_data['value'] += '#### '+line[2:-3]+'\n'

            case cell_type.Subsubsection:
                current_cell_data['value'] += '##### '+line[2:-3]+'\n'

            case cell_type.Text:
                current_cell_data['value'] += line[2:-3]+'\n'
            
            case cell_type.Initialization:
                current_cell_data['value'] += line

            case _:
                raise NotImplementedError(f'{current_cell_type} line read has not yet been implemented')

nb_data = {"cells": []}
current_cell_type = -1
current_cell_data = default_cell_data.copy()

# main loop
with open(input_file, 'r') as fi, open(output_file, 'w') as fo:
    for l in fi.readlines():
        read(l)
    end_current_cell()

    fo.write(json.dumps(nb_data, indent=1))

if delete_file_after_success:
    os.remove(input_file)