#!/usr/bin/python
import argparse
import load_tokens
import requests

parser = argparse.ArgumentParser(description='create repository in github')
parser.add_argument('-t', '--token', type=str,
                    help='specify github user token')
parser.add_argument('-u', '--username', type=str,
                    help='specify the github username', required=True)
parser.add_argument('-n', '--repo-name', type=str,
                    help='specify the repository name', required=True)
parser.add_argument('-d', '--repo-desc', type=str,
                    help='specify the repository description if not given description same as name')
parser.add_argument('-p', '--is-private',
                    help='repository visibility status:[True/False]', type=bool)
parser.add_argument('-f', '--env-file-location', type=str,
                    help='env file location that contains token', default='/home/mal1kc/scripts/.env')


def get_token():
    if parsed_args.token != None:
        return parsed_args.token
    return load_tokens.get_env('GHUB_TOKEN', parsed_args.env_file_location)


def get_repo_visibility():
    if parsed_args.is_private == None:
        return True
    return parsed_args.is_private


if __name__ == '__main__':
    print('operation started')
    parsed_args = parser.parse_args()

    # print(f' username - {parsed_args.username}\n repo name - {parsed_args.repo_name}\n repo description - {parsed_args.repo_desc}')
    token = get_token()

    is_private_repo = get_repo_visibility()

    data = {'name': parsed_args.repo_name,
            'description': (parsed_args.repo_desc if parsed_args != None else parsed_args.repo_name),
            'private': is_private_repo
            }
    r = requests.post('https://api.github.com/user/repos',
                      json=data, auth=(parsed_args.username, token))
    if r.status_code == 201:
        print(
            f'operation successfully completed repo adress -> {r.json()["html_url"]}')
    else:
        print(f'operation status code : {r.status_code}')
