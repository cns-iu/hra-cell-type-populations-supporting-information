import requests
import json

def get_data(endpoint):
    """A method to retrieve data

    Args:
        endpoint (string): The URL of the endpoint
    """
    f = open('github_access_token.txt', 'r')
    
    # You need a token to get this raw GitHub content from the endpoint. I suggest storing the token in a separate text file and adding it to gitignore
    TOKEN = f.readline()
    headers = {"Authorization": "Bearer " + TOKEN}
    data = requests.get(endpoint, headers=headers).json()
    return data
