import argparse
import csv
import re
import time
from typing import Optional
from typing import Sequence
from tabulate import tabulate
from io import StringIO


def get_args(argv: Optional[Sequence[str]] = None):
    """this function sets up arguments for getting cars and returns arguments for further searching cars
    creation date: 2023-04-05, last_update: 2023-04-17, developer: Maksym Sukhorukov"""

    start_getting_params = time.perf_counter()

    parser = argparse.ArgumentParser()
    parser.add_argument('-year_from', type=int, default=None, help='only digit values')
    parser.add_argument('-year_to', type=int, default=None, help='only digit values')
    parser.add_argument('-brand', type=str, default=None, help='')
    parser.add_argument('-model', type=str, default=None, help='')
    parser.add_argument('-price_from', type=int, default=None, help='supported only USD values')
    parser.add_argument('-price_to', type=int, default=None, help='supported only USD values')
    parser.add_argument('-transmission', type=str, default=None, help='')
    parser.add_argument('-mileage', type=int, default=None, help='please put value in km')
    parser.add_argument('-body', type=str, default=None, help='')
    parser.add_argument('-engine_from', type=int, default=None, help='please put value in ml')
    parser.add_argument('-engine_to', type=int, default=None, help='please put value in ml')
    parser.add_argument('-fuel', type=str, default=None, help='')
    parser.add_argument('-exchange', type=str, default=None, help='please put Yes or NO value')
    parser.add_argument('-keywords', type=str, default=None, help='please put additional 1 word for searching')
    parser.add_argument('-max_records', type=int, default=20, help='please put Top N digit value')
    parser.add_argument('-source_file', type=str, default='source_data/cars-av-by_card_20230407.csv', help='')
    #parser.add_argument('-source_file', type=str, default='source_data/cars-av-by_card-2023-04-13-11-19-37.csv', help='')
    parser.add_argument('-debug', type=int, default=0, help='if debug flag = 1, the debug proces will run')

    args = parser.parse_args(argv)

    end_getting_params = time.perf_counter()
    if args.debug == 1:
        print(f'Taken time: For getting parameters is {round(end_getting_params - start_getting_params, 2)}s')

    return args


def filtering_cars(params, title_brand, title_model, price_secondary_processed, description_year,
                   description_transmission, description_engine, description_mileage,
                   description_body, full_card, description_fuel, exchange_processed):
    """this function gets filtering params and tokens for filtering cars and returns arguments for further searching cars
    creation date: 2023-04-17, last_update: 2023-04-18, developer: Maksym Sukhorukov"""

    result = False

    if params.brand and params.brand.upper() not in title_brand.upper():
        result = True
    if params.model and params.model.upper() not in title_model.upper():
        result = True
    if (params.price_from and price_secondary_processed[0] < int(params.price_from)) or \
            (params.price_to and price_secondary_processed[0] > int(params.price_to)):
        result = True
    if (params.year_from and description_year < int(params.year_from)) or \
            (params.year_to and description_year > int(params.year_to)):
        result = True
    if params.transmission and params.transmission.upper() not in description_transmission.upper():
        result = True
    if (params.engine_from and description_engine < int(params.engine_from)) or \
            (params.engine_to and description_engine > int(params.engine_to)):
        result = True
    if params.mileage and description_mileage[0] > int(params.mileage):
        result = True
    if params.body and params.body.upper() not in description_body.upper():
        result = True
    if params.keywords and params.keywords.upper() not in full_card.upper():
        result = True
    if params.fuel and params.fuel.upper() not in description_fuel.upper():
        result = True
    if params.exchange and params.exchange.upper() != exchange_processed.upper():
        result = True

    return result


