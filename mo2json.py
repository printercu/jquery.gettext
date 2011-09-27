#!/usr/bin/env python
try:
    import json
except:
    import simplejson as json
import gettext
import sys


def gettext_json(domain, path, lang=[], indent=False):
    tr = gettext.translation(domain, path, lang)
    # for unknown reasons, instead of having plural entries like
    # key: [sg, pl1...]
    # tr._catalog has (key, n): pln,
    keys = tr._catalog.keys()
    keys.sort()
    ret = {}
    for k in keys:
        v = tr._catalog[k]
        if type(k) is tuple:
            if k[0] not in ret:
                ret[k[0]] = []
            ret[k[0]].append(v)
        else:
            ret[k] = v
    return json.dumps(ret, ensure_ascii=False, indent=indent)


def main():
    domain, path, locale, filename = sys.argv[1:]
    result = gettext_json(domain, path, [locale])
    fileout = open(filename, "w")
    fileout.write(result)
    fileout.close()


if __name__ == "__main__":
    main()
