"""
Create index.html for parcel list.
"""

from os.path import join, relpath, curdir
from glob import glob
import sys

def create_index(startpath):
    parcels = [relpath(x, startpath) for x in glob(join(startpath, '*.parcel'))]

    html = """<html>
<head>
    <title>Parcels</title>
</head>
<body>
"""

    for parcel in parcels:
        html += '    <p><a href="{}">{}</a></p>\n'.format(parcel, parcel)


    html += """    <p><a href="manifest.json">manifest.json</a></p>
</body>
</html>
    """

    return html

if __name__ == "__main__":
    target_path = curdir
    if len(sys.argv) > 1:
        target_path = sys.argv[1]
    print("Creating index.html for: %s" % (target_path))

    index_html = create_index(target_path)
    with open(join(target_path, 'index.html'), 'w') as fp:
        fp.write(index_html)
    