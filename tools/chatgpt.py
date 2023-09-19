import openai

# Substitua 'YOUR_API_KEY' pela sua chave de API da OpenAI
api_key = "YOUR_API_KEY"

# Função para interagir com o ChatGPT
def chat_with_gpt(question):
    openai.api_key = api_key
    response = openai.Completion.create(
        engine="text-davinci-002",  # Motor de geração de texto
        prompt=question + "\nAnswer:",  # O prompt da pergunta
        max_tokens=50,  # Número máximo de tokens na resposta
    )
    return response.choices[0].text.strip()

# Loop para interagir continuamente com o ChatGPT
while True:
    user_input = input("Você: ")
    if user_input.lower() == "sair":
        break
    response = chat_with_gpt(user_input)
    print("ChatGPT:", response)

