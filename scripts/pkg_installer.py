# External modules

import os
import subprocess
import sys

# Install packages function

def install_local_packages(base_dir):
    """
    Installs all local packages (folders starting with 'pkg_') in editable mode.
    """
    items = os.listdir(base_dir)
    packages = [item for item in items if item.startswith('pkg_') and os.path.isdir(os.path.join(base_dir, item))]

    if not packages:
        print("No local packages found.")
        return

    print(f"Found packages: {packages}")

    for package in packages:
        package_path = os.path.join(base_dir, package)
        requirements_file = os.path.join(package_path, "requirements.txt")

        print(f"Processing {package}...")
        install_requirements(requirements_file)
        print(f"Installing {package} in editable mode...")
        try:
            subprocess.check_call([sys.executable, "-m", "pip", "install", "-e", package_path])
            print(f"Successfully installed {package}.")
        except subprocess.CalledProcessError as e:
            print(f"Failed to install {package}. Error: {e}")

# Install Requirements Function

def install_requirements(requirements_file):
    """
    Installs dependencies from a requirements.txt file.
    """
    if os.path.exists(requirements_file):
        print(f"Installing dependencies from {requirements_file}...")
        try:
            subprocess.check_call([sys.executable, "-m", "pip", "install", "-r", requirements_file])
            print("Successfully installed dependencies.")
        except subprocess.CalledProcessError as e:
            print(f"Failed to install dependencies. Error: {e}")
    else:
        print(f"No requirements.txt found in {os.path.dirname(requirements_file)}. Skipping dependencies installation.")

# Run function

if __name__ == "__main__":

    script_dir = os.path.dirname(os.path.abspath(__file__))
    base_dir = os.path.abspath(os.path.join(script_dir, ".."))
    install_local_packages(base_dir)


# TODO: Cambiar para que se instale solo el paquete que uno quiere en un proyecto o carpeta debida