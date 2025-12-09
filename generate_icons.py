import os
import sys
import json
from PIL import Image

def generate_icons(source_image_path):
    if not os.path.exists(source_image_path):
        print(f"Error: Source image '{source_image_path}' not found.")
        print("Please save your icon image as 'icon.png' in this folder.")
        return

    iconset_path = "TypeStream/Assets.xcassets/AppIcon.appiconset"
    if not os.path.exists(iconset_path):
        os.makedirs(iconset_path)

    # Define the required sizes and scales
    # (size, scale, filename_suffix)
    # size is the point size. pixel size = size * scale
    images_config = [
        (16, 1, "16x16"),
        (16, 2, "16x16@2x"),
        (32, 1, "32x32"),
        (32, 2, "32x32@2x"),
        (128, 1, "128x128"),
        (128, 2, "128x128@2x"),
        (256, 1, "256x256"),
        (256, 2, "256x256@2x"),
        (512, 1, "512x512"),
        (512, 2, "512x512@2x")
    ]

    try:
        original_image = Image.open(source_image_path)
        # Ensure it's square
        if original_image.width != original_image.height:
            print("Warning: Image is not square. It will be resized/cropped.")
        
        # Use high quality resampling
        resample_filter = Image.Resampling.LANCZOS

        contents_images = []

        for size, scale, suffix in images_config:
            pixel_size = size * scale
            filename = f"icon_{suffix}.png"
            file_path = os.path.join(iconset_path, filename)
            
            print(f"Generating {filename} ({pixel_size}x{pixel_size})...")
            
            resized_image = original_image.resize((pixel_size, pixel_size), resample_filter)
            resized_image.save(file_path, "PNG")

            contents_images.append({
                "size": f"{size}x{size}",
                "idiom": "mac",
                "filename": filename,
                "scale": f"{scale}x"
            })

        # Write Contents.json
        contents_json = {
            "images": contents_images,
            "info": {
                "version": 1,
                "author": "xcode"
            }
        }

        with open(os.path.join(iconset_path, "Contents.json"), "w") as f:
            json.dump(contents_json, f, indent=2)

        print("Success! App icons generated and Contents.json updated.")

    except Exception as e:
        print(f"An error occurred: {e}")

if __name__ == "__main__":
    generate_icons("icon.png")
