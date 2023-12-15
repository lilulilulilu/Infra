import requests

def format_prompt(prompt: str) -> str:
    return f'Instruct:{prompt}\nOutput:'


def ask_phi2(query: str) -> str:
    url = "http://localhost:6001/generate"
    body = {
        "query": format_prompt(query)
    }
    headers = {"Content-Type": "application/json"}
    response = requests.post(url=url, json=body, headers=headers)
    return response.json()['answer']

def chat_with_phi2(conversations: str) -> str:   
    url = "http://localhost:6001/generate"
    body = {
        "query": conversations
    }
    headers = {"Content-Type": "application/json"}
    response = requests.post(url=url, json=body, headers=headers)
    return response.json()['answer']


if __name__ == '__main__': 
    query = "Imagine you are my mom, please answer my question concisely: who are you?"
    answer = ask_phi2(query)
    print(f'answer:{answer}')
    
    conversations = '''
    Alice: I don't know why, I'm struggling to maintain focus while studying. Any suggestions?
    Bob: Well, have you tried creating a study schedule and sticking to it?
    Alice: Yes, I have, but it doesn't seem to help much.
    Bob: Hmm, maybe you should try studying in a quiet environment, like the library.
    Alice: That's a good idea. I'll give it a try. Thanks, Bob!
    Bob: '''
    answer2 = chat_with_phi2(conversations)
    print(f'conversations:{answer2}')