def parse_and_filter_file(params):
    """this function splits dataset into tokens and uses arguments as params for filtering cars and returns dic of
       filtered cars for further processing filtered cars
    creation date: 2023-04-05, last_update: 2023-04-17, developer: Maksym Sukhorukov"""

    start_opening_file = time.perf_counter()

    header_line = True
    filtered_cars = []
    counter = 1                                                             # for testing

    with open(params.source_file, 'r', encoding='utf-8') as file:           # encoding='utf-8'
        file_data = file.read()
        csv_string = StringIO(file_data)
        cars = csv.reader(csv_string)

        end_opening_file = time.perf_counter()
        if params.debug == 1:
            print(f'Taken time: For opening file is '
                  f'{round(end_opening_file - start_opening_file, 2)}s')

        start_parsing_file = time.perf_counter()

        for row in cars:
            if header_line:               # or counter > 200000:         # or counter > 5 added for testing
                header_line = False
                continue

            card_id, title, price_primary, price_secondary, location, labels, comment, description, exchange, \
            scrap_date = row[0:]

            try:
                title_deal_type, title_brand, title_model = re.split(r'^(\S+) (\S+) (.+),(.+)$', title)[1:4]
            except:
                title_deal_type, title_brand, title_model = None, None, None
            try:
                price_primary_processed = (int((''.join(x for x in row[2] if x.isdigit()))), 'byn')
            except:
                price_primary_processed = (None, 'byn')
            try:
                price_secondary_processed = (int((''.join(x for x in row[3] if x.isdigit()))), 'usd')
            except:
                price_secondary_processed = (None, 'usd')
            location_country = 'belarus'
            try:
                location_city = re.split(r'^(\S+)(\,\s(.+))?$', location)[1].strip()
            except:
                location_city = None
            try:
                location_region = re.split(r'^(\S+)(\,\s(.+))?$', location)[-2].strip()
            except:
                location_region = None
            try:
                labels_upd_processed = ''.join(x + ', ' for x in labels.split('|')).strip(', ')
            except:
                labels_upd_processed = None

            full_card = ' '.join(x for x in row[1:9])

            try:
                description_year = int(''.join(x for x in description.split('|')[0].split(',')[0] if x.isdigit()))
            except:
                description_year = None
            try:
                description_transmission = description.split('|')[0].split(',')[1].strip()
            except:
                description_transmission = None
            try:
                description_engine = int(''.join(x for x in description.split('|')[0].split(',')[2] if x.isdigit()) + '00')
            except:
                description_engine = None

            try:
                if description_engine == 0:
                    description_fuel = description.split('|')[0].split(',')[2].strip()
                else:
                    description_fuel = description.split('|')[0].split(',')[-2].strip()
            except:
                description_fuel = None
            try:
                description_mileage = (int(''.join(x for x in description.split('|')[0].split(',')[-1] if x.isdigit())), 'km')
            except:
                description_mileage = None

            try:
                description_body, description_drive_type, description_color = description.split('|')[1].split(',')[0:]
            except:
                description_body, description_drive_type, description_color = None, None, None

            try:
                exchange_processed = 'no' if 'не' in row[8] else 'yes'
            except:
                exchange_processed = None

            check_car = filtering_cars(params, title_brand, title_model, price_secondary_processed, description_year,
                                       description_transmission, description_engine, description_mileage,
                                       description_body, full_card, description_fuel, exchange_processed)

            if check_car:
                continue

            filtered_cars.append([{'card': {'id': int(card_id)},
                                   'title': {'deal_type': title_deal_type, 'brand': title_brand,
                                             'model': title_model},
                                   'price': {'primary': price_primary_processed, 'secondary': price_secondary_processed},
                                   'location': {'country': location_country, 'city': location_city,
                                                'region': location_region},
                                   'labels': {'labels': labels_upd_processed},
                                   'comment': {'comment': comment},
                                   'description': {'year': description_year, 'transmission': description_transmission,
                                                   'engine': description_engine, 'fuel': description_fuel,
                                                   'mileage': description_mileage, 'body': description_body,
                                                   'type': description_drive_type, 'color': description_color},
                                   'exchange': {'exchange': exchange},
                                   'scrap_date': {'scrap_date': scrap_date}
                                   }])

            counter += 1                                                # for testing

    end_parsing_file = time.perf_counter()
    if params.debug == 1:
        print(f'Taken time: For parsing and filtering file is '
              f'{round(end_parsing_file - start_parsing_file, 2)}s')

    return filtered_cars


def order_filtered_cars(params, filtered_cars):
    """this function orders filtered cars
    creation date: 2023-04-08, last_update: 2023-04-17, developer: Maksym Sukhorukov"""

    start_ordering_filtered_file = time.perf_counter()

    filtered_cars_and_ordered = sorted(sorted(sorted(filtered_cars,
                                                     key=lambda x: x[0]['description']['mileage'][0]),
                                              key=lambda x: x[0]['description']['year'], reverse=True),
                                       key=lambda x: x[0]['price']['secondary'][0])

    end_ordering_filtered_file = time.perf_counter()
    if params.debug == 1:
        print(f'Taken time: For ordering filtered file is '
              f'{round(end_ordering_filtered_file - start_ordering_filtered_file, 2)}s')

    return filtered_cars_and_ordered


def print_top_filtered_cars(params, filtered_cars_and_ordered):
    """this function prints filtered and ordered cars using params
    creation date: 2023-04-17, last_update: 2023-04-17, developer: Maksym Sukhorukov"""

    start_printing_ordered_and_filtered_file = time.perf_counter()

    counter = 0

    if len(filtered_cars_and_ordered) > 0:
        prepared_to_print = []

        while counter < min(len(filtered_cars_and_ordered), int(params.max_records)):
            prepared_to_print.append([filtered_cars_and_ordered[counter][0]['title']['brand'],
                                      filtered_cars_and_ordered[counter][0]['title']['model'],
                                      str(filtered_cars_and_ordered[counter][0]['price']['secondary'][0]) + ' ' +
                                      filtered_cars_and_ordered[counter][0]['price']['secondary'][1],
                                      str(filtered_cars_and_ordered[counter][0]['description']['year']),
                                      filtered_cars_and_ordered[counter][0]['description']['transmission'],
                                      str(filtered_cars_and_ordered[counter][0]['description']['engine']),
                                      str(filtered_cars_and_ordered[counter][0]['description']['mileage'][0]) + ' ' +
                                      filtered_cars_and_ordered[counter][0]['description']['mileage'][1],
                                      filtered_cars_and_ordered[counter][0]['description']['body'],
                                      filtered_cars_and_ordered[counter][0]['description']['fuel']])

            counter += 1

        print(tabulate(prepared_to_print,
                       headers=['brand', 'model', 'price', 'year', 'transmission', 'engine', 'mileage', 'body', 'fuel'],
                       tablefmt='plain'))     # mixed_grid

    end_printing_ordered_and_filtered_file = time.perf_counter()
    if params.debug == 1:
        print(f'Taken time: For printing ordered and filtered file is '
              f'{round(end_printing_ordered_and_filtered_file - start_printing_ordered_and_filtered_file, 2)}s')


def main():
    """this function runs all the required functions
    creation date: 2023-04-12, last_update: 2023-04-17, developer: Maksym Sukhorukov"""

    start_program = time.perf_counter()

    params = get_args()

    filtered_cars = parse_and_filter_file(params)

    filtered_cars_and_ordered = order_filtered_cars(params, filtered_cars)

    print_top_filtered_cars(params, filtered_cars_and_ordered)

    end_program = time.perf_counter()
    if params.debug == 1:
        print(f'Taken time: For full program is {round(end_program - start_program, 2)}s')


if __name__ == "__main__":

    main()

