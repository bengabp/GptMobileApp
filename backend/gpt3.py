import openai

class GPT3:
    def __init__(self, api_key="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"):
        openai.api_key = api_key
        self.prompt_text = "Act as an AI Assistant with knowledge of ChatGPT"

    def generate_text(self, prompt, temperature=0.9, max_tokens=512):
        completions = openai.Completion.create(
            engine="text-davinci-003",
            prompt=f"{self.prompt_text} {prompt}",
            temperature=temperature,
            max_tokens=max_tokens,
            top_p=0.8,
            frequency_penalty=0.3,
            presence_penalty=0
        )

        message = completions.choices[0].text
        return message.strip()
