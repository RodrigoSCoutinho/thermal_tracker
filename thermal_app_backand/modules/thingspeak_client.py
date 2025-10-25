# modules/thingspeak_client.py
import urequests

class ThingSpeakClient:
    def __init__(self, api_key):
        self.api_key = api_key

    def enviar(self, valor):
        """Envia o valor de temperatura para o canal ThingSpeak."""
        url = f"https://api.thingspeak.com/update?api_key={self.api_key}&field1={valor:.2f}"
        try:
            r = urequests.get(url)
            print("Resposta ThingSpeak:", r.text)
            r.close()
        except Exception as e:
            print("Erro ao enviar para ThingSpeak:", e)

