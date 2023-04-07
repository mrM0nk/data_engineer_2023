import argparse
import csv
import re
from typing import Optional
from typing import Sequence


def get_args(argv: Optional[Sequence[str]] = None):
    """this function sets up arguments for getting cars and returns arguments for further searching cars
    developer: Maksym Sukhorukov"""

    parser = argparse.ArgumentParser()
    parser.add_argument('-year_from', type=int, default=None, help='')
    parser.add_argument('-year_to', type=int, default=None, help='')
    parser.add_argument('-brand', type=str, default=None, help='')
    parser.add_argument('-model', type=str, default=None, help='')
    parser.add_argument('-price_from', type=int, default=None, help='')
    parser.add_argument('-price_to', type=int, default=None, help='')
    parser.add_argument('-transmission', type=str, default=None, help='')
    parser.add_argument('-mileage', type=int, default=None, help='')
    parser.add_argument('-body', type=str, default=None, help='')
    parser.add_argument('-engine_from', type=int, default=None, help='')
    parser.add_argument('-engine_to', type=int, default=None, help='')
    parser.add_argument('-fuel', type=str, default=None, help='')
    parser.add_argument('-exchange', type=str, default=None, help='')
    parser.add_argument('-keywords', type=str, default=None, help='')
    parser.add_argument('-max_records', type=int, default=20, help='')
    parser.add_argument('-source_file', type=str, default='source_data/cars-av-by_card_20230407.csv', help='')

    args = parser.parse_args(argv)

    return args


params = get_args()


def parse_file(params):

    header_line = True
    counter = 0                         # for testing

    with open(params.source_file, 'r', encoding='utf-8') as file:  # , encoding='utf-8'
        cars = csv.reader(file)
        for row in cars:
            if header_line:
                header_line = False
                continue

            if counter > 0:             # for testing
                continue                # for testing
            counter += 1                # for testing

            card_id, title, price_primary, price_secondary, location, labels, comment, \
            description, exchange, scrap_date = row[:]

            print(card_id)
            print(title)
            print(price_primary)
            print(price_secondary)
            print(location)
            print(labels)
            print(comment)
            print(description)
            print(exchange)
            print(scrap_date)

            print(row)





parse_file(params)



