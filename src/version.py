import tomli


def get_version():
    with open('stub.toml', 'rb') as file:
        package_details = tomli.load(file)
    return package_details['tool']['poetry']['version']


if __name__ == '__main__':
    result = get_version()
    print(result)
