# main.py
from modules.sensor import SensorTemperatura
from modules.temporizador import esperar_ms
from modules.thingspeak_client import ThingSpeakClient
from config import *
import network
import time

def conectar_wifi():
    """Conecta ao Wi-Fi."""
    wlan = network.WLAN(network.STA_IF)
    wlan.active(True)
    wlan.connect(WIFI_SSID, WIFI_PASS)
    print("Conectando ao Wi-Fi...")
    while not wlan.isconnected():
        time.sleep(1)
        print("Tentando conexão...")
    print("Wi-Fi conectado:", wlan.ifconfig())
    return wlan

def main():
    wlan = conectar_wifi()
    sensor = SensorTemperatura(SENSOR_ADC_CHANNEL)
    ts = ThingSpeakClient(THINGSPEAK_API_KEY)

    while True:
        temperatura = sensor.ler()
        print(f"Temperatura medida: {temperatura:.2f} °C")

        ts.enviar(temperatura)
        print("Dados enviados para ThingSpeak com sucesso.\n")

        esperar_ms(INTERVALO_ENVIO_MS)

main()
