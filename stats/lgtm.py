#!/usr/local/bin/python3

import re
import requests
import argparse
import sys
import json
import os
import glob
import csv
import time
from pprint import pprint

# projectKeys='[1506524326358,5629499534213120,39700035,1977701350,1873830050,1862920424,1864641207,1877441651,48190073,1505960736188,1505958786078,1879540065,1506178136997,1981031959,1879370025,1874822090,1790840019,1864280925,41633751,1876381512,12760012,41900048,1354020033,1505967666111,1867300198,1795210073,1505968065973,1862771155,940125,2033800529,11020029,1505958645990,7870148,1861351166,1977291520,1978970761,1983122555,2161760237,1859762138,2035290917,1883290288,6890001,1981271240,1864352334,1979491471,1860005,13140029,24100035,35820136,1875601332,48640041,1877370912,1869242377,1872920090,1859802304,1973732641,1867040683,7880116,1971931877,33010046,18080071,1920002,1882261774,1855931308,1882380719,48790008,1505950676906,4870147,1860497242,1860885457,1883110029,1863051015,49820009,122244312,1861232120,1869270619,4850066,1872820788,6780442,1506173707109,1506179906986,32470022,1874830030,1971780069,1968931653,1856951538,1908860284,1861491397,1884210730,1867130795,15070006,1798270110,46050017,1983122556,1856772013,35820134,1866091663,7860138,1866211423,1506494716249,1505959776000,1880610249,1854901091,28741840,1972891707,6810158,1866061568,1982361113,1883200014,1505956416964,33815278,1869251537,1863190961,1874861017,1506700246764,1880570060,1863170850,1876500483,1873950073,1978970753,1878460091,1863001776,1874820078,7870357,10190041,1877480006,27300077,37220006,1882220728,1860774854,1977502912,1796321258,1877840310,2032670435,10130004,1971742352,1867160838,2980123,1878170062,1506502526259,1987320554,1505955227120,1862301883,1854881430,4840137,1507321416063,16030025,1505967225983,1855701520,1864150769,1859473908,1505958176673,2980106,1505964916170,1863840499,42360304,1984120998,1791770031,1506178546734,1856921186,1856830886,23842748,1506177197587,1857631417,1985420889,12170495,1861920745,1878800409,46290061,1860885493,1863511591,1876470319,3980080,17445104,5990306,1791430060,1344240419,1863420972,7870349,7890422,30640057,22650009,930029,1978821253,1868250766,1797370124,1973531692,7850125,1883460971,1984082076,1874820076,1874870633,20820034,30360001]'
# projectKeys='[25620005,41710041,1878521151,10560012,28580018,5629499534213120,39700035,1977701350,1873830050,1862920424,1864641207,1877441651,48190073,1506524326358,1505958786078,1506178136997,1981031959,1879370025,1874822090,1790840019,1864280925,41633751,1876381512,12760012,41900048,1354020033,1505967666111,1867300198,1795210073,1505968065973,1862771155,940125,2033800529,11020029,1505958645990,7870148,1861351166,1977291520,1978970761,1983122555,2161760237,1859762138,2035290917,1883290288,6890001,1981271240,1864352334,1979491471,1860005,13140029,24100035,35820136,1875601332,48640041,1877370912,1869242377,1872920090,1859802304,1973732641,1867040683,7880116,1971931877,33010046,18080071,1920002,1882261774,1855931308,1882380719,48790008,1505950676906,4870147,1860497242,1860885457,1883110029,1863051015,49820009,122244312,1861232120,1869270619,4850066,1872820788,6780442,1506173707109,1506179906986,32470022,1874830030,1797540044,1971780069,1968931653,1856951538,1908860284,1861491397,1884210730,1867130795,15070006,1798270110,46050017,1983122556,1856772013,35820134,1866091663,7860138,1866211423,1506494716249,1860946741,1505959776000,1880610249,1854901091,28741840,1972891707,6810158,1866061568,1982361113,1883200014,1505956416964,33815278,1869251537,1863190961,1874861017,1880570060,1863170850,1876500483,1873950073,1978970753,1878460091,1863001776,1874820078,7870357,10190041,1877480006,27300077,37220006,1882220728,1860774854,1977502912,1796321258,1877840310,2032670435,10130004,1971742352,1867160838,2980123,1878170062,1506502526259,1987320554,1862301883,1854881430,4840137,16030025,1505967225983,1855701520,1864150769,1859473908,1505958176673,2980106,1505964916170,1863840499,42360304,1984120998,1791770031,1506178546734,1856921186,1856830886,23842748,1506177197587,1857631417,1985420889,12170495,1861920745,1878800409,1860885493,1863511591,1876470319,3980080,17445104,5990306,1791430060,1344240419,1863420972,7870349,7890422,30640057,22650009,930029,1978821253,1868250766,1797370124,1973531692,7850125,1883460971,1984082076,1874820076,1874870633,20820034,30360001]'
# projectKeys='[25620005,41710041,1878521151,1506524326358]'

with open('pks.list') as f:
    projectKeys = f.read()

def init():
    r = requests.get("https://lgtm.com/query")
    nonce = re.compile('nonce: "(\\w+)"').findall(r.text)[0]
    print('nonce:', nonce)

    apiVersion = re.compile('<div id="preloaded_content" data-api-version=(\\w+)>').findall(r.text)[0]
    print('apiVersion:', apiVersion)

    cookies = r.cookies
    print('cookies:', cookies)

    return (nonce, apiVersion, cookies)

def runQuery(filename, t, projectKeys):
    print("[Running Query '%s' ... ]" % filename, file=sys.stderr)

    with open(filename) as f:
        ql = f.read()

    r = requests.post("https://lgtm.com/internal_api/v0.2/runQuery",
                  data={
                          'lang': 'java',
                          'projectKeys': projectKeys,
                          'queryString': ql,
                          'guessedLocation': "",
                          'nonce': t[0],
                          'apiVersion': t[1]
                      }, cookies=t[2])
    print(r.text)
    return r

