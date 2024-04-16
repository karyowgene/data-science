import pykew.powo as powo
from pykew.powo_terms import Geography
from pykew.powo_terms import Filters
import re

countries = ['Country1', 'Country2', 'Country3', 'Country4', 'Country5']
for country in countries:
    query = {Geography.distribution: country}
    res = powo.search(query, filters = [Filters.accepted, Filters.species])
    fqid = []
    for r in res:
        snippet = re.sub('<[^<]+?>', '', r.get('snippet'))
        fqid.append(r.get('fqId'))
        for spid in fqid: 
            rlookup = powo.lookup(spid, include=['distribution'])
            native_to = [d['name'] for d in rlookup['distribution']['natives']]
            if all(country in native_to for country in countries):
                print(r.get('name'),r.get('author'),snippet)