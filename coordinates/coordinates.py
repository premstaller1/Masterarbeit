#transform adresses into coordinates
import requests
import json
import pandas as pd
import numpy as np
import time

#function to get coordinates from address
def get_coordinates(address):
    url = 'https://maps.googleapis.com/maps/api/geocode/json?address=' + address + '&key=AIzaSyD4C8X
    response = requests.get(url)
    data = response.json()
    lat = data['results'][0]['geometry']['location']['lat']
    lng = data['results'][0]['geometry']['location']['lng']
    return lat, lng

#function to get coordinates from a list of addresses
def get_coordinates_list(addresses):
    lats = []
    lngs = []
    for address in addresses:
        lat, lng = get_coordinates(address)
        lats.append(lat)
        lngs.append(lng)
        time.sleep(1)
    return lats, lngs

#import adress data
data = pd.read_csv('data.csv')
addresses = data['address'].values

#transform addresses into coordinates
lats, lngs = get_coordinates_list(addresses)