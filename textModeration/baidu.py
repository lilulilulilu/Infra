import requests
import time

API_KEY = "LAW6S0eIUZVtcsn"
SECRET_KEY = "oasuN3ieq5QaA9lFKRlPI"

def main():
    start_time = time.time()
    url = "https://aip.baidubce.com/rest/2.0/solution/v1/text_censor/v2/user_defined?access_token=" + get_access_token()
    
    payload={'text':"尼玛"}
    headers = {
        'Content-Type': 'application/x-www-form-urlencoded',
        'Accept': 'application/json'
    }
    
    response = requests.request("POST", url, headers=headers, data=payload)
    end_time = time.time()
    execution_time = end_time - start_time
    print(f"The code executed in {execution_time} seconds.")
    print(response.text)
    

def get_access_token():
    """
    使用 AK，SK 生成鉴权签名（Access Token）
    :return: access_token，或是None(如果错误)
    """
    url = "https://aip.baidubce.com/oauth/2.0/token"
    params = {"grant_type": "client_credentials", "client_id": API_KEY, "client_secret": SECRET_KEY}
    return str(requests.post(url, params=params).json().get("access_token"))

if __name__ == '__main__': 
    main()