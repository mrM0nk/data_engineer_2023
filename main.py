import argparse
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
    parser.add_argument('-source_file', type=str, default='source_data/cars-av-by_card.csv', help='')

    args = parser.parse_args(argv)

    return args


params = get_args()


def parse_file(params):

    counter = 0                             # for testing
    counter_all_rows = 0                             # for testing
    counter_bad_rows = 0                             # for testing

    header_line = True

    with open(params.source_file, encoding='utf-8') as cars:  # , encoding='utf-8'
        for row in cars:
            if counter > 3:                 # for testing
                continue                    # for testing
            counter += 0                    # for testing
            counter_all_rows += 1           # for testing

            if header_line:
                header_line = False
                continue

            print('start block')
            print(row)

            try:
                card_id = re.split(r'(\d+),(\".+\"),(.+),(.+),(\".+\"),(\".+\"),(.+)', row)[1]
            except:
                card_id = None
                counter_bad_rows += 1           # for testing

            try:
                title = re.split(r'(\d+),(\".+\"),(.+),(.+),(\".+\"),(\".+\"),(.+)', row)[2]
            except:
                title = None
            try:
                price_primary = re.split(r'(\d+),(\".+\"),(.+),(.+),(\".+\"),(\".+\"),(.+)', row)[3]
            except:
                price_primary = None
            try:
                price_secondary = re.split(r'(\d+),(\".+\"),(.+),(.+),(\".+\"),(\".+\"),(.+)', row)[4]
            except:
                price_secondary = None
            try:
                comment = re.split(r'(\d+),(\".+\"),(.+),(.+),(\".+\"),(\".+\"),(.+)', row)[5]
            except:
                comment = None
            try:
                description = re.split(r'(\d+),(\".+\"),(.+),(.+),(\".+\"),(\".+\"),(.+)', row)[6]
            except:
                description = None
            try:
                exchange = re.split(r'(\d+),(\".+\"),(.+),(.+),(\".+\"),(\".+\"),(.+)', row)[7]
            except:
                exchange = None

            print(card_id)
            print(title)
            print(price_primary)
            print(price_secondary)
            print(comment)
            print(description)
            print(exchange)
            print('end block')
        print('counter_all_rows = ' + str(counter_all_rows) + ',  counter_bad_rows = ' + str(counter_bad_rows))

parse_file(params)



