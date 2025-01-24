from setuptools import setup, find_packages

def parse_requirements(file_path):
    with open(file_path) as f:
        return f.read().splitlines()

setup(
    name="mathy_repo",              
    version="0.1.0",               
    description="A project for the math enthusiasts",
    long_description=open("README.md").read(),
    long_description_content_type="text/markdown",
    author="Iker Caballero Bragagnini",
    author_email="ikercb2000@gmail.com",
    packages=find_packages(include=["pkg_*", "pkg_*.*"]),
    classifiers=[
        "Programming Language :: Python :: 3",
        "License :: OSI Approved :: MIT License",
        "Operating System :: OS Independent",
    ],
    python_requires='>=3.10',
)
