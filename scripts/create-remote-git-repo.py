#!/usr/bin/python
import argparse
import load_tokens
import requests

parser = argparse.ArgumentParser(description="create repository in github")
parser.add_argument("-t", "--token", type=str, help="specify github user token")
parser.add_argument(
    "-u", "--username", type=str, help="specify the github username", required=True
)
parser.add_argument(
    "-n", "--repo-name", type=str, help="specify the repository name", required=True
)
parser.add_argument(
    "-d",
    "--repo-desc",
    type=str,
    help="specify the repository description if not given description same as name",
)
parser.add_argument(
    "-p", "--is-private", help="repository visibility status:[True/False]", type=bool
)
parser.add_argument(
    "-f",
    "--env-file-location",
    type=str,
    help="env file location that contains token",
    default="/home/mal1kc/scripts/.env",
)
parser.add_argument(
    "-o",
    "--organisation",
    type=str,
    help="organisation name if user wants to create organisation repo",
    default=None,
)
parser.add_argument(
    "-r", "--remote", type=str, help="specify the remote name", default="github"
)

API_URL = "{remote_url}/api/v1/user/repos"
API_URL_ORG = "{remote_url}/api/v1/orgs/{org}/repos"


def get_token(token_key: str):
    if parsed_args.token is not None:
        return parsed_args.token
    return load_tokens.get_env(token_key, parsed_args.env_file_location)


def get_repo_visibility():
    if parsed_args.is_private is None:
        return True
    return parsed_args.is_private


if __name__ == "__main__":
    print("operation started")
    parsed_args = parser.parse_args()
    remote_name = parsed_args.remote
    # print("remote name - ", remote_name)

    match remote_name:
        case ["gitdemlik" | "homelab"]:
            token_key = "GDEMLIK_TOKEN"
            endpoint = "http://homelab:3000"
            print("using homelab endpoint")
        case ["wdesktop" | "wdesktop-gitdemlik" | "wgitdemlik"]:
            token_key = "WGDEMLIK_TOKEN"
            endpoint = "http://wdesktop:3000"
            print("using wdesktop endpoint")
        case ["github" | "gthub" | "ghub"]:
            token_key = "GITHUB_TOKEN"
            endpoint = "https://api.github.com"
            print("using github endpoint")
        case _:
            token_key = "WGDEMLIK_TOKEN"
            endpoint = "http://wdesktop:3000"
            print("using wdesktop endpoint")

    # print(
    #     f" username - {parsed_args.username}\n repo name - {parsed_args.repo_name}\n repo description - {parsed_args.repo_desc}"
    # )
    token = get_token(token_key)

    is_private_repo = get_repo_visibility()

    data = {
        "name": parsed_args.repo_name,
        "description": (
            parsed_args.repo_desc if parsed_args is not None else parsed_args.repo_name
        ),
        "private": is_private_repo,
    }
    if parsed_args.organisation is None:
        r = requests.post(
            API_URL.format(remote_url=endpoint),
            json=data,
            auth=(parsed_args.username, token),
        )
        if r.status_code == 201:
            print(
                f"operation successfully completed repo adress ->\n {r.json()['html_url']} \n {r.json()['html_url'].replace('https://', 'git@').replace('.com/', '.com:') + '.git'}"
            )
        else:
            print(f"operation status code : {r.status_code}")
    else:
        r = requests.post(
            API_URL_ORG.format(remote_url=endpoint, org=parsed_args.organisation),
            json=data,
            auth=(parsed_args.username, token),
        )
        if r.status_code == 201:
            print(
                f"operation successfully completed repo adress ->\n {r.json()['html_url']} \n {r.json()['html_url'].replace('https://', 'git@').replace('.com/', '.com:') + '.git'}"
            )
        else:
            print(
                API_URL_ORG.format(remote_url=endpoint, org=parsed_args.organisation),
                "\n",
                data,
                "\n",
                (parsed_args.username, token),
                "\n",
            )
            print(f"operation status code : {r.status_code}")
