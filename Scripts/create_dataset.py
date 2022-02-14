# create_dataset.py
# (C) 2021 Marquis Kurt.
# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at https://mozilla.org/MPL/2.0/.

import os
from argparse import ArgumentParser
from random import randrange, shuffle
from string import ascii_lowercase
from sys import argv
from typing import Iterable, List, Tuple


def create_parser() -> ArgumentParser:
    """Returns an argument parser that will be used to parse arguments passed into this script."""
    arg_parser = ArgumentParser()
    arg_parser.add_argument("--limit", default=0, help="The hard limit length for words in the dataset.", type=int)
    arg_parser.add_argument(
        "--include-coreml", action="store_true", help="Whether to include the CoreML prediction headers.")
    arg_parser.add_argument("--output-dir", default="datasets", help="The directory to write the CSV files to.")
    arg_parser.add_argument(
        "input", nargs="+", help="The list of files to make the outputs from.", type=str)
    return arg_parser

def import_valid_words(files: List[str]) -> List[str]:
    """Returns a list of valid words from a specified list of word files."""
    valid_words = []
    for file in files:
        with open(file, 'r') as word_file:
            valid_words += [w.strip().lower() for w in word_file.readlines() if is_admissible(w)]
    return valid_words


def is_admissible(word: str) -> bool:
    """Returns whether a word is considered admissible for the dataset.
    
    For the purposes of the dataset, a word is admissible if it conforms to the following:
    - The word must be at least three characters long.
    - The word only contains ASCII characters; i.e., the word does not have any accents.
    - The word only contains letters in the alphabet
    - The word is not a proper noun or acronym (i.e., the word doesn't have uppercase letters)
    - The word is not a contraction.
    """
    real_word = word.strip()
    return len(real_word) >= 3 and real_word.isascii() and real_word.isalpha(
    ) and real_word.islower() and not real_word.endswith("'s")


def random_string(max_size: int) -> str:
    """Returns a string of a random length between 3 and 12 characters, with no syllabic structure in mind."""
    length = randrange(3, max_size) if max_size > 3 else 3
    string = ""
    for _ in range(length):
        next_index = randrange(0, len(ascii_lowercase) - 1)
        string += ascii_lowercase[next_index]
    return string


def pad_sequence(sequence: Iterable, max_length: int = 8) -> list:
    """Returns a list of characters along with a "null character" string to pad out to a maximum length.

    Args:
        sequence (Iterable): The iterable of characters to get a padded sequence for.
        max_length (int, optional): The maximum length of the sequence. Defaults to 8.

    Returns:
        list: [description]
    """
    diff = max_length - sum(1 for _ in sequence)
    return [i for i in sequence] + ["*" for _ in range(diff)]


def run_script(args: List[str]):
    """Runs the primary script."""
    # Capture the real arguments.
    # Create the argument parser and parse the arguments passed in.
    options = create_parser().parse_args(args)

    # Create the dataset pools for valid and invalid words.
    valid_word_dataset = import_valid_words(options.input)

    # Get the average length of the list, or use the pre-defined limit options.
    avg_length = sum([len(str(w)) for w in valid_word_dataset]) // len(valid_word_dataset)
    if options.limit > 0:
        avg_length = options.limit

    invalid_word_dataset = [random_string(avg_length) for _ in range(len(valid_word_dataset))]

    # Filter out words that are too long for our tests.
    valid_word_dataset = [w for w in valid_word_dataset if len(w) <= avg_length]
    invalid_word_dataset = [w for w in invalid_word_dataset if len(w) <= avg_length]

    # Create the columns for the CSV files.
    col_valid: List[Tuple[str, str]] = [(word, "valid") for word in valid_word_dataset]
    col_invalid: List[Tuple[str, str]] = [(word, "invalid") for word in invalid_word_dataset]
    columns = col_valid + col_invalid

    # Shuffle the dataset.
    for _ in range(randrange(25, 50)):
        shuffle(columns)

    # Find the split marker for the 80/20 split.
    split_point = int(len(columns) * 0.8)

    # Split the columns into training and testing pools.
    train, test = columns[:split_point], columns[split_point:]

    # Create the CSV header that will be used to label features and targets.
    csv_header = ",".join((f"char{i+1:02d}" for i in range(avg_length))) + ",Valid\n"
    csv_header_predictive = ",".join(
        (f"char{i+1:02d}" for i in range(avg_length))) + ",prediction\n"

    # Write the training data to the training dataset.
    with open(f"{options.output_dir}/dtrain.csv", "w+") as train_file:
        train_file.write(csv_header)
        for word, classifier in train:
            train_file.write(",".join(pad_sequence(word, avg_length)) + f",{classifier}\n")

    # Write the testing data to the testing dataset.
    with open(f"{options.output_dir}/dtest.csv", "w+") as test_file:
        test_file.write(csv_header)
        for word, classifier in test:
            test_file.write(",".join(pad_sequence(word, avg_length)) + f",{classifier}\n")

    # Write the training data to the training dataset using the predictive headers.
    with open(f"{options.output_dir}/dtrain_predict.csv", "w+") as train_predict_file:
        train_predict_file.write(csv_header_predictive)
        for word, classifier in train:
            train_predict_file.write(",".join(pad_sequence(word, avg_length)) + f",{classifier}\n")

    # Write the testing data to the testing dataset using the predictive headers.
    with open(f"{options.output_dir}/dtest_predict.csv", "w+") as test_predict_file:
        test_predict_file.write(csv_header_predictive)
        for word, classifier in test:
            test_predict_file.write(",".join(pad_sequence(word, avg_length)) + f",{classifier}\n")



if __name__ == "__main__":
    run_script(argv[1:])
