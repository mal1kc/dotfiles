#!/usr/bin/python
from typing import List
import re


def get_all_envs(env_file_path: str) -> dict[str:str]:
    pattern = re.compile('([\S]+=["\'].+["\']|[\S]+=[\S]+)')
    with open(env_file_path) as env_file:
        lines = env_file.read()
    raw: List = pattern.findall(lines)
    envs = {}
    for i in raw:
        splitted_env = i.split('=')
        envs[splitted_env[0]] = splitted_env[1].strip('"')
    return envs


def get_env(env_name: str,env_file_path:str) -> str:
    all_env = get_all_envs(env_file_path)
    return all_env[env_name]

if __name__ == '__main__':
    # some tests
    print(get_all_envs('~/scripts/.env'))
    print(get_env('GHUB_TOKEN', '.env'))