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
        json.dump(file, f, indent=4, sort_keys=True)

def open_json(path):
    with open(path, 'r') as f:
        return json.load(f)

def print_json(parsed):
    print(json.dumps(parsed, indent=4, sort_keys=True))

def lookup_metadata(title):
    # Retrieve the appropriate title (dict may be manually modified to correct titles)
    # Generate entry title->title in dict if does not exist
    meta = dict()
    try:
        meta = open_json('metadata.json')
    except FileNotFoundError:
        # doesn't exist
        meta = dict()
    if 'title' not in meta:
        meta['title'] = dict()
    if title not in meta['title']:
        meta['title'][title] = {
            'title': title,
            'author': '??'
        }
    save_json(meta, f'metadata.json')
    return meta['title'][title]

def lookup_author(author):
    # Retrieve the appropriate author from their initials
    # Generate entry author->author in dict if does not exist
    meta = dict()
    try:
        meta = open_json('metadata.json')
    except FileNotFoundError:
        # doesn't exist
        meta = dict()
    if 'author' not in meta:
        meta['author'] = dict()
    if author not in meta['author']:
        meta['author'][author] = author
    save_json(meta, f'metadata.json')
    return meta['author'][author]