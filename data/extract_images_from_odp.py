import zipfile
import os
import shutil
import xml.etree.ElementTree as ET


def extract_odp_images(odp_file, output_dir):
    os.makedirs(output_dir, exist_ok=True)

    with zipfile.ZipFile(odp_file, "r") as z:
        # Parse content.xml for slide/image order
        with z.open("content.xml") as f:
            tree = ET.parse(f)
            root = tree.getroot()

        # ODF uses namespaces
        ns = {
            "draw": "urn:oasis:names:tc:opendocument:xmlns:drawing:1.0",
            "xlink": "http://www.w3.org/1999/xlink",
            "presentation": "urn:oasis:names:tc:opendocument:xmlns:presentation:1.0",
        }

        slide_num = 0
        image_names = []

        for page in root.findall(".//draw:page", ns):
            slide_num += 1
            # find first image in this slide
            image = page.find(".//draw:image", ns)
            if image is not None:
                href = image.attrib["{http://www.w3.org/1999/xlink}href"]
                if href.startswith("Pictures/"):
                    out_name = f"{slide_num}.png"
                    out_path = os.path.join(output_dir, out_name)

                    # copy from zip
                    with z.open(href) as src, open(out_path, "wb") as dst:
                        shutil.copyfileobj(src, dst)

                    image_names.append(out_name)

        # Print just the file names
        for name in image_names:
            print(name)

        print(f"✅ Extracted {len(image_names)} images to {output_dir}")
        return image_names


# Example usage
extract_odp_images("in/Test des personnages célèbres_AL.pptx.odp", "out/famous_faces")