def getProjectsByKey(keys, t):
    print("[Getting Projects by Key]", file=sys.stderr)

    r = requests.get("https://lgtm.com/internal_api/v0.2/getProjectsByKey", stream=True, params = {
        'keys': keys,
        'nonce': t[0],
        'apiVersion': t[1]
    }, cookies=t[2])
    return r

def getCustomQueryRunResults(filename, t):
    print("[Getting Query Run Results from '%s' ... ]" % filename, file=sys.stderr)

    with open(filename) as f:
        runtext = f.read()

    js = json.loads(runtext)

    queryKey = js['data']['key']
    print("[Query Key '%s' ... ]" % queryKey, file=sys.stderr)
    os.system('mkdir -pv .lgtm/' + queryKey)
    os.system('ln -sfv %s/ .lgtm/last-results' % queryKey)

    for run in js['data']['runs']:
        key = run['key']
        print("[Query Run Results Key '%s' ... ]" % key, file=sys.stderr)

        r = requests.get("https://lgtm.com/internal_api/v0.2/getCustomQueryRunResults", params = {
            'startIndex': 0,
            'count': 3,
            'unfiltered': 'false',
            'queryRunKey': key,
            'nonce': t[0],
            'apiVersion': t[1]
        }, cookies=t[2])

        if r.status_code == 200:
            js = json.loads(r.text)
            outjson = json.dumps(js, indent=2)
            outfilename = '.lgtm/' + queryKey + '/' + key + '.json'
            with open(outfilename, 'w') as outfile:
                print("Writing results file:", outfilename)
                outfile.write(outjson)
        else:
            raise Warning(r, r.text)

if __name__ == '__main__':
    parser = argparse.ArgumentParser(description='Run QL query.')
    parser.add_argument('action', choices=['pk', 'checkpk', 'runpks', 'run', 'results', 'csv'])
    args = parser.parse_args()

    if args.action == 'pk':
        t = init()

        with open("all-casts-run.json") as f:
            text = f.read()
        js = json.loads(text)

        pks = ""
        i = 0
        for run in js['data']['runs']:
            pk = run['projectKey']
            if pks == "":
                pks += pk
            else:
                pks += "," + pk
            
            if len(pks) > 10000:
                r = getProjectsByKey('['+pks+']', t)
                pks = ""

                with open('pks-' + str(i) + '.json', 'w') as f:
                    print("Writing json project keys")
                    f.write(r.text)
                    i += 1
        
        if len(pks) > 0:
            r = getProjectsByKey('['+pks+']', t)
            with open('pks-' + str(i) + '.json', 'w') as f:
                print("Writing json project keys")
                f.write(r.text)

    elif args.action == 'checkpk':
        pks = []
        for path in glob.iglob('pks-*.json'):
            with open(path) as f:
                jsontext = f.read()
            js = json.loads(jsontext)
            for p in js['data']['fullProjects']:
                print(p)
                pks.append(p)

        with open('pks.list', 'w') as f:
            f.write("[" + ",".join(pks) + "]")

        # with open("pks.list") as f:
            # keys = f.read()
        # keys = '[2035560523,2032380248,2027960546,12,2034290425,123,1506125455972,12345,1506123436363]'
        # t = init()
        # r = getProjectsByKey(keys, t)
        # print(r.text)
    elif args.action == 'runpks':
        t = init()

        with open("all-casts-run.json") as f:
            text = f.read()
        js = json.loads(text)

        pks = ""
        i = 0

        with open('pks.csv', 'w', newline='') as csvfile:
            w = csv.writer(csvfile, delimiter=',', quotechar='"', quoting=csv.QUOTE_NONNUMERIC)
            w.writerow(['pk', 'status_code'])
            for run in js['data']['runs']:
                pk = run['projectKey']
                r = runQuery('stats.ql', t, '['+pk+']')
                w.writerow([pk, r.status_code])
                print(pk, r.status_code, r.reason)
                time.sleep(1)

    elif args.action == 'run':
        t = init()
        r = runQuery('stats.ql', t, projectKeys)
        print("[Status Code: %s (%s)]" % (r.status_code, r.reason), file=sys.stderr)

        if r.status_code == 200:
            js = json.loads(r.text)
            queryKey = js['data']['key']
            print("Query Key:", queryKey)

            outjson = json.dumps(js, indent=2)
            outfilename = '.lgtm/' + queryKey + '.json'
            with open(outfilename, 'w') as outfile:
                print("Writing run query file:", outfilename)
                outfile.write(outjson)

            print("Writing symlink to run query file")
            os.system('ln -sfv %s .lgtm/last-run.json' % (queryKey + '.json'))

            print("Query Link:", 'https://lgtm.com/query/' + queryKey)
        else:
            raise Warning(r, r.text)

    elif args.action == 'results':
        t = init()
        getCustomQueryRunResults('.lgtm/last-run.json', t)
    elif args.action == 'csv':
        for path in glob.iglob('.lgtm/last-results/*.json'):
            print(path)

            with open(path) as f:
                jstext = f.read()
            js = json.loads(jstext)

            name, ext = os.path.splitext(path)
            csvfilename = name + '.csv'

            with open(csvfilename, 'w', newline='') as csvfile:
                print("Writing csv results file:", csvfilename)
                w = csv.writer(csvfile, delimiter=',', quotechar='"', quoting=csv.QUOTE_NONNUMERIC)
                w.writerow(js['data']['metadata']['columns'])
                for row in js['data']['rows']:
                    w.writerow(list(map(lambda c: c['label'], row)))