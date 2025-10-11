# https://dev.to/slotbite/installing-python-dependencies-on-aws-lambda-using-efs-1n25
# https://medium.com/picus-security-engineering/exploring-the-power-of-aws-efs-with-lambda-cc1e35f35c8a
# https://aws.amazon.com/blogs/aws/new-a-shared-file-system-for-your-lambda-functions/
# https://safezone.im/how-to-use-efs-to-store-cx_oracle-pandas-and-other-python-packages/

# https://docs.aws.amazon.com/efs/latest/ug/efs-mount-helper.html
# https://docs.aws.amazon.com/efs/latest/ug/installing-amazon-efs-utils.html#installing-efs-utils-amzn-linux

# https://repost.aws/knowledge-center/efs-access-point-configurations

# https://stackoverflow.com/questions/29857396/file-permission-meanings

# https://www.youtube.com/watch?v=FA153BGOV_A&t=174s

# https://docs.aws.amazon.com/lambda/latest/dg/configuration-vpc-internet.html

# https://www.youtube.com/watch?v=vANJzXzh6cU

# https://docs.aws.amazon.com/lambda/latest/dg/configuration-timeout.html#configuration-timeout-console

import os
import subprocess

PACKAGE_DIR = "/mnt/data/lib/{}/site-packages/"

# Generates a Python version tag like 'python3.11'
def get_python_version_tag():
    return f"python{os.sys.version_info.major}.{os.sys.version_info.minor}"

# Installs a Python package into the EFS-mounted directory
def install_package(package):
    target_dir = PACKAGE_DIR.format(get_python_version_tag())
    os.makedirs(target_dir, exist_ok=True)
    try:
        subprocess.run(
            [
                "pip",
                "install",
                package,
                "--target",
                target_dir,
                "--upgrade",
                "--no-cache-dir",
            ],
            check=True,
        )
        print(f"Package {package} installed successfully!")
    except subprocess.CalledProcessError as e:
        print(f"Failed to install package {package}: {e}")

# AWS Lambda Handler for installing packages
def lambda_handler(event, context):
    try:
        # List of packages to install from the event input
        packages = event.get("packages", [])
        for package in packages:
            install_package(package)
        # Optional for see packages installed
        # os.system(f"ls -la {PACKAGE_DIR.format(get_python_version_tag())}")
        return {"statusCode": 200, "body": "Packages installed successfully!"}
    except Exception as e:
        print(f"Error: {e}")
        return {"statusCode": 500, "body": f"An error occurred: {e}"}
