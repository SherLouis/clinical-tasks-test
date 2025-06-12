import os
import requests

# Structure des tests avec noms de fichiers et URLs d'exemple

test_data = {
    "Fruits": {
        "pommes.jpg": "https://upload.wikimedia.org/wikipedia/commons/1/15/Red_Apple.jpg",
        "bananes.jpg": "https://upload.wikimedia.org/wikipedia/commons/8/8a/Banana-Single.jpg",
        "fraises.jpg": "https://upload.wikimedia.org/wikipedia/commons/2/29/PerfectStrawberry.jpg",
        "raisins.jpg": "https://upload.wikimedia.org/wikipedia/commons/1/13/20130929_Grapes_Laura.jpg",
        "oranges.jpg": "https://upload.wikimedia.org/wikipedia/commons/c/c4/Orange-Fruit-Pieces.jpg",
    },
    "Bureau": {
        "stylo.jpg": "https://upload.wikimedia.org/wikipedia/commons/0/00/Ballpoint_pen_example.jpg",
        "cahier.jpg": "https://upload.wikimedia.org/wikipedia/commons/a/a9/Notebook.jpg",
        "agrafeuse.jpg": "https://upload.wikimedia.org/wikipedia/commons/6/67/Agrafeuse.jpg",
        "clavier.jpg": "https://upload.wikimedia.org/wikipedia/commons/e/e4/Apple_Keyboard_with_Numeric_Keypad_USA.jpg",
        "souris.jpg": "https://upload.wikimedia.org/wikipedia/commons/5/52/Computer_mouse.jpg",
    },
    "Logos": {
        "google.jpg": "https://upload.wikimedia.org/wikipedia/commons/2/2f/Google_2015_logo.svg",
        "apple.jpg": "https://upload.wikimedia.org/wikipedia/commons/f/fa/Apple_logo_black.svg",
        "microsoft.jpg": "https://upload.wikimedia.org/wikipedia/commons/9/96/Microsoft_logo_%282012%29.svg",
        "amazon.jpg": "https://upload.wikimedia.org/wikipedia/commons/a/a9/Amazon_logo.svg",
        "facebook.jpg": "https://upload.wikimedia.org/wikipedia/commons/5/51/Facebook_f_logo_%282019%29.svg",
    },
    "Personnalites": {
        "einstein.jpg": "https://upload.wikimedia.org/wikipedia/commons/d/d3/Albert_Einstein_Head.jpg",
        "obama.jpg": "https://upload.wikimedia.org/wikipedia/commons/8/8d/President_Barack_Obama.jpg",
        "beyonce.jpg": "https://upload.wikimedia.org/wikipedia/commons/9/9c/Beyonce_Knowles_with_necklace.jpg",
        "elon.jpg": "https://upload.wikimedia.org/wikipedia/commons/e/ed/Elon_Musk_Royal_Society.jpg",
        "marilyn.jpg": "https://upload.wikimedia.org/wikipedia/commons/9/9d/Marilyn_Monroe%2C_Korea%2C_1954.jpg",
    },
}

output_dir = "images"
headers = {
    "User-Agent": "CoolBot/0.0 (https://example.org/coolbot/; coolbot@example.org)"
}

# Crée les dossiers et télécharge les images
for category, files in test_data.items():
    folder = os.path.join(output_dir, category)
    os.makedirs(folder, exist_ok=True)
    for filename, url in files.items():
        filepath = os.path.join(folder, filename)
        print(f"Downloading {filename}...")
        try:
            response = requests.get(url, headers=headers)
            response.raise_for_status()
            with open(filepath, "wb") as f:
                f.write(response.content)
        except Exception as e:
            print(f"Erreur pour {filename}: {e}")

print("✅ Téléchargement terminé.")
