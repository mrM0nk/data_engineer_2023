import argparse
import csv
import re
from typing import Optional
from typing import Sequence


def get_args(argv: Optional[Sequence[str]] = None):
    """this function sets up arguments for getting cars and returns arguments for further searching cars
    creation date: 2023-04-05, last_update: 2023-04-08, developer: Maksym Sukhorukov"""

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

    args = parser.parse_args(argv)

    return args


params = get_args()


def parse_and_filter_file(params):
    """this function splits dataset into tokens and uses arguments as params for filtering cars and returns dic of
       filtered cars for further processing filtered cars
    creation date: 2023-04-05, last_update: 2023-04-08, developer: Maksym Sukhorukov"""

    header_line = True
    filtered_cars = []

    with open(params.source_file, 'r', encoding='utf-8') as file:  # encoding='utf-8'
        cars = csv.reader(file)
        for row in cars:
            if header_line:
                header_line = False
                continue

            card_id = int(row[0])

            title = row[1]
            try:
                title_deal_type = re.split(r'^(\S+)\s+(\S+)\s+([^·]+)((\·)\s+(.+))?$|$', title.split(',')[0])[1].strip()
            except:
                title_deal_type = None

            try:
                title_brand = re.split(r'^(\S+)\s+(\S+)\s+([^·]+)((\·)\s+(.+))?$|$', title.split(',')[0])[2].strip()
                if params.brand and params.brand.upper() not in title_brand.upper():
                    continue
            except:
                title_brand = None

            try:
                title_model = re.split(r'^(\S+)\s+(\S+)\s+([^·]+)((\·)\s+(.+))?$|$', title.split(',')[0])[3].strip()
                if params.model and params.model.upper() not in title_model.upper():
                    continue
            except:
                title_model = None

            try:
                title_restyling = re.split(r'^(\S+)\s+(\S+)\s+([^·]+)((\·)\s+(.+))?$|$', title.split(',')[0])[6].strip()
            except:
                title_restyling = None

            price_primary = row[2]
            try:
                price_primary_processed = (int((''.join(x for x in row[2] if x.isdigit()))), 'byn')
            except:
                price_primary_processed = (None, 'byn')

            price_secondary = row[3]
            try:
                price_secondary_processed = (int((''.join(x for x in row[3] if x.isdigit()))), 'usd')
                if (params.price_from and price_secondary_processed[0] < int(params.price_from)) or \
                        (params.price_to and price_secondary_processed[0] > int(params.price_to)):
                    continue
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
                if (params.year_from and description_year < int(params.year_from)) or \
                        (params.year_to and description_year > int(params.year_to)):
                    continue
            except:
                description_year = None

            try:
                description_transmission = description.split('|')[0].split(',')[1].strip()
                if params.transmission and params.transmission.upper() not in description_transmission.upper():
                    continue
            except:
                description_transmission = None

            try:
                description_engine = int(''.join(x for x in description.split('|')[0].split(',')[2]if x.isdigit()) +
                                         '00')
                if (params.engine_from and description_engine < int(params.engine_from)) or \
                        (params.engine_to and description_engine > int(params.engine_to)):
                    continue
            except:
                description_engine = None

            try:
                if description_engine == 0:
                    description_fuel = description.split('|')[0].split(',')[2].strip()
                    if params.fuel and params.fuel.upper() not in description_fuel.upper():
                        continue
                else:
                    description_fuel = description.split('|')[0].split(',')[-2].strip()
                    if params.fuel and params.fuel.upper() not in description_fuel.upper():
                        continue
            except:
                description_fuel = None

            try:
                description_mileage = (int(''.join(x for x in description.split('|')[0].split(',')[-1] if x.isdigit())),
                                       'km')
                if params.mileage and description_mileage[0] > int(params.mileage):
                    continue
            except:
                description_mileage = None

            try:
                description_body = description.split('|')[1].split(',')[0].strip()
                if params.body and params.body.upper() not in description_body.upper():
                    continue
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
            try:
                exchange_processed = 'no' if 'не' in row[8] else 'yes'
                if params.exchange and params.exchange.upper() != exchange_processed.upper():
                    continue
            except:
                exchange_processed = None

            scrap_date = row[9]

            full_card = title + ' ' + price_primary + ' ' + price_secondary + ' ' + location + ' ' + labels + ' ' +\
                        comment + ' ' + description + ' ' + exchange + ' ' + scrap_date

            if params.keywords and params.keywords.upper() not in full_card.upper():
                continue

            filtered_cars.append([{'card': {'id': card_id},
                                   'title': {'deal_type': title_deal_type, 'brand': title_brand,
                                             'model': title_model, 'restyling': title_restyling},
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

    return filtered_cars


filtered_cars = parse_and_filter_file(params)


def order_and_print_top_filtered_cars(params, filtered_cars):
    """this function orders filtered cars and prints them using params
    creation date: 2023-04-08, last_update: 2023-04-08, developer: Maksym Sukhorukov"""

    print('brand\tmodel\tprice\tyear\ttransmission\tengine\tmileage\tbody\tfuel')

    filtered_cars_and_ordered = sorted(sorted(sorted(filtered_cars,
                                                     key=lambda x: x[0]['description']['mileage'][0]),
                                              key=lambda x: x[0]['description']['year'], reverse=True),
                                       key=lambda x: x[0]['price']['secondary'][0])

    counter = 0

    if len(filtered_cars_and_ordered) > 0:
        while counter < min(len(filtered_cars_and_ordered), int(params.max_records)):
            print(filtered_cars_and_ordered[counter][0]['title']['brand'] + '\t' +
                  filtered_cars_and_ordered[counter][0]['title']['model'] + '\t' +
                  str(filtered_cars_and_ordered[counter][0]['price']['secondary'][0]) + ' ' +
                  filtered_cars_and_ordered[counter][0]['price']['secondary'][1] + '\t' +
                  str(filtered_cars_and_ordered[counter][0]['description']['year']) + '\t' +
                  filtered_cars_and_ordered[counter][0]['description']['transmission'] + '\t' +
                  str(filtered_cars_and_ordered[counter][0]['description']['engine']) + '\t' +
                  str(filtered_cars_and_ordered[counter][0]['description']['mileage'][0]) + ' ' +
                  filtered_cars_and_ordered[counter][0]['description']['mileage'][1] + '\t' +
                  filtered_cars_and_ordered[counter][0]['description']['body'] + '\t' +
                  filtered_cars_and_ordered[counter][0]['description']['fuel']
                  )

            counter += 1


order_and_print_top_filtered_cars(params, filtered_cars)

