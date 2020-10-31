import json
import csv

PATHS = {
    'html': 'view/',
    'json': 'view/data/',
    'users': 'all_users.txt'
}

def open_file(path):
    with open(path, 'rb') as f:
        return f.read()

def save_json(file, path):
    with open(path, 'w', encoding='utf-8') as f:
        json.dump(file, f)

def open_json(path):
    with open(path, 'r') as f:
        return json.load(f)

def print_json(parsed):
    print(json.dumps(parsed, indent=4, sort_keys=True))

def lookup_title(title):
    # Retrieve the appropriate title (dict may be manually modified to correct titles)
    # Generate entry title->title in dict if does not exist
    meta = dict()
    try:
        meta = open_json('metadata.json')
    except FileNotFoundError:
        # doesn't exist
        meta = dict()
    if title in meta['title']:
        return meta['title'][title]
    else:
        if 'title' not in meta:
            meta['title'] = dict()
        meta['title'][title] = title
        save_json(meta, f'metadata.json')
        return title