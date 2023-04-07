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

            if counter > 2:             # for testing
                continue                # for testing
            counter += 0                # for testing

            card_id = int(row[0])

            title = row[1]
            try:
                title_deal_type = re.split(r'^(\S+)\s+(\S+)\s+([^·]+)((\·)\s+(.+))?$|$', title.split(',')[0])[1].strip()
                title_brand = re.split(r'^(\S+)\s+(\S+)\s+([^·]+)((\·)\s+(.+))?$|$', title.split(',')[0])[2].strip()
                title_model = re.split(r'^(\S+)\s+(\S+)\s+([^·]+)((\·)\s+(.+))?$|$', title.split(',')[0])[3].strip()
                title_restyling = re.split(r'^(\S+)\s+(\S+)\s+([^·]+)((\·)\s+(.+))?$|$', title.split(',')[0])[6].strip()
            except:
                title_deal_type, title_brand, title_model, title_restyling = None, None, None, None

            price_primary = row[2]
            try:
                price_primary_processed = (int((''.join(x for x in row[2] if x.isdigit()))), 'byn')
            except:
                price_primary_processed = (None, 'byn')

            price_secondary = row[3]
            try:
                price_secondary_processed = (int((''.join(x for x in row[3] if x.isdigit()))), 'usd')
            except:
                price_secondary_processed = (None, 'usd')

            location = row[4]
            location_country = 'belarus'
            try:
                location_city = re.split(r'^(\S+)(\,\s(.+))?$', location)[1].strip()
            except:
                location_city = None
            try:
                location_region = re.split(r'^(\S+)(\,\s(.+))?$', location)[-2].strip()
            except:
                location_region = None

            labels = row[5]

            try:
                labels_upd_processed = ''.join(x + ', ' for x in labels.split('|')).strip(', ')
            except:
                labels_upd_processed = None

            comment = row[6]

            description = row[7]
            try:
                description_year = int(''.join(x for x in description.split('|')[0].split(',')[0] if x.isdigit()))
            except:
                description_year = None
            try:
                description_transmission = description.split('|')[0].split(',')[1].strip()
            except:
                description_transmission = None
            try:
                description_engine = int(''.join(x for x in description.split('|')[0].split(',')[2]if x.isdigit()) +
                                         '00')
            except:
                description_engine = None
            try:
                if description_engine == 0:
                    description_fuel = description.split('|')[0].split(',')[2].strip()
                else:
                    description_fuel = description.split('|')[0].split(',')[3].strip()
            except:
                description_fuel = None
            try:
                description_mileage = (int(''.join(x for x in description.split('|')[0].split(',')[4] if x.isdigit())),
                                       'km')
            except:
                description_mileage = None
            try:
                description_body = description.split('|')[1].split(',')[0].strip()
            except:
                description_body = None
            try:
                description_drive_type = description.split('|')[1].split(',')[1].strip()
            except:
                description_drive_type = None
            try:
                description_color = description.split('|')[1].split(',')[2].strip()
            except:
                description_color = None

            exchange = row[8]

            scrap_date = row[9]

            full_card = title + ' ' + price_primary + ' ' + price_secondary + ' ' + location + ' ' + labels + ' ' +\
                        comment + ' ' + description + ' ' + exchange + ' ' + scrap_date


            print(full_card)



parse_file(params)